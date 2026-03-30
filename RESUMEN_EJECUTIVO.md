# RESUMEN EJECUTIVO - MODELO POWER BI
## Evolución AsignacionesMCA 2026

---

## 🎯 QUICK REFERENCE - ESTRUCTURA

### Tablas Principales (15 total)

| # | Tabla | Tipo | Empresa | Filas | Propósito |
|---|-------|------|---------|-------|-----------|
| 1 | **contratos** | Hechos | 01 | Miles | Asignaciones principal |
| 2 | **Calendario** | Dimensión | Auto | 1500+ | Análisis temporal |
| 3 | **Clientes** | Dimensión | 01 | ~Hundreds | Maestro de clientes |
| 4 | **Trabajadores** | Dimensión | 01 | Miles | Datos RRHH |
| 5 | **Categorias** | Dimensión | 01 | ~30 | Tipos de puesto |
| 6 | **MCANCentros** | Referencia | - | ~30 | Centros operacionales |
| 7 | **TipContra** | Dimensión | 01 | ~20 | Tipos de contrato |
| 8 | **BWContra** | Hechos | 17 | Miles | Empresa 17 |
| 9 | **DunContra** | Hechos | 4 | Miles | Centro DUN |
| 10 | **DunClien** | Dimensión | 4 | ~Hundreds | Clientes DUN |
| 11 | **DunCatego** | Dimensión | 4 | ~30 | Categorías DUN |
| 12 | **DunTrabaj** | Dimensión | 4 | Miles | Trabajadores DUN |
| 13 | **IntContra** | Hechos | 1 | Miles | Empresa 1 (Intermedia) |
| 14 | **NonoContra** | Hechos | 26 | Miles | Empresa 26 (Nono) |
| 15 | **Tabla_Fechas** | Series | - | ~365 | Fechas diarias |

---

## 🔗 RELACIONES - MAPA VISUAL

```
                    MCANCentros
                         ↓
                    Clientes ←── contratos ──→ Trabajadores
                                       ↓
                                   Categorias
                    
    ┌─── DunContra ────┬──→ DunTrabaj
    │                  │
    │                  ├──→ DunCatego
    │                  │
    │                  └──→ DunClien
    │
    ├─── BWContra
    │
    ├─── IntContra
    │
    └─── NonoContra
    
Tabla_Fechas (no relacionada - usar USERELATIONSHIP en DAX)
```

---

## 📊 MEDIDAS CLAVE (Top 20)

| Medida | Tabla | Fórmula Base | Uso |
|--------|-------|--------------|-----|
| **Asignaciones** | contratos | COUNTA(ctcontrato) | Total contratos activos |
| **TrabActivos** | contratos | DISTINCTCOUNT(cttrabajador) | Fuerza de trabajo |
| **Crecimiento** | contratos | ([Asig]-[AsigAA])/[AsigAA] | YoY % |
| **Altas** | contratos | Contratos iniciados mes/año | Alta de personal |
| **Bajas** | contratos | Contratos finalizados mes/año | Baja de personal |
| **AsignacionesAA** | contratos | CALCULATE([Asig], DATEADD(-1Y)) | Comparativa año anterior |
| **AsignacionesMA** | contratos | CALCULATE([Asig], DATEADD(-1M)) | Comparativa mes anterior |
| **TrabNuevos** | contratos | Conteo dedup por período | Contrataciones mes/año |
| **Horas Realizadas** | contratos | SUMPRODUCT(DATEDIFF * 8) | Productividad en horas |
| **Media Horas/Trab** | contratos | [Horas]/[TrabActivos] | Promedio hora/trabajador |
| **fecini** | Calendario | FIRSTDATE(Date) | Fecha inicio período |
| **fecfin** | Calendario | LASTDATE(Date) | Fecha fin período |
| **feciniaa** | Calendario | FIRSTDATE(DATEADD(-1Y)) | Inicio año anterior |
| **fecfinaa** | Calendario | LASTDATE(DATEADD(-1Y)) | Fin año anterior |
| **fecinisp** | Calendario | FIRSTDATE(DATEADD(-7D)) | Hace 7 días |
| **fecfinsp** | Calendario | LASTDATE(Date) | Hoy |
| **fecinimp** | Calendario | FIRSTDATE(DATEADD(-31D)) | Hace 31 días |
| **fecfinmp** | Calendario | LASTDATE(Date) | Hoy |
| **TotClientes** | Clientes | COUNTA(clcodigo) | Nº clientes únicos |
| **Dun Asignaciones** | Duncontra | COUNTA(ctcontrato) | Asig centro DUN |

---

## 💾 DATOS POR EMPRESA

### Estructura de Empresas

