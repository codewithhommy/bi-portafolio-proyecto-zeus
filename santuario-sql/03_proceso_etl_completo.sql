-- PROCESO ETL COMPLETO - CARGA DEL MODELO DIMENSIONAL
-- Transformación de datos operacionales a modelo dimensional Kimball

-- 1. LIMPIAR TABLAS EXISTENTES (PARA RE-EJECUCIÓN)
TRUNCATE TABLE hechos_ventas CASCADE;
TRUNCATE TABLE dim_tiempo CASCADE;
TRUNCATE TABLE dim_cliente CASCADE;
TRUNCATE TABLE dim_producto CASCADE;

-- 2. POBLAR DIMENSIÓN TIEMPO
-- Extraemos todas las fechas únicas del sistema operacional
INSERT INTO dim_tiempo (
    fecha_completa, año, trimestre, mes, dia, 
    nombre_mes, nombre_dia_semana, es_fin_de_semana
)
SELECT DISTINCT
    fecha,
    EXTRACT(YEAR FROM fecha),
    EXTRACT(QUARTER FROM fecha),
    EXTRACT(MONTH FROM fecha),
    EXTRACT(DAY FROM fecha),
    TO_CHAR(fecha, 'Month'),
    TO_CHAR(fecha, 'Day'),
    EXTRACT(DOW FROM fecha) IN (0,6) -- 0=Dom, 6=Sab
FROM (
    SELECT order_date as fecha FROM orders
    UNION SELECT required_date FROM orders 
    UNION SELECT shipped_date FROM orders
    WHERE shipped_date IS NOT NULL
) fechas_unicas
WHERE fecha IS NOT NULL;

-- 3. POBLAR DIMENSIÓN CLIENTE
-- Transformamos datos de clientes con limpieza
INSERT INTO dim_cliente (
    cliente_id, nombre_compania, nombre_contacto, titulo_contacto,
    direccion, ciudad, region, codigo_postal, pais, telefono, fax,
    segmento_cliente
)
SELECT 
    customer_id,
    company_name,
    contact_name,
    contact_title,
    address,
    city,
    region,
    postal_code,
    country,
    phone,
    fax,
    -- Segmentación básica por país (en realidad sería más compleja)
    CASE 
        WHEN country IN ('USA', 'Canada') THEN 'Norte America'
        WHEN country IN ('UK', 'Germany', 'France') THEN 'Europa Occidental'
        WHEN country IN ('Brazil', 'Argentina') THEN 'America del Sur'
        ELSE 'Otros'
    END as segmento_cliente
FROM customers;

-- 4. POBLAR DIMENSIÓN PRODUCTO
-- Enriquecer productos con datos de categorías y proveedores
INSERT INTO dim_producto (
    nombre_producto, nombre_categoria, descripcion_categoria,
    nombre_proveedor, contacto_proveedor, ciudad_proveedor, pais_proveedor,
    precio_unitario, unidades_stock, unidades_pedidas, nivel_reorden, discontinuado
)
SELECT 
    p.product_name,
    c.category_name,
    c.description,
    s.company_name,
    s.contact_name,
    s.city,
    s.country,
    p.unit_price,
    p.units_in_stock,
    p.units_on_order,
    p.reorder_level,
    p.discontinued
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id;

-- 5. POBLAR TABLA DE HECHOS VENTAS
-- Transformación completa con cálculos de negocio
INSERT INTO hechos_ventas (
    tiempo_id, cliente_id, producto_id, empleado_id, transportista_id,
    orden_id, cantidad, precio_unitario, descuento,
    venta_bruta, descuento_total, venta_neta
)
SELECT 
    dt.tiempo_id,
    c.customer_id,
    dp.producto_id,
    o.employee_id,
    o.ship_via as transportista_id,
    od.order_id,
    od.quantity as cantidad,
    od.unit_price as precio_unitario,
    od.discount as descuento,
    -- Cálculos de negocio
    (od.quantity * od.unit_price) as venta_bruta,
    (od.quantity * od.unit_price * od.discount) as descuento_total,
    (od.quantity * od.unit_price * (1 - od.discount)) as venta_neta
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN dim_tiempo dt ON o.order_date = dt.fecha_completa
JOIN dim_cliente c ON o.customer_id = c.cliente_id
JOIN dim_producto dp ON od.product_id = dp.producto_id;

-- 6. VERIFICACIÓN Y MÉTRICAS DEL ETL
SELECT 
    'Dimensiones y Hechos Cargados' as proceso,
    (SELECT COUNT(*) FROM dim_tiempo) as registros_tiempo,
    (SELECT COUNT(*) FROM dim_cliente) as registros_cliente,
    (SELECT COUNT(*) FROM dim_producto) as registros_producto,
    (SELECT COUNT(*) FROM hechos_ventas) as registros_hechos,
    (SELECT ROUND(SUM(venta_neta),2) FROM hechos_ventas) as venta_neta_total;
