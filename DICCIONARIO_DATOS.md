# DICCIONARIO DE DATOS Y GLOSARIO
## Evolución AsignacionesMCA 2026

---

## 📖 GLOSARIO DE TÉRMINOS

### Conceptos Clave

| Término | Definición | Contexto |
|---------|-----------|---------|
| **Asignación** | Contrato laboral activo entre un trabajador y un cliente en un período específico | Tabla `contratos` |
| **Centro** | Sucursal u oficina operacional de la organización | `MCANCentros` |
| **Cliente** | Empresa o entidad que genera demanda de trabajadores | Tabla `Clientes` |
| **Trabajador** | Empleado asignado a una o más asignaciones | Tabla `Trabajadores` |
| **Categoría** | Nivel o clasificación del puesto (Técnico, Junior, Senior, etc.) | Tabla `Categorias` |
| **Período** | Rango de datas específicas para análisis (mes, trimestre, año) | Tabla `Calendario` |
| **YoY** | Year-over-Year, comparativa del mismo período año anterior | Análisis temporal |
| **Altas** | Nuevos contratos iniciados en el período | Medida calculada |
| **Bajas** | Contratos finalizados en el período | Medida calculada |
| **Rotación** | Tasa de cambio de trabajadores (Altas + Bajas) | KPI RRHH |

---

## 🗂️ DICCIONARIO DE TABLAS

### 1. CONTRATOS - Tabla de Hechos Principal

**Descripción**: Registro de todas las asignaciones laborales de la empresa 01.

| Campo | Tipo | Descripción | Filtro | Ejemplo |
|-------|------|-------------|--------|---------|
| `ctcentro` | Int64 | Centro operacional | Centro != NULL | 01 |
| `ctcontrato` | Int64 | Identificador único del contrato | >= 1 | 123456 |
| `cttrabajador` | Int64 | ID del trabajador asignado | Válido | 45678901 |
| `ctcliente` | Int64 | ID cliente solicitante | Válido | 789 |
| `ctcencli` | Int64 | Centro del cliente | Válido | 15 |
| `ctfechaini` | DateTime | Fecha inicio contrato | >= 2019-01-01 | 2023-03-15 |
| `ctfechafinreal` | DateTime | Fecha fin real del contrato | <= TODAY() | 2023-12-31 |
| `ctcatepuesto` | Int64 | Categoría del puesto | Válido | 3 |

**Relaciones**:
- 1:N con `Trabajadores` (cttrabajador)
- 1:N con `Clientes` (ctcencli)
- 1:N con `Categorias` (ctcatepuesto)

---

### 2. CALENDARIO - Tabla de Dimensión Temporal

**Descripción**: Tabla de fechas generada con inteligencia temporal para análisis.

| Campo | Tipo | Descripción | Rango | Ejemplo |
|-------|------|-------------|-------|---------|
| `Date` | DateTime | Fecha completa | Dinámico | 2024-03-15 |
| `DateKey` | String | Clave YYYYMMDD | Dinámico | 20240315 |
| `Año` | Int64 | Año calendario | 2019-2026 | 2024 |
| `Mes (Número)` | Int64 | Mes (1-12) | 1-12 | 3 |
| `Mes (Corto)` | String | Abreviatura | Ene-Dic | Mar |
| `Mes` | String | Nombre completo | Enero-Diciembre | Marzo |
| `Año/Mes` | String | Formato YYYY/MM | Dinámico | 2024/03 |
| `Trimestre` | String | Trimestre | Q1-Q4 | Q1 |
| `Trimestre Año` | String | Fecha trimestral | Dinámico | Q1 2024 |
| `Día` | Int64 | Día del mes | 1-31 | 15 |
| `Semana` | Int64 | Semana del año | 1-53 | 11 |
| `Semana ISO` | Int64 | Semana ISO 8601 | 1-53 | 11 |
| `Año ISO` | Int64 | Año ISO | Dinámico | 2024 |
| `Día Semana (Número)` | Int64 | 0=domingo, 6=sábado | 0-6 | 5 |
| `WeekDay` | String | Día en inglés | Sun-Sat | Friday |
| `WeekDayShort` | String | Abreviatura | Sun-Sat | Fri |

