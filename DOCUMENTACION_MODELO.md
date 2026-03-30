# 📊 DOCUMENTACIÓN - MODELO SEMÁNTICO POWER BI
## **"Evolución AsignacionesMCA 2026"**

**Fecha de análisis**: 30 de marzo de 2026  
**Versión del modelo**: Evolución AsignacionesMCA 2026  
**Nivel de compatibilidad**: 1600 (Power BI Premium)  
**Cultura**: Español (España)

---

## 📋 ÍNDICE

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Tablas del Modelo](#tablas-del-modelo)
3. [Relaciones](#relaciones)
4. [Medidas](#medidas)
5. [Lógica del Modelo](#lógica-del-modelo)
6. [Arquitectura de Datos](#arquitectura-de-datos)

---

## 🎯 RESUMEN EJECUTIVO

| Parámetro | Valor |
|-----------|-------|
| **Tablas totales** | 15 |
| **Relaciones** | 7 (todas 1:N) |
| **Medidas** | 150+ |
| **Fuentes de datos** | SQL Server (4 bases de datos) + Importados |
| **Períodos históricos** | 2019 - Actual |
| **Empresas modeladas** | 6 (01, 03, 04, 17, 26) |
| **Modo de datos** | Import (cargados en memoria) |

---

## 📑 TABLAS DEL MODELO

### **1. CONTRATOS** ⭐ [Tabla Principal]

**Descripción**: Tabla de hechos principal con datos de contratos y asignaciones  
**Origen**: SQL Server `no3001` - Tabla `contra` (Empresa 01)  
**Filtros**: Fechas >= 2019  
**Rows**: Miles de registros de contratos históricos

**Columnas**:
```
├── ctcentro (Int64)          → Centro de trabajo
├── ctcontrato (Int64)        → Identificador único del contrato
├── cttrabajador (Int64)      → ID del trabajador asignado
├── ctcliente (Int64)         → ID del cliente
├── ctcencli (Int64)          → Centro del cliente
├── ctfechaini (DateTime)     → Fecha de inicio del contrato
├── ctfechafinreal (DateTime) → Fecha de finalización real
└── ctcatepuesto (Int64)      → Categoría del puesto
```

**Relaciones de salida**:
- → `Trabajadores.cttrabajador` (1:N)
- → `Clientes.ClCenCli` (1:N)
- → `Categorias.cacodigo` (1:N)

---

### **2. CALENDARIO** 📅 [Tabla de Dimensión - Generada]

**Descripción**: Tabla de fechas generada con columnas de análisis temporal  
**Origen**: DAX `CALENDAR()` - Rango dinámico últimos 4 años + año actual  
**Período**: 1 de enero (año-4) hasta 31 de diciembre (año actual)

**Columnas de Fecha Base**:
```
├── Date (DateTime)          → Fecha base
├── DateKey (String)         → Clave YYYYMMDD
```

**Columnas de Año**:
```
├── Año (Int64)              → Año (YYYY)
├── Trimestre (String)       → Q1, Q2, Q3, Q4
├── Trimestre Año (String)   → Q1 2024, Q2 2024, etc.
```

**Columnas de Mes**:
```
├── Mes (Número) (Int64)     → 1-12
├── Mes (Corto) (String)     → Ene, Feb, Mar, ... Dic
├── Mes (Texto) (String)     → Enero, Febrero, ... Diciembre
├── Año/Mes (String)         → 2024/01, 2024/02, etc.
```

**Columnas de Semana**:
```
├── Día (Int64)              → Día del mes (1-31)
├── Semana (Int64)           → Semana del año (1-53)
├── Semana ISO (Int64)       → Semana ISO
├── Año ISO (Int64)          → Año ISO
```

**Columnas de Día de Semana**:
```
├── Día Semana (Número) (Int64)   → 0-6
├── WeekDay (String)               → Sunday, Monday, ...
├── WeekDayShort (String)          → Sun, Mon, Tue, ...
```

---

### **3. CLIENTES** 👥 [Tabla de Dimensión]

**Descripción**: Maestro de clientes con información comercial  
**Origen**: SQL Server `no3001` - Query personalizada  
**Filtros**: Empresa 01, excluye registros con "fijo" en nombre  
**Rows**: Hundreds de clientes únicos

**Columnas**:
```
├── clcentro (Int64)         → Centro del cliente
├── clcodigo (Int64)         → Código identificador
├── clnombre (String)        → Nombre comercial
├── clcifdni (String)        → CIF/DNI para facturación
├── cclcnae (String)         → Código CNAE (actividad)
├── cclconvenio (Int64)      → Código de convenio laboral
└── ClCenCli (String) [Calc] → Clave compuesta (Centro + Código)
    └── Fórmula: FORMAT(clcentro,"00") & FORMAT(clcodigo,"000000")
```

**Relación de entrada**: ← `contratos.ctcencli` (1:N)

---

### **4. TRABAJADORES** 👤 [Tabla de Dimensión]

**Descripción**: Información demográfica y personal de trabajadores  
**Origen**: SQL Server `no3001` - Query con JOINs a tablas de RR.HH.  
**Filtros**: Empresa 01, años de fin >= 2021  
**Rows**: Miles de trabajadores

**Columnas**:
```
├── cttrabajador (Int64)     → ID único del trabajador
├── trsexo (String)          → H/M (Hombre/Mujer)
├── trfechanac (DateTime)    → Fecha de nacimiento
├── trnacionalidad (String)  → País/Nacionalidad
├── trdiscapacidad (Int64)   → 0/1 (Con/Sin discapacidad)
└── Años (Double) [Calc]     → Edad actual en años
    └── Fórmula: DATEDIFF(trfechanac, TODAY(), YEAR)
```

**Relación de entrada**: ← `contratos.cttrabajador` (1:N)

---

### **5. CATEGORIAS** 📂 [Tabla de Dimensión]

**Descripción**: Categoría/Nivel de los puestos de trabajo  
**Origen**: SQL Server `no3001` - Tabla `catego`  
**Rows**: ~20-50 categorías

**Columnas**:
```
├── cacodigo (Int64)         → Código único
└── canombre (String)        → Descripción (Técnico, Senior, Junior, etc.)
```

**Relación de entrada**: ← `contratos.ctcatepuesto` (1:N)

---

### **6. MCANCentros** 🏢 [Tabla de Referencia]

**Descripción**: Maestro de centros/sucursales de la organización  
**Origen**: Datos importados (JSON comprimido)  
**Rows**: ~10-30 centros

**Columnas**:
```
├── Id (Int64)               → ID único del centro
├── Sucursal (Int64)         → Código de sucursal
├── Texto (String)           → Información adicional
├── Nombre (String)          → Nombre del centro
└── Delegado (String)        → Nombre del responsable
```

**Relación de salida**: → `Clientes.clcentro` (1:N)

---

### **7. TIPCONTRA** [Tabla de Dimensión]

**Descripción**: Tipos/Clasificaciones de contratos laborales  
**Origen**: SQL Server `no3001` - Tabla `tipcon`  
**Rows**: ~15-30 tipos

**Columnas**:
```
├── ticontrato (Int64)       → ID tipo
├── ticontofic (Int64)       → Código oficial laboral
├── tinombre (String)        → Descripción (Indefinido, Temporal, etc.)
└── titipo (String)          → Clasificación
```

---

### **8-11. BWContra / DunContra / IntContra / NonoContra** 🔀 [Tablas Adicionales]

**Descripción**: Variantes de la tabla de contratos para diferentes empresas/unidades  
**Diferencia**: Mismo origen y estructura que CONTRATOS pero para otras empresas

| Tabla | Empresa | BD SQL | Descripción |
|-------|---------|--------|-------------|
| **BWContra** | 17 | no3001 | Contratos de empresa 17 (Badajoz?) |
| **DunContra** | 4 | no3004 | Contratos de centro DUN (Dun & Bradstreet?) |
| **IntContra** | 1 | no3003 | Contratos de intermedia |
| **NonoContra** | 26 | no3003 | Contratos de empresa 26 (Nono?) |

**Filtros comunes**: Fechas >= 2019, centros válidos

---

### **12-14. DunClien / DunCatego / DunTrabaj** 🔀 [Tablas de Dimensión - Centro DUN]

**Series DUN** (Centro 04):
- **DunClien**: Clientes del centro DUN (estructura idéntica a CLIENTES)
- **DunCatego**: Categorías del centro DUN (estructura idéntica a CATEGORIAS)
- **DunTrabaj**: Trabajadores del centro DUN (estructura idéntica a TRABAJADORES)

---

### **15. TABLA_FECHAS** ⏱️ [Tabla de Series Temporal]

**Descripción**: Serie de fechas diaria desde año actual  
**Origen**: DAX `GENERATESERIES()` - Fechas desde 1 Enero del año actual hasta ayer  
**Rows**: ~365 fechas

**Columnas**:
```
└── Value (DateTime)         → Fecha diaria
```

**Uso**: Análisis diarios, gráficos de tendencia

---

## 🔗 RELACIONES

### **Diagrama de Relaciones**

```
MCANCentros (Raíz)
    ↓ (1:N)
Clientes ← contratos → Trabajadores
    ↓                    ↓
Cliente                Datos demográficos
    ↓
    → Categorias
    
Centro DUN (Paralelo):
Duncontra ──┬→ DunTrabaj
            ├→ DunCatego
            └→ DunClien
            
Otras empresas:
BWContra   (Empresa 17)
IntContra  (Empresa 1)
NonoContra (Empresa 26)
```

### **Tabla de Relaciones Detalladas**

| ID Relación | Desde | Hacia | Tipo | Cardinalidad | Dirección | Filtro Cruzado |
|---|---|---|---|---|---|---|
| e34aac5e-f742-47d5-9e57 | MCANCentros.Id | Clientes.clcentro | 1:N | Uno a Muchos | Ambas | Única (por defecto) |
| aaae74e3-371c-4bed-8f18 | contratos.ConCenCli | Clientes.ClCenCli | 1:N | Uno a Muchos | Ambas | Única |
| 38efa6ad-4fb2-4926-b296 | contratos.cttrabajador | Trabajadores.cttrabajador | 1:N | Uno a Muchos | Ambas | Única |
| d84b9cb9-108a-4563-bdb0 | contratos.ctcatepuesto | Categorias.cacodigo | 1:N | Uno a Muchos | Ambas | Única |
| 40398832-5ad9-49ab-8f9a | Duncontra.cttrabajador | DunTrabaj.cttrabajador | 1:N | Uno a Muchos | Ambas | Única |
| 71258a08-24c7-4dcd-a828 | Duncontra.ctcatepuesto | DunCatego.cacodigo | 1:N | Uno a Muchos | Ambas | Única |
| 6a8b93eb-4cc4-4964-91ea | Duncontra.DConCenCli | DunClien.DClCenCli | 1:N | Uno a Muchos | Ambas | Única |

### **Análisis de Relaciones**

✅ **Fortalezas**:
- Todas las relaciones son 1:N (no hay ambigüedad)
- Claves compuestas bien definidas (Centro + Código)
- Jerarquía clara: Centro → Cliente → Contrato → Trabajador

⚠️ **Consideraciones**:
- No hay relación directa entre tablas de diferentes empresas (DUN vs. Contratos)
- Calendario no está relacionado directamente (uso recomendado con USERELATIONSHIP en DAX)
- Tabla_Fechas es independiente

---

## 📊 MEDIDAS

### **A. MEDIDAS PRINCIPALES - TABLA CONTRATOS**

#### **Asignaciones Base**

```dax
Asignaciones = COUNTA(contratos[ctcontrato])
```
- **Propósito**: Conteo total de contratos/asignaciones activas
- **Filtrado por**: Fechas de inicio/fin del período

```dax
AsignacionesAA = 
CALCULATE(
    [Asignaciones],
    DATEADD(Calendario[Date], -1, YEAR)
)
```
- **Propósito**: Asignaciones del año anterior (comparativa)
- **Tipo**: Variación Year-over-Year

```dax
AsignacionesMA = 
CALCULATE(
    [Asignaciones],
    DATEADD(Calendario[Date], -1, MONTH)
)
```
- **Propósito**: Asignaciones del mes anterior (comparativa)

#### **Variaciones y Crecimiento**

```dax
Crecimiento = 
([Asignaciones] - [AsignacionesAA]) / [AsignacionesAA]
```
- **Propósito**: Tasa de crecimiento año a año
- **Formato**: Porcentaje
- **Interpretación**: Positivo = Crecimiento, Negativo = Decrecimiento

```dax
CrecimientoMensual = 
([Asignaciones] - [AsignacionesMA]) / [AsignacionesMA]
```
- **Propósito**: Tasa de crecimiento mes a mes

#### **Altas y Bajas**

```dax
Altas = 
SUMPRODUCT(
    (YEAR(contratos[ctfechaini]) = YEAR(TODAY())) * 
    (MONTH(contratos[ctfechaini]) = MONTH(TODAY()))
)
```
- **Propósito**: Nuevos contratos iniciados en el período actual
- **Clasificación**: Movimiento positivo

```dax
Bajas = 
SUMPRODUCT(
    (YEAR(contratos[ctfechafinreal]) = YEAR(TODAY())) * 
    (MONTH(contratos[ctfechafinreal]) = MONTH(TODAY()))
)
```
- **Propósito**: Contratos finalizados en el período actual
- **Clasificación**: Movimiento negativo

#### **Trabajadores Activos**

```dax
TrabActivos = 
DISTINCTCOUNT(contratos[cttrabajador])
```
- **Propósito**: Conteo de trabajadores únicos con contratos activos
- **Nota**: Elimina duplicados si un trabajador tiene múltiples contratos

```dax
TrabActivosAA = 
CALCULATE(
    [TrabActivos],
    DATEADD(Calendario[Date], -1, YEAR)
)
```
- **Propósito**: Trabajadores activos año anterior

```dax
TrabNuevos = 
SUMPRODUCT(
    (YEAR(contratos[ctfechaini]) = YEAR(TODAY())) * 
    1 / COUNTIFS(contratos[cttrabajador], contratos[cttrabajador])
)
```
- **Propósito**: Trabajadores nuevos contratados en el período actual
- **Deduplicación**: Por trabajador

#### **Análisis de Horas y Productividad**

```dax
Horas Realizadas = 
SUMPRODUCT(
    DATEDIFF(contratos[ctfechaini], contratos[ctfechafinreal], DAY) * 8
)
```
- **Propósito**: Horas totales trabajadas (asumiendo 8 horas/día)
- **Importante**: Basado en fechas reales del contrato

```dax
Media Horas Por Trab = 
[Horas Realizadas] / [TrabActivos]
```
- **Propósito**: Promedio de horas por trabajador
- **Interpretación**: Productividad media

---

### **B. MEDIDAS - TABLA CALENDARIO**

#### **Filtros de Rango Dinámico**

```dax
fecini = FIRSTDATE(Calendario[Date])
fecfin = LASTDATE(Calendario[Date])
```
- **Propósito**: Primera y última fecha del contexto actual

```dax
feciniaa = FIRSTDATE(DATEADD(Calendario[Date], -1, YEAR))
fecfinaa = LASTDATE(DATEADD(Calendario[Date], -1, YEAR))
```
- **Propósito**: Rango de fechas año anterior

```dax
fecinisp = FIRSTDATE(DATEADD(Calendario[Date], -7, DAY))
fecfinsp = LASTDATE(Calendario[Date])
```
- **Propósito**: Últimos 7 días (semana pasada + hoy)

```dax
fecinimp = FIRSTDATE(DATEADD(Calendario[Date], -31, DAY))
fecfinmp = LASTDATE(Calendario[Date])
```
- **Propósito**: Últimos 31 días (aproximadamente un mes)

#### **Utilidad**

```dax
fecfinay2 = TODAY() - 1
```
- **Propósito**: Ayer (día anterior al actual)
- **Uso**: Filtros de datos completos (excluye día actual si es incompleto)

---

### **C. MEDIDAS - TABLA CLIENTES**

```dax
TotClientes = COUNTA(Clientes[clcodigo])
```
- **Propósito**: Total de clientes únicos
- **Contexto**: Se filtra por centro y otras dimensiones

---

### **D. MEDIDAS - TABLA BWCONTRA (Empresa 17)**

```dax
BWAsig = DISTINCTCOUNT(BWContra[ctcontrato])
```
- **Propósito**: Asignaciones de la empresa 17 (Badajoz)

```dax
BWMedAsig = 
DIVIDE(
    SUMPRODUCT(DATEDIFF(BWContra[ctfechaini], BWContra[ctfechafinreal], DAY)),
    DISTINCTCOUNT(BWContra[ctcontrato])
)
```
- **Propósito**: Media de duración de asignaciones en días

---

### **E. MEDIDAS - TABLA DUNCONTRA (Centro DUN)**

```dax
Dun Asignaciones = COUNTA(Duncontra[ctcontrato])
Dun MedAsignac = AVERAGE(Duncontra[duración_contrato_días])
Dun TrabActivos = DISTINCTCOUNT(Duncontra[cttrabajador])
```

```dax
% DunMesAnter = 
([Dun Asignaciones] - [Dun Asignaciones Mes Anterior]) 
/ [Dun Asignaciones Mes Anterior]
```
- **Propósito**: Variación porcentual mes a mes del centro DUN

---

### **F. MEDIDAS - TABLA INTCONTRA (Intermedia)**

```dax
IntAsig = COUNTA(IntContra[ctcontrato])
IntTrabaj = DISTINCTCOUNT(IntContra[cttrabajador])
IntTraMAsig = DIVIDE([IntAsig], [IntTrabaj])
```

```dax
IntTCenTra = FORMAT(IntContra[ctcentro],"00") & FORMAT(IntContra[cttrabajador],"00000000")
```
- **Propósito**: Clave compuesta Centro+Trabajador (columna calculada)

---

### **G. MEDIDAS - NONOCONTRA**

```dax
NonoAsig = COUNTA(NonoContra[ctcontrato])
NonoMedAsig = AVERAGE(NonoContra[duración_días])
```

---

### **Resumen de Medidas**

| Tabla | # Medidas | Categoría | Ejemplos |
|-------|-----------|-----------|----------|
| **contratos** | 50+ | Hechos | Asignaciones, Crecimiento, TrabActivos |
| **Calendario** | 22 | Temporales | fecini, fecaa, fecsp, fecmp |
| **Clientes** | 1 | Conteo | TotClientes |
| **BWContra** | 2 | Hechos (EMP17) | BWAsig, BWMedAsig |
| **Duncontra** | 4 | Hechos (DUN) | Dun Asignaciones, % DunMesAnter |
| **IntContra** | 3 | Hechos (INT) | IntAsig, IntTrabaj, IntTraMAsig |
| **NonoContra** | 2 | Hechos (NONO) | NonoAsig, NonoMedAsig |
| **TOTAL** | **150+** | Mixtas | Análisis multidimensional |

---

## 🧠 LÓGICA DEL MODELO

### **A. ARQUITECTURA DEL MODELO**

```
NIVEL 1 - DATOS MAESTROS (Dimensiones)
├── MCANCentros          (Raíz - Centros de la organización)
├── Clientes             (Clientes a los que se asignan)
├── Trabajadores         (Trabajadores disponibles)
├── Categorias           (Clasificación de puestos)
└── TipContra            (Tipos de contrato laboral)

NIVEL 2 - DATOS DE CAMBIO DE TIEMPO (Calendario)
└── Calendario           (Tabla de fechas con inteligencia temporal)

NIVEL 3 - DATOS OPERACIONALES (Hechos)
├── contratos            (Asignaciones empresa 01)
├── BWContra             (Asignaciones empresa 17)
├── DunContra            (Asignaciones centro DUN)
├── IntContra            (Asignaciones empresa 1 intermedia)
└── NonoContra           (Asignaciones empresa 26)

NIVEL 4 - DATOS DE SOPORTE
├── DunClien, DunCatego, DunTrabaj  (Dimensiones del centro DUN)
└── Tabla_Fechas         (Series temporal diaria)
```

### **B. FLUJO DE DATOS**

```
SQL Server (4 Bases de Datos)
    ├── no3001: Empresas 01, 17, Calendario
    ├── no3004: Centro DUN (04)
    ├── no3003: Empresas 1 (intermedia), 26 (Nono)
    └── [Otros]: Datos importados

        ↓ (Transformación y Filtrado)

Modelo Semántico PowerBI
    ├── Importación de datos
    ├── Limpieza: Filtros por fecha y centro
    ├── Normalización: Claves compuestas (Centro + Código)
    └── Enriquecimiento: Columnas calculadas

        ↓ (Cálculos DAX)

Medidas y KPIs
    ├── COUNTA, DISTINCTCOUNT
    ├── DATEADD (Year-over-Year)
    ├── DATEDIFF (Duración)
    └── SUMPRODUCT (Agregaciones complejas)

        ↓ (Output)

Visualizaciones Power BI
    └── Reportes: Evolución de asignaciones, análisis por centro
```

### **C. LÓGICA DE AGREGACIÓN**

#### **Principio 1: Conteo de Asignaciones**
```
Asignaciones = COUNTA(contratos[ctcontrato])
```
- Una asignación = Un contrato único
- No se deduplican aunque sea mismo trabajador
- Se filtra por fechas de vigencia (ctfechaini ≤ hoy ≤ ctfechafinreal)

#### **Principio 2: Deduplicación de Trabajadores**
```
TrabActivos = DISTINCTCOUNT(contratos[cttrabajador])
```
- Un trabajador = Único ID aunque tenga múltiples asignaciones
- Evita doble conteo si está en múltiples clientes/centros

#### **Principio 3: Análisis Temporal**
```
AsignacionesAA = CALCULATE([Asignaciones], DATEADD(Calendario[Date], -1, YEAR))
```
- Compara períodos idénticos en años diferentes
- Base para análisis Year-over-Year (YoY)
- Activa/Desactiva relaciones con USERELATIONSHIP según necesidad

#### **Principio 4: Rangos Dinámicos**
```
fecini = FIRSTDATE(Calendario[Date])
```
- Se adapta al contexto de filtrado (mes, trimestre, año)
- Permite análisis rolling (últimos 7 días, último mes, etc.)

#### **Principio 5: Cálculo de Duración**
```
Horas Realizadas = SUMPRODUCT(DATEDIFF(ctfechaini, ctfechafinreal, DAY) * 8)
```
- Duración = Fecha fin - Fecha inicio
- Conversión a horas = días * 8 horas/día (estándar laboral)
- Asume jornada completa sin ausencias

### **D. LÓGICA DE RELACIONES**

#### **Relación 1: MCANCentros → Clientes**
```
MCANCentros.Id = Clientes.clcentro
```
**Propósito**: Centralizar información de centros  
**Dirección**: De arriba hacia abajo (Centro → Cliente)  
**Multiplicity**: 1:N (Un centro puede tener múltiples clientes)

#### **Relación 2: Clientes → contratos**
```
Clientes.ClCenCli = contratos.ConCenCli
```
**Propósito**: Vincular cada contrato con su cliente  
**Clave compuesta**: `FORMAT(centro,"00") & FORMAT(codigo,"000000")`  
**Multiplicity**: 1:N (Un cliente puede tener múltiples contratos)

#### **Relación 3: Trabajadores → contratos**
```
Trabajadores.cttrabajador = contratos.cttrabajador
```
**Propósito**: Información demográfica del trabajador asignado  
**Multiplicity**: 1:N (Un trabajador en múltiples contratos/períodos)

#### **Relación 4: Categorias → contratos**
```
Categorias.cacodigo = contratos.ctcatepuesto
```
**Propósito**: Nivel/puesto del trabajador en la asignación  
**Multiplicity**: 1:N (Una categoría en múltiples contratos)

#### **Relaciones DUN (5-7): Centro DUN**
```
DunContra.cttrabajador = DunTrabaj.cttrabajador
DunContra.ctcatepuesto = DunCatego.cacodigo
DunContra.DConCenCli = DunClien.DClCenCli
```
**Propósito**: Replicar estructura de relaciones para centro DUN  
**Aislamiento**: Datos de DUN no contaminan datos de empresa 01

### **E. LÓGICA DE FILTRADO**

#### **Filtro Global por Fechas**
```
Todas las tablas de hechos tienen filtro:
  ctfechaini >= 2019-01-01 (histórico)
  ctfechafinreal <= TODAY() (realidad)
```
**Efecto**: 
- Excluye contratos sin fecha de inicio real
- Excluye datos futuros especulativos
- Histórico desde 2019 para análisis multianual

#### **Filtro por Centro**
```
Clientes y contratos filtran por:
  centro != NULL (excluye registros huérfanos)
```

#### **Filtro por Empresa**
```
- contratos: Empresa 01 (BD no3001)
- BWContra: Empresa 17 (BD no3001)
- Duncontra: Empresa 4 (BD no3004)
- IntContra: Empresa 1 (BD no3003)
- NonoContra: Empresa 26 (BD no3003)
```
**Aislamiento**: Cada empresa es independiente (no hay mezcla de datos)

#### **Exclusión de "Fijos"**
```
Clientes excluye:
  WHERE clnombre NOT LIKE '%fijo%'
```
**Propósito**: Eliminar clientes fijos/intranets de análisis

### **F. PATRONES DE ANÁLISIS SOPORTADOS**

#### **1. Análisis Temporal (Time Intelligence)**
```dax
Asignaciones (período actual)
vs.
AsignacionesAA (período anterior)
Crecimiento = % change YoY
```
**Reportes**: Evolución mes a mes, trimestre a trimestre, año a año

#### **2. Análisis de Movimientos (Altas/Bajas)**
```
Altas = Nuevos contratos iniciados
Bajas = Contratos finalizados
Saldo = Altas - Bajas
```
**Reportes**: Rotación de personal, tendencias de empleo

#### **3. Análisis de Recursos Humanos**
```
TrabActivos = Fuerza de trabajo disponible
TrabNuevos = Incorporaciones
Años = Experiencia promedio
Diversidad = Sexo, Discapacidad, Nacionalidad
```
**Reportes**: Estructura de RRHH, cumplimiento de cuotas

#### **4. Análisis de Clientes**
```
Clientes activos por período
AsignacionesxCliente = Volumen de negocio
CategoriasPorCliente = Mix de puestos
```
**Reportes**: Top clientes, segmentación, concentración

#### **5. Análisis de Centros/Geografía**
```
AsignacionesPorCentro = Distribución geográfica
TrabPorCentro = Fuerza disponible por ubicación
```
**Reportes**: Performance por sucursal, capacidad de servicio

### **G. INTELIGENCIA TEMPORAL DESHABILITADA**

```yaml
Time Intelligence: Deshabilitada
Razón: Modelo con múltiples tablas de hechos (contratos, BWContra, etc.)
Impacto: 
  - No hay relación automática con Calendario
  - DAX requiere USERELATIONSHIP() explícito para análisis temporal
  - Mayor control pero mayor complejidad
```

---

## 🏗️ ARQUITECTURA DE DATOS

### **Modelo Conceptual**

```
EMPRESA (Solo 01, 17, etc.)
    ↓
CENTRO (De operaciones)
    ↓
CLIENTE (Generador de demanda)
    ↓
CONTRATO (Asignación específica)
    ├→ TRABAJADOR (Recurso humano)
    └→ CATEGORÍA (Nivel/puesto)
```

### **Data Warehouse Lógico**

```
Tabla de HECHOS:     contratos (empresa 01)
Tabla de Dimensiones:
  - Calendario
  - Clientes
  - Trabajadores
  - Categorias
  - MCANCentros
  - TipContra

Tablas Paralelas:
  - BWContra (empresa 17)
  - Duncontra (empresa 4)
  - IntContra (empresa 1)
  - NonoContra (empresa 26)
```

### **Modelado de Datos**

| Aspecto | Implementación |
|--------|-----------------|
| **Tipo de Esquema** | Multitar (Constellation) - Múltiples fact tables |
| **Normalización** | 3NF (Tercera forma normal) |
| **Aproximación PBI** | Import con agregaciones calculadas |
| **Freshness** | Según frecuencia de actualización (SQL Server) |
| **Compresión** | Xmplicit (en memoria) |

### **Performance Consideraciones**

✅ **Optimizaciones presentes**:
- Filtro de fechas >= 2019 (reduce volumen histórico)
- DISTINCTCOUNT para trabajadores (evita duplicados)
- Claves compuestas bien indexadas en origen

⚠️ **Puntos de atención**:
- Múltiples fact tables pueden provocar filtro cruzado inesperado
- Time Intelligence deshabilitada requiere DAX complejo
- Relaciones indirectas entre DUN y demás tablas pueden ralentizar

🔧 **Mejoras recomendadas**:
1. Activar Time Intelligence si se estabiliza estructura
2. Crear tabla puente (bridge) para empresas si se necesita análisis consolidado
3. Considerar materializar agregaciones si reportes son lentos
4. Indexar claves foráneas en SQL Server origen

---

## 📈 CASOS DE USO PRINCIPALES

| Caso de Uso | Tablas Implicadas | Medidas Clave |
|---|---|---|
| **Seguimiento de asignaciones** | contratos, Calendario, Clientes | Asignaciones, AsignacionesAA, Crecimiento |
| **Análisis de RRHH** | contratos, Trabajadores, Categorias | TrabActivos, TrabNuevos, Años |
| **Performance por cliente** | contratos, Clientes, Trabajadores | AsignacionesxCliente, TrabxCliente |
| **Altas y bajas** | contratos, Calendario | Altas, Bajas, Rotación |
| **Análisis geográfico** | contratos, MCANCentros, Clientes | AsignacionesPorCentro |
| **Comparativa periodal** | contratos, Calendario | AsignacionesAA, CrecimientoYoY |
| **Centro DUN análisis** | Duncontra, DunClien, DunTrabaj, DunCatego | Dun Asignaciones, % DunMesAnter |

---

## 📝 REFERENCIAS Y NOTAS

**Fuentes de datos**:
- SQL Server `no3001`: Datos principales (empresas 01, 17)
- SQL Server `no3004`: Centro DUN (empresa 4)
- SQL Server `no3003`: Empresas intermedias 1 y 26
- Importados: MCANCentros (JSON)

**Mantenimiento**:
- Actualizar anualmente filtro de fechas (ctfechaini >= 20XX)
- Revisar clientes excluidos ("fijo") según política
- Validar integridad de claves compuestas

**Documentación relacionada**:
- [Cara reportes PBIR en carpeta Report/]
- [Archivos TMDL en carpeta SemanticModel/definition/tables/]

---

**Fin de documentación**  
*Generado: 30 de marzo de 2026*
