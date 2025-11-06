-- 🔮 01_profecia_inicial.sql
-- LA VISIÓN DE APOLO - ANÁLISIS EXPLORATORIO INICIAL
-- Propósito: Desvelar los secretos y estructura de los datos Northwind

-- 1. EL CENSO DEL OLIMPO - Mapa completo de tablas
SELECT 
    table_name as tabla_olimpica,
    (SELECT COUNT(*) FROM information_schema.columns 
     WHERE table_name = t.table_name) as columnas_sagradas,
    (xpath('/row/cnt/text()', 
          query_to_xml(format('SELECT COUNT(*) as cnt FROM %I', table_name), 
          false, true, '')))[1]::text::int as almas_registradas
FROM information_schema.tables t
WHERE table_schema = 'public'
ORDER BY almas_registradas DESC;

-- 2. PROFECÍA DE LAS ORDENES - Análisis temporal
SELECT 
    COUNT(*) as total_ordenes,
    MIN(order_date) as era_antigua,
    MAX(order_date) as era_actual,
    MAX(order_date) - MIN(order_date) as rango_temporal,
    COUNT(DISTINCT customer_id) as devotos_unicos,
    COUNT(DISTINCT employee_id) as sacerdotes_activos
FROM orders;

-- 3. EL TESORO COMERCIAL - Análisis financiero
SELECT
    COUNT(*) as total_transacciones,
    SUM(quantity) as productos_vendidos,
    ROUND(AVG(unit_price)::numeric, 2) as precio_promedio,
    ROUND(SUM(quantity * unit_price)::numeric, 2) as tesoro_total,
    ROUND(SUM(quantity * unit_price * discount)::numeric, 2) as ofrendas_descontadas
FROM order_details;

-- 4. SANTUARIO DE PRODUCTOS - Catálogo divino
SELECT
    COUNT(*) as total_productos,
    COUNT(DISTINCT category_id) as categorias_sagradas,
    COUNT(DISTINCT supplier_id) as proveedores_confiables,
    ROUND(AVG(unit_price)::numeric, 2) as precio_promedio,
    SUM(units_in_stock) as inventario_total,
    SUM(units_on_order) as productos_pedidos
FROM products;

-- 5. DEVOTOS FIELES - Análisis de clientes
SELECT
    COUNT(*) as total_clientes,
    COUNT(DISTINCT country) as reinos_representados,
    COUNT(DISTINCT city) as ciudades_santuario
FROM customers;