```yaml
Empresa 01:
  Base de datos: no3001
  Tablas: contratos, Clientes, Trabajadores, Categorias
  Período: desde 2019
  Filtros: clientes sin "fijo" en nombre

Empresa 17 (Badajoz):
  Base de datos: no3001
  Tabla: BWContra
  Período: desde 2019
  
Centro DUN (Empresa 4):
  Base de datos: no3004
  Tablas: Duncontra, DunClien, DunCatego, DunTrabaj
  Período: desde 2019
  
Empresa 1 intermediaria:
  Base de datos: no3003
  Tabla: IntContra
  
Empresa 26 (Nono):
  Base de datos: no3003
  Tabla: NonoContra
```

---

## 🧮 FÓRMULAS COMUNES

### Análisis Temporal

```dax
-- Comparativa año anterior
AsignacionesAA = 
CALCULATE(
    [Asignaciones],
    DATEADD(Calendario[Date], -1, YEAR)
)

-- Crecimiento YoY
Crecimiento = 
([Asignaciones] - [AsignacionesAA]) / [AsignacionesAA]
```

### Conteos Deduplicados

```dax
-- Trabajadores únicos
TrabActivos = 
DISTINCTCOUNT(contratos[cttrabajador])

-- Clientes únicos
TotClientes = 
COUNTA(Clientes[clcodigo])
```

### Análisis de Rangos Dinámicos

```dax
-- Rango del período actual
fecini = FIRSTDATE(Calendario[Date])
fecfin = LASTDATE(Calendario[Date])

-- Últimos 7 días
fecinisp = FIRSTDATE(DATEADD(Calendario[Date], -7, DAY))
fecfinsp = LASTDATE(Calendario[Date])
```

### Duración y Horas

```dax
-- Horas trabajadas (asumiendo 8h/día)
Horas Realizadas = 
SUMPRODUCT(
    DATEDIFF(contratos[ctfechaini], contratos[ctfechafinreal], DAY) * 8
)

-- Promedio por trabajador
Media Horas/Trab = 
DIVIDE([Horas Realizadas], [TrabActivos])
```

---

## 🔍 PATRONES DE ANÁLISIS

### 1️⃣ Seguimiento de Asignaciones
```
Selecciona: Asignaciones, AsignacionesAA, Crecimiento
Filtra por: Centro, Cliente, Período
Visualiza: Gráfico línea temporal
```

### 2️⃣ Análisis de RRHH
```
Selecciona: TrabActivos, TrabNuevos, Altas, Bajas
Filtra por: Período, Centro, Categoría, Sexo
Visualiza: Tarjetas, gráfico barras, tabla
```

### 3️⃣ Performance por Cliente
```
Selecciona: Asignaciones, TrabActivos, Media Horas/Trab
Filtra por: Cliente, Período
Visualiza: Top 10 clientes
```

### 4️⃣ Rotación de Personal
```
Selecciona: Altas, Bajas, Saldo (Altas-Bajas)
Filtra por: Período, Centro
Visualiza: Gráfico cascada, KPI
```

---

## ⚙️ CONFIGURACIONES CLAVE

✅ **Habilitadas**:
- Modo Import (datos pre-cargados)
- Filtro cruzado simple en relaciones
- Columnas calculadas (claves compuestas)
- Medidas con DATEADD y DATEDIFF

❌ **Deshabilitadas**:
- Time Intelligence (requiere USERELATIONSHIP explícito)
- Relación directa entre tablas empresa 01 y DUN
- Actualización en tiempo real

⚙️ **Nivel de compatibilidad**: 1600 (Power BI Premium)

---

## 📋 COLUMNAS CLAVE POR TABLA

### contratos
- `ctcentro` → Centro
- `ctcontrato` → ID único
- `cttrabajador` → ID trabajador
- `ctcliente` → ID cliente
- `ctfechaini` / `ctfechafinreal` → Período

### Clientes
- `ClCenCli` → Clave compuesta (Centro + Código)
- `clnombre` → Nombre comercial
- `clcifdni` → CIF/DNI

### Trabajadores
- `cttrabajador` → ID
- `trsexo` / `trfechanac` / `trnacionalidad` → Demográficos
- `trdiscapacidad` → Diversidad

### Calendario
- `Date` → Fecha base
- `Año`, `Mes`, `Trimestre` → Dimensiones
- `WeekDay` → Día semana

---

## 🚨 NOTAS IMPORTANTES

⚠️ **Limitaciones**:
1. Empresas 01, 4, 17, 1, 26 son **independientes** (no hay consolidación automática)
2. Tabla_Fechas no está relacionada (usar USERELATIONSHIP en medidas si se necesita)
3. Período mínimo: **2019** (filtrados automáticamente)
4. Clientes con "fijo" están excluidos

💡 **Mejores prácticas**:
1. Usar `fecini` y `fecfin` para rangos dinámicos
2. Aplicar DISTINCTCOUNT para deduplicar trabajadores
3. Para análisis multi-empresa, crear tabla de puente manual
4. Validar claves compuestas en filtros

🔧 **Mantenimiento**:
1. Actualizar anualmente minvalue en filtro fecha (ctfechaini >= 20XX)
2. Revisar integridad de claves foráneas en origen
3. Monitorear volumen de datos (crecimiento anual)

---

**Última actualización**: 30 de marzo de 2026
