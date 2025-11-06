# DISEÑO DEL MODELO DIMENSIONAL - METODOLOGÍA KIMBALL

## CONTEXTO DE NEGOCIO
Northwind Traders es una empresa de distribución que necesita analizar:
- Rendimiento de ventas por periodo, producto y región
- Comportamiento de clientes y empleados
- Eficiencia de envíos y gestión de inventario

## TABLA DE HECHOS PRINCIPAL: HECHOS_VENTAS
**Granularidad:** Por línea de detalle de orden

**Métricas:**
- cantidad (quantity)
- precio_unitario (unit_price) 
- descuento (discount)
- venta_neta (calculada: quantity * unit_price * (1 - discount))

## DIMENSIONES PROPUESTAS:

### DIM_TIEMPO
- tiempo_id (PK)
- fecha_completa
- año, trimestre, mes, dia
- semestre, semana
- es_fin_de_semana
- periodo_fiscal

### DIM_CLIENTE  
- cliente_id (PK)
- nombre_compania
- nombre_contacto
- titulo_contacto
- ciudad, region, pais
- telefono
- segmento_cliente (calculado)

### DIM_PRODUCTO
- producto_id (PK)
- nombre_producto
- nombre_categoria
- nombre_proveedor
- precio_unitario
- unidades_stock
- unidades_pedidas
- nivel_reorden
- discontinuado

### DIM_EMPLEADO
- empleado_id (PK)
- nombre_completo
- titulo
- ciudad, region, pais
- fecha_contratacion
- reporta_a (jerarquia)

### DIM_TRANSPORTISTA
- transportista_id (PK)
- nombre_compania
- telefono