**No tiene relaciones** (usar USERELATIONSHIP en DAX para análisis temporal)

---

### 3. CLIENTES - Tabla de Dimensión

**Descripción**: Maestro de empresas/entidades que contratan servicios.

| Campo | Tipo | Descripción | Filtro | Ejemplo |
|-------|------|-------------|--------|---------|
| `clcentro` | Int64 | Centro origen | Válido | 01 |
| `clcodigo` | Int64 | Código identificador | >= 1 | 789 |
| `clnombre` | String | Nombre comercial | !LIKE '%fijo%' | Acme Corp |
| `clcifdni` | String | CIF/DNI para facturación | - | B12345678 |
| `cclcnae` | String | Código CNAE | - | 6202 |
| `cclconvenio` | Int64 | Código convenio laboral | - | 1 |
| `ClCenCli` | String | Clave compuesta | - | 01000789 |

**Relaciones**:
- N:1 con `MCANCentros` (clcentro)
- 1:N con `contratos` (ClCenCli)

---

### 4. TRABAJADORES - Tabla de Dimensión

**Descripción**: Perfil demográfico y personal de empleados.

| Campo | Tipo | Descripción | Filtro | Ejemplo |
|-------|------|-------------|--------|---------|
| `cttrabajador` | Int64 | ID único del trabajador | - | 45678901 |
| `trsexo` | String | Sexo | H/M/XU | H |
| `trfechanac` | DateTime | Fecha de nacimiento | Válida | 1985-06-20 |
| `trnacionalidad` | String | País de origen | ISO-3 | ES |
| `trdiscapacidad` | Int64 | Con discapacidad | 0/1 | 0 |
| `Años` | Double | Edad actual | Calculado | 38.75 |

**Relaciones**:
- 1:N con `contratos` (cttrabajador)

---

### 5. CATEGORIAS - Tabla de Dimensión

**Descripción**: Clasificación de puestos/niveles laborales.

| Campo | Tipo | Descripción | Ejemplo |
|-------|------|-------------|---------|
| `cacodigo` | Int64 | Código de categoría | 3 |
| `canombre` | String | Nombre o descripción | Técnico Base |

**Relaciones**:
- 1:N con `contratos` (ctcatepuesto)

---

### 6. MCANCentros - Tabla de Referencia

**Descripción**: Maestro de centros/sucursales de la organización.

| Campo | Tipo | Descripción | Ejemplo |
|-------|------|-------------|---------|
| `Id` | Int64 | ID único del centro | 01 |
| `Sucursal` | Int64 | Código de sucursal | 001 |
| `Texto` | String | Información adicional | - |
| `Nombre` | String | Nombre del centro | Madrid Central |
| `Delegado` | String | Persona responsable | Juan Pérez |

**Relaciones**:
- 1:N con `Clientes` (Id → clcentro)

---

### 7. TIPCONTRA - Tabla de Dimensión

**Descripción**: Tipos de contratos laborales legales.

| Campo | Tipo | Descripción | Ejemplo |
|-------|------|-------------|---------|
| `ticontrato` | Int64 | ID tipo | 1 |
| `ticontofic` | Int64 | Código oficial | 010 |
| `tinombre` | String | Descripción | Contrato Indefinido |
| `titipo` | String | Clasificación | Permanente |

---

### 8. TABLA_FECHAS - Tabla de Series Temporal

**Descripción**: Serie de fechas diaria generada dinámicamente.

| Campo | Tipo | Descripción | Rango |
|-------|------|-------------|-------|
| `Value` | DateTime | Fecha diaria | Desde 01/01 año actual hasta ayer |

**Uso**: Análisis de frecuencias diarias, gráficos de tendencia granular.

---

## 🧮 DICCIONARIO DE MEDIDAS

