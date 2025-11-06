-- CONSULTAS ANALÍTICAS SOBRE EL MODELO DIMENSIONAL
-- Demostrando el poder del modelo Kimball para business intelligence

-- 1. VENTAS POR AÑO Y MES (TENDENCIA TEMPORAL)
SELECT 
    dt.año,
    dt.nombre_mes,
    ROUND(SUM(hv.venta_neta), 2) as ventas_netas,
    COUNT(DISTINCT hv.orden_id) as ordenes_totales,
    ROUND(AVG(hv.venta_neta), 2) as ticket_promedio
FROM hechos_ventas hv
JOIN dim_tiempo dt ON hv.tiempo_id = dt.tiempo_id
GROUP BY dt.año, dt.mes, dt.nombre_mes
ORDER BY dt.año, dt.mes;

-- 2. TOP 10 PRODUCTOS MÁS VENDIDOS
SELECT 
    dp.nombre_producto,
    dp.nombre_categoria,
    ROUND(SUM(hv.venta_neta), 2) as ventas_totales,
    SUM(hv.cantidad) as unidades_vendidas,
    ROUND(SUM(hv.venta_neta) / SUM(hv.cantidad), 2) as precio_promedio
FROM hechos_ventas hv
JOIN dim_producto dp ON hv.producto_id = dp.producto_id
GROUP BY dp.nombre_producto, dp.nombre_categoria
ORDER BY ventas_totales DESC
LIMIT 10;

-- 3. ANÁLISIS DE CLIENTES POR SEGMENTO Y PAÍS
SELECT 
    dc.segmento_cliente,
    dc.pais,
    COUNT(DISTINCT hv.cliente_id) as clientes_unicos,
    ROUND(SUM(hv.venta_neta), 2) as ventas_totales,
    ROUND(SUM(hv.venta_neta) / COUNT(DISTINCT hv.cliente_id), 2) as valor_promedio_cliente
FROM hechos_ventas hv
JOIN dim_cliente dc ON hv.cliente_id = dc.cliente_id
GROUP BY dc.segmento_cliente, dc.pais
ORDER BY ventas_totales DESC;

-- 4. EFECTIVIDAD DE DESCUENTOS
SELECT 
    CASE 
        WHEN hv.descuento = 0 THEN 'Sin Descuento'
        WHEN hv.descuento <= 0.1 THEN 'Descuento Bajo (<=10%)'
        WHEN hv.descuento <= 0.2 THEN 'Descuento Medio (11-20%)'
        ELSE 'Descuento Alto (>20%)'
    END as categoria_descuento,
    COUNT(*) as transacciones,
    ROUND(SUM(hv.venta_bruta), 2) as venta_bruta,
    ROUND(SUM(hv.descuento_total), 2) as descuento_total,
    ROUND(SUM(hv.venta_neta), 2) as venta_neta,
    ROUND(SUM(hv.descuento_total) / SUM(hv.venta_bruta) * 100, 2) as porcentaje_descuento_promedio
FROM hechos_ventas hv
GROUP BY categoria_descuento
ORDER BY venta_neta DESC;

-- 5. MÉTRICAS DE NEGOCIO RESUMEN
SELECT 
    'RESUMEN EJECUTIVO' as metrica,
    COUNT(DISTINCT hv.cliente_id) as clientes_activos,
    COUNT(DISTINCT hv.producto_id) as productos_vendidos,
    COUNT(DISTINCT hv.orden_id) as ordenes_totales,
    ROUND(SUM(hv.venta_neta), 2) as ventas_netas_totales,
    ROUND(AVG(hv.venta_neta), 2) as valor_promedio_orden,
    ROUND(SUM(hv.descuento_total), 2) as descuentos_aplicados,
    ROUND(SUM(hv.descuento_total) / SUM(hv.venta_bruta) * 100, 2) as tasa_descuento_promedio
FROM hechos_ventas hv;
