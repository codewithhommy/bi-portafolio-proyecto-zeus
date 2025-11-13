# Proyecto Zeus - Business Intelligence Analyst Portfolio

## Descripción del Proyecto
Análisis completo de Business Intelligence para Northwind Traders implementando metodología Kimball de Data Warehousing. Transformé datos operacionales en insights estratégicos para toma de decisiones.

## Habilidades Demostradas

### Data Analysis & Profiling
- Análisis exploratorio de datos (Data Profiling)
- comprensión de estructura y relaciones de datos
- Identificación de métricas clave de negocio

### Data Modeling (Kimball)
- Diseño de modelo dimensional con tablas de hechos y dimensiones
- Implementación de metodología Kimball para Data Warehousing
- Definición de granularidad y relaciones entre entidades

### ETL Development
- Procesos completos de Extracción, Transformación y Carga
- Transformación de datos operacionales a modelo dimensional
- Cálculo de métricas de negocio (ventas netas, descuentos, márgenes)

### SQL Avanzado
- Consultas complejas con JOINs múltiples
- Agregaciones y análisis temporal
- Subqueries y funciones de ventana

## Hallazgos de Negocio

### Métricas Principales
- **$1,265,792.95** en ventas netas analizadas
- **89 clientes** segmentados por valor y región
- **77 productos** con análisis de performance
- **830 órdenes** procesadas y transformadas

### Insights Estratégicos
- **Crecimiento constante** de ventas: $27K (Jul/1996) a $123K (Abr/1998)
- **Producto estrella**: Côte de Blaye con $141,396 en ventas
- **Clientes más valiosos**: Segmento alemán con $20K promedio por cliente
- **Efectividad de descuentos**: 6.55% de tasa promedio de descuento

## Stack Tecnológico
- **Database**: PostgreSQL
- **Metodología**: Kimball Dimensional Modeling
- **SQL**: Consultas avanzadas y optimización
- **ETL**: Procesos completos de transformación
- **Version Control**: Git & GitHub

## Estructura del Proyecto
proyecto-zeus/

├── santuario-sql/ # Scripts SQL organizados por fase

├── templo-documentacion/ # Documentación técnica y de negocio

└── oraculo-datos/ # Dataset Northwind original

## Cómo Ejecutar
1. Cargar dataset: `psql -f oraculo-datos/northwind.sql`
2. Ejecutar ETL: `psql -f santuario-sql/03_proceso_etl_completo_corregido.sql`
3. Consultas analíticas: `psql -f santuario-sql/04_consultas_analiticas.sql`