### Grupo: Asignaciones Base

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `Asignaciones` | `COUNTA(contratos[ctcontrato])` | Total de contratos activos | Conteo |
| `AsignacionesAA` | `CALCULATE([Asignaciones], DATEADD(Calendario[Date], -1, YEAR))` | Asignaciones año anterior | Comparativa |
| `AsignacionesMA` | `CALCULATE([Asignaciones], DATEADD(Calendario[Date], -1, MONTH))` | Asignaciones mes anterior | Comparativa |

### Grupo: Crecimiento

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `Crecimiento` | `([Asignaciones] - [AsignacionesAA]) / [AsignacionesAA]` | % cambio año a año | Porcentaje |
| `CrecimientoMensual` | `([Asignaciones] - [AsignacionesMA]) / [AsignacionesMA]` | % cambio mes a mes | Porcentaje |

### Grupo: Movimientos de Personal

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `Altas` | SUMPRODUCT(FechaIni en período) | Contratos iniciados en período | Conteo |
| `Bajas` | SUMPRODUCT(FechaFin en período) | Contratos finalizados en período | Conteo |
| `Rotación` | `[Altas] + [Bajas]` | Total movimientos en período | Conteo |

### Grupo: Recursos Humanos

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `TrabActivos` | `DISTINCTCOUNT(contratos[cttrabajador])` | Trabajadores únicos activos | Conteo Dedup |
| `TrabActivosAA` | `CALCULATE([TrabActivos], DATEADD(Calendario[Date], -1, YEAR))` | Trabajadores año anterior | Comparativa |
| `TrabNuevos` | SUMPRODUCT(dedup por período) | Trabajadores incorporados en período | Conteo |

### Grupo: Productividad

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `Horas Realizadas` | `SUMPRODUCT(DATEDIFF(ini, fin, DAY) * 8)` | Horas totales (dias * 8h) | Agregación |
| `Media Horas/Trab` | `[Horas Realizadas] / [TrabActivos]` | Promedio horas por trabajador | Ratio |

### Grupo: Calendario y Filtros Temporales

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `fecini` | `FIRSTDATE(Calendario[Date])` | Fecha inicial del período | Filtro |
| `fecfin` | `LASTDATE(Calendario[Date])` | Fecha final del período | Filtro |
| `feciniaa` | `FIRSTDATE(DATEADD(Calendario[Date], -1, YEAR))` | Inicio año anterior | Filtro |
| `fecfinaa` | `LASTDATE(DATEADD(Calendario[Date], -1, YEAR))` | Fin año anterior | Filtro |
| `fecinisp` | `FIRSTDATE(DATEADD(Calendario[Date], -7, DAY))` | 7 días atrás | Filtro |
| `fecfinsp` | `LASTDATE(Calendario[Date])` | Hoy | Filtro |
| `fecinimp` | `FIRSTDATE(DATEADD(Calendario[Date], -31, DAY))` | 31 días atrás | Filtro |
| `fecfinmp` | `LASTDATE(Calendario[Date])` | Hoy | Filtro |
| `fecfinay2` | `TODAY() - 1` | Ayer (excluye hoy) | Filtro |

### Grupo: Clientes

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `TotClientes` | `COUNTA(Clientes[clcodigo])` | Total clientes únicos | Conteo |

### Grupo: Empresa 17 (BWContra)

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `BWAsig` | `COUNTA(BWContra[ctcontrato])` | Asignaciones empresa 17 | Conteo |
| `BWMedAsig` | `AVERAGE(BWContra[duración_días])` | Duración promedio días | Ratio |

### Grupo: Centro DUN

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `Dun Asignaciones` | `COUNTA(Duncontra[ctcontrato])` | Asignaciones DUN | Conteo |
| `Dun MedAsignac` | `AVERAGE(Duncontra[duración_días])` | Duración promedio días | Ratio |
| `Dun TrabActivos` | `DISTINCTCOUNT(Duncontra[cttrabajador])` | Trabajadores activos DUN | Conteo Dedup |
| `% DunMesAnter` | `([Dun Asig] - [Dun Asig MA]) / [Dun Asig MA]` | % cambio mes anterior | Porcentaje |

