# Documentación Técnica del Proyecto Power BI: Satisfacción Cliente

## Resumen Ejecutivo
Este proyecto Power BI analiza la satisfacción y mantenimiento de clientes para Temporing ETT. El modelo incluye datos de facturación, contratos, comentarios de clientes y métricas de retención.

## Tablas del Modelo

### Tablas de Dimensiones
- **Calendario**: Tabla de fechas para análisis temporales
- **Clientes**: Información de clientes (centro, código, nombre, CIF, grupo, subgrupo)
- **MCANCentros**: Centros/delegaciones de la empresa
- **Meses**: Tabla de meses para análisis
- **Opciones**: Configuraciones o parámetros del sistema
- **Otramio**: Información adicional de clientes

### Tablas de Hechos
- **facturas**: Datos de facturación con fechas, importes y referencias a clientes
- **MovFra**: Movimientos de facturas
- **contratos**: Información de contratos de clientes
- **estadi**: Estadísticas o estados de clientes
- **Calmio**: Datos adicionales de facturación

### Tablas de Comentarios
- **Comentarios**: Comentarios de satisfacción de clientes incluyendo delegación, observaciones y persona de contacto
- **ClientesPerdidosTabla**: Análisis de clientes perdidos

## Relaciones del Modelo

- `contratos.ConCenCli` → `Clientes.ClCenCli`
- `Clientes.clcentro` → `MCANCentros.Id`
- `facturas.FraCenCli` → `Clientes.ClCenCli`
- `facturas.fcfecha` → `Calendario.Date`
- `MovFra.fcfecha` → `Calendario.Date`
- `MovFra.FraCenCli` → `Clientes.ClCenCli`
- `Comentarios.Del` → `MCANCentros.Id`
- `estadi.EsCenCli` → `Clientes.ClCenCli`

## Medidas Principales

### Medidas de Clientes
- **CliAFact**: Número total de clientes facturados
- **ClientesMinimo6Meses**: Clientes facturados al menos 6 meses en 2022
- **ClientesMinimo6Meses2**: Variante del cálculo anterior
- **ClientesMinimo6Meses3**: Usando fecha de facturación
- **ClientesMinimo6Meses4**: Versión simplificada
- **ClientesMinimo6Meses5**: Con filtro dinámico por meses
- **ClientesMinimo6Meses6**: Con filtro por año
- **ClientesMinimo6Meses7**: Versión dinámica por año seleccionado
- **Clientes ActivosSel**: Clientes con mínimo de meses facturados (dinámico)
- **Clientes Perdidos**: Clientes que no han sido facturados en el último año
- **Clientes Nuevos**: Clientes nuevos en el período seleccionado

### Medidas de Facturación
- **Meses FRa**: Número de filas de facturas

## Lógica General del Informe

El informe está estructurado en varias páginas que analizan diferentes aspectos del negocio:

1. **Mantenimiento Clientes**: Tablas con métricas por centro/delegación
2. **Otras páginas**: Análisis de facturas, comentarios, estadísticas, etc.

El modelo utiliza DAX para calcular métricas de retención y adquisición de clientes, con filtros temporales dinámicos. Los datos provienen de una base de datos SQL Server (10.10.138.5\temporing).

## Áreas de Análisis de Negocio

### 1. Retención de Clientes
- Identificación de clientes activos vs. perdidos
- Análisis de períodos de inactividad
- Métricas de clientes facturados por mes/año

### 2. Adquisición de Clientes
- Nuevos clientes por período
- Análisis de contratos activos

### 3. Satisfacción del Cliente
- Comentarios y observaciones de clientes
- Análisis por delegación y persona de contacto
- Identificación de áreas de mejora

### 4. Análisis Financiero
- Facturación por cliente y período
- Movimientos de facturas
- Análisis por centro/delegación

### 5. Gestión Operativa
- Mantenimiento de base de clientes
- Seguimiento de contratos
- Análisis geográfico por centros

## Recomendaciones de Mejora

1. **Consolidar medidas duplicadas**: Varias medidas calculan conceptos similares (ClientesMinimo6Meses1-7)
2. **Optimizar relaciones**: Verificar integridad referencial en las claves foráneas
3. **Añadir más dimensiones**: Considerar tablas de tiempo más granulares o categorías de clientes
4. **Incluir KPIs de satisfacción**: Métricas cuantitativas basadas en comentarios
5. **Automatizar refrescos**: Configurar actualizaciones automáticas de datos

## Fuentes de Datos
- Base de datos SQL Server: `10.10.138.5\temporing`, base `no3001`
- Tablas principales: clientes, contra, facturas
- Filtros: contratos activos o finalizados desde 2021, facturas desde 2021</content>
<parameter name="filePath">c:\Users\infor\Documents\prueba vscode\Satisfacción Cliente\Documentacion.md