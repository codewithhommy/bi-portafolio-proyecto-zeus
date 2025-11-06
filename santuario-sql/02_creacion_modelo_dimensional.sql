-- CREACIÓN DEL MODELO DIMENSIONAL KIMBALL
-- Implementación de las tablas dimensiones y hechos

-- 1. DIMENSIÓN TIEMPO
CREATE TABLE dim_tiempo (
    tiempo_id SERIAL PRIMARY KEY,
    fecha_completa DATE NOT NULL UNIQUE,
    año INTEGER NOT NULL,
    trimestre INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    dia INTEGER NOT NULL,
    nombre_mes VARCHAR(20),
    nombre_dia_semana VARCHAR(20),
    es_fin_de_semana BOOLEAN,
    periodo_fiscal VARCHAR(10)
);

-- 2. DIMENSIÓN CLIENTE
CREATE TABLE dim_cliente (
    cliente_id VARCHAR(10) PRIMARY KEY,
    nombre_compania VARCHAR(100) NOT NULL,
    nombre_contacto VARCHAR(50),
    titulo_contacto VARCHAR(50),
    direccion TEXT,
    ciudad VARCHAR(50),
    region VARCHAR(50),
    codigo_postal VARCHAR(20),
    pais VARCHAR(50),
    telefono VARCHAR(25),
    fax VARCHAR(25),
    segmento_cliente VARCHAR(20)
);

-- 3. DIMENSIÓN PRODUCTO
CREATE TABLE dim_producto (
    producto_id SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    nombre_categoria VARCHAR(50),
    descripcion_categoria TEXT,
    nombre_proveedor VARCHAR(100),
    contacto_proveedor VARCHAR(50),
    ciudad_proveedor VARCHAR(50),
    pais_proveedor VARCHAR(50),
    precio_unitario NUMERIC(10,2),
    unidades_stock INTEGER,
    unidades_pedidas INTEGER,
    nivel_reorden INTEGER,
    discontinuado BOOLEAN
);

-- 4. TABLA DE HECHOS VENTAS
CREATE TABLE hechos_ventas (
    venta_id SERIAL PRIMARY KEY,
    tiempo_id INTEGER REFERENCES dim_tiempo(tiempo_id),
    cliente_id VARCHAR(10) REFERENCES dim_cliente(cliente_id),
    producto_id INTEGER REFERENCES dim_producto(producto_id),
    empleado_id INTEGER,
    transportista_id INTEGER,
    orden_id INTEGER,
    cantidad NUMERIC(10,2),
    precio_unitario NUMERIC(10,2),
    descuento NUMERIC(4,2),
    venta_bruta NUMERIC(12,2),
    descuento_total NUMERIC(12,2),
    venta_neta NUMERIC(12,2),
    costo_estimado NUMERIC(12,2),
    margen_bruto NUMERIC(12,2)
);