### Grupo: Empresa 1 (IntContra)

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `IntAsig` | `COUNTA(IntContra[ctcontrato])` | Asignaciones empresa 1 | Conteo |
| `IntTrabaj` | `DISTINCTCOUNT(IntContra[cttrabajador])` | Trabajadores únicos | Conteo Dedup |
| `IntTraMAsig` | `DIVIDE([IntAsig], [IntTrabaj])` | Asignaciones por trabajador | Ratio |

### Grupo: Empresa 26 (NonoContra)

| Medida | Fórmula | Definición | Tipo |
|--------|---------|-----------|------|
| `NonoAsig` | `COUNTA(NonoContra[ctcontrato])` | Asignaciones empresa 26 | Conteo |
| `NonoMedAsig` | `AVERAGE(NonoContra[duración_días])` | Duración promedio | Ratio |

---

## 🗂️ COLUMNAS CALCULADAS

| Tabla | Columna | Fórmula | Propósito |
|-------|---------|---------|-----------|
| **Clientes** | `ClCenCli` | `FORMAT(clcentro,"00") & FORMAT(clcodigo,"000000")` | Clave compuesta Centro+Código |
| **Trabajadores** | `Años` | `DATEDIFF(trfechanac, TODAY(), YEAR)` | Edad actual del trabajador |
| **IntContra** | `IntTCenTra` | `FORMAT(ctcentro,"00") & FORMAT(cttrabajador,"00000000")` | Clave Centro+Trabajador |

---

## 🔍 FILTROS POR DEFECTO

### Filtro temporales

```
Todas las tablas de hechos:
  ctfechaini >= 2019-01-01    (Histórico mínimo)
  ctfechafinreal <= TODAY()    (Realidad, sin especulación)
```

### Filtros de validez

```
contratos:
  ctcentro != NULL

Clientes:
  clnombre NOT LIKE '%fijo%'   (Excluye clientes internos/fijos)
```

---

## 🎯 PATRONES DE USO FRECUENTE

### Patrón 1: Análisis YoY Estándar
```dax
Selecciona: [Asignaciones], [AsignacionesAA], [Crecimiento]
Filtra por: Centro, Cliente, Período
Visualiza: Gráfico línea + KPI
```

### Patrón 2: RRHH Analytics
```dax
Selecciona: [TrabActivos], [Altas], [Bajas]
Filtra por: Período, Categoría, Centro
Visualiza: Tabla con sparklines
```

### Patrón 3: Temporal Dinámico
```dax
Selecciona: [fecini], [fecfin]
Usa para: Rango dinámico en filtros
Nota: Cambiar manualmente período sin recompilación DAX
```

### Patrón 4: Dedup de Trabajadores
```dax
Selecciona: [TrabActivos], [Horas Realizadas]
Calcula: [Media Horas/Trab]
Nota: DISTINCTCOUNT elimina duplicados automáticamente
```

---

## ⚠️ NOTAS Y RESTRICCIONES

| Aspecto | Nota |
|--------|------|
| **Empresas separadas** | 01, 4, 17, 1, 26 son independientes - no hay relación cruzada |
| **Tabla_Fechas** | No está relacionada - usar USERELATIONSHIP en DAX |
| **Time Intelligence** | Deshabilitada - requiere DATEADD explícito |
| **Período mínimo** | 2019 (filtros automáticos) |
| **Cálculo de horas** | Asume 8h/día sin consideración de festivos/permisos |
| **DISTINCTCOUNT** | Elimina duplicados de trabajador (múltiples asignaciones) |

---

## 📚 REFERENCIAS CRUZADAS

- **Documentación completa**: DOCUMENTACION_MODELO.md
- **Resumen ejecutivo**: RESUMEN_EJECUTIVO.md
- **Archivo de definición**: Evolución AsignacionesMCA 2026.SemanticModel/definition/

---

**Última actualización**: 30 de marzo de 2026
