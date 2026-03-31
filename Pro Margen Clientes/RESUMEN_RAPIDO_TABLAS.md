# Resumen Ejecutivo - Tablas del Modelo Semántico
**Pro Facturación Margen Clientes - Quick Reference**

---

## TABLA DE REFERENCIA RÁPIDA

### Tablas de Referencia/Dimensión

| # | Tabla | Columnas | Col. Clave | Medidas | Fuente | Descripción |
|---|---|---|---|---|---|---|
| 1 | **Calendario** | 8+ | Date, DateKey | 10 | Genera | Dimensión temporal con medidas de período |
| 2 | **Catego** | 2 | cacodigo | 0 | SQL | Categorías maestras |
| 3 | **Clientes** | 12 | clcentro, clcodigo | 0 | SQL | Clientes activos filtrados (2022+) |
| 4 | **GruposEmp** | 8 | gegrupo, gesubgrupo | 0 | SQL | Clasificación grupos empresariales |
| 5 | **MCANCentros** | 5 | Id, Sucursal | 0 | Excel | Directorio de oficinas MCA |
| 6 | **Trabajadores** | 4 | cttrabajador | 0 | SQL | Trabajadores con contratos 2022+ |
| 7 | **TMargen** | 1 | NMargen | 0 | Calc | Parámetro de margen |
| 8 | **Selecciono EoD** | 1 | Ambito | 0 | Calc | Selector empresa vs delegación |

---

### Tablas de Transacciones

| # | Tabla | Columnas | Key Join | Medidas | Período | Descripción |
|---|---|---|---|---|---|---|
| 9 | **Facturas** | 12+ | fccentro, fccliente, fcfecha | 5 | 2022+ | Transacciones de facturación |
| 10 | **Contratos** | 14 | ctcentro, ctcontrato, cttrabajador | 6 | Hist | Asignaciones trabajador-cliente |
| 11 | **Epis** | 15 | epicentro, clcodigo, mvfecha | 2 | 2023+ | Gastos EPIs por cliente |
| 12 | **Ofertas** | 13 | ofcentro, ofcliente, offechaoferta | 0 | 2021+ | Presupuestos offertados |
| 13 | **OFlineas** | 15+ | ofcentro, ofcodigo | 0 | 2021+ | Detalle de líneas de oferta |
| 14 | **Rappels** | 10 | mvcentro, mvcliente, mvfecha | 7 | 2023+ | Descuentos/rappels a clientes |
| 15 | **estadi** | 9+ | esfecha, escliente | 40+ | 2022+ | Estadísticas facturación + márgenes |

---

### Tablas de Contabilidad Analítica

| # | Tabla | Columnas | Key Filter | Medidas | Período | Descripción |
|---|---|---|---|---|---|---|
| 16 | **CnHistor** | 9 | hicuenta, hifechamd | 1 | 2021+ | Histórico contable simple |
| 17 | **CNHistorR** | 6+ | hicuenta | 35+ | Hist | Análisis contable por concepto |
| 18 | **HistorN01** | 17 | hnconcepto, FechaH | 5 | 2021+ | Nómina: ausencias, permisos, IT |

---

### Tablas de Revisiones Médicas (RRMM)

| # | Tabla | Columnas | Medidas | Fuente | Año | Descripción |
|---|---|---|---|---|---|---|
| 19 | **RRMM MP** | 16 | 1 | Excel | Múlt | Vigilancia Mutua Quirón |
| 20 | **RRMM PREVAE** | 14 | 1 | Excel | Múlt | Vigilancia Prevention AE |
| 21 | **RRMMQUIRON23** | 15+ | 3 | Calc | 2023 | Reconocimientos 2023 |
| 22 | **RRMMQUIRON24** | 13+ | 4 | Calc | 2024 | Reconocimientos 2024 |
| 23 | **RRMMQUIRON25** | 13+ | 1 | Calc | 2025 | Reconocimientos 2025 |

---

### Tablas Especiales

| # | Tabla | Columnas | Medidas | Propósito |
|---|---|---|---|---|
| 24 | **VKpei** | 2 | 20+ | KPI dashboard parámetros |

---

## COLUMNAS CLAVE POR TABLA

### Clientes
```
Identificadores:  clcentro (int), clcodigo (int)
Nombres:          clnombre (string), clnomfis (string)
Clasificación:    clgrupo (int), clsubgrupo (int), gedescripcion (string)
Documentos:       clcifdni (string)
Composite Keys:   ClCenCli, ClUniGruS
```

### Contratos
```
Identificadores:  ctcentro, ctcontrato, cttrabajador, ctcliente
Fechas:           ctfechaini (DateTime), ctfechafinreal (DateTime)
Categorización:   ctcatepuesto, ctcatesalario
Personal:         trnif (string)
Composite Keys:   ConCenCli, ConCenCon, Contounido2
```

### Facturas
```
Identificadores:  fccentro, fcdocum, fccentro (int)
Fechas:           fcfecha (DateTime) - Jerarquía
Relaciones:       fccliente, fccencli
Importes:         fcbruto (double) - Base para medidas
```

### estadi (Estadísticas)
```
Temporal:         esfecha (DateTime)
Cliente:          escliente (int)
Importes:         SImpFra, SCosSal, SCosSs, SIndem
Cálculos:         Margen €, Margen %, Coeficiente
Comparativas:     Año Act vs Año Ant
```

---

## MEDIDAS CLAVE POR ÁREA

### INGRESOS Y FACTURACIÓN

**Tabla: Calendario**
- `fecini` - Primera fecha período
- `fecfin` - Última fecha período
- `feciniaa`, `fecfinaa` - Período año anterior

**Tabla: estadi**
- `Tfra` - Total facturación
- `'Fra.Año Act.NV'` - Facturación año actual
- `'Fra.Año Ant.'` - Facturación año anterior
- `'Fra Mes Ant'` - Facturación mes anterior
- `'%Fact.A'` - Porcentaje sobre total empresa

**Tabla: Facturas**
- `TotFra` - Total facturación línea
- `TotFraf` - Suma simple
- `Abonos` - Facturas negativas

**Tabla: Rappels**
- `TotRapp` - Total rappels período
- `RapAEnt` - Rappels año entero

---

### MÁRGENES Y RENTABILIDAD

**Tabla: estadi**
- `'Margen €'` - Margen absoluto [Fra - (CosSal + CosSS)]
- `'Margen %'` - Margen porcentaje
- `'MargenMR €'` - Margen real (con Rappels)
- `'MargenMR %'` - Margen real porcentaje
- `Coeficiente` - Fra / Costo Salario
- `'Obj.Margen Bruto'` - Objetivo 9%

---

### COSTOS DE PERSONAL

**Tabla: estadi**
- `CostoSalario` - Suma costo salarios
- `esSumCosSalP` - Suma costo salario + indemnización
- `esSumCosSSP` - Suma costo seguridad social

**Tabla: HistorN01**
- `CosteIT` - Costo incapacidad temporal
- `CostePermiso` - Costo permisos (factor 1.3435)
- `CosteAbsen€` - Costo total ausencias
- `'% ABS'` - Ausencias como % facturación

**Tabla: CNHistorR**
- Detalle analítico por rango de cuentas (6280+ conceptos)

---

### ASIGNACIONES Y PRODUCTIVIDAD

**Tabla: contratos**
- `Asignaciones` - Conteo contratos activos
- `AvWeek` - Promedio asignaciones semana
- `FraXAsig` - Facturación por asignación
- `AvAnyoWeek` - Promedio anual por semana

---

### VIGILANCIA DE SALUD

**Tabla: RRMMQUIRON23/24/25**
- `TFraRRMM` - Total facturación RRMM
- `TotRevis` - Cantidad reconocimientos

**Tabla: RRMM MP**
- `TFraRRMMMP` - Total gastos Mutua Quirón

**Tabla: RRMM PREVAE**
- `TotRMPrevae` - Total gastos Prevention

---

## JERARQUÍAS DE FECHA

Tabla `Calendario` proporciona jerarquía:
- Año → Mes → Día (automática por LocalDateTable)

---

## JOINS AUTOMÁTICOS PRINCIPALES

```
Clientes ←→ GruposEmp          [clgrupo, clsubgrupo]
Clientes ←→ Contratos          [clcentro, clcodigo]
Clientes ←→ Facturas           [clcentro, clcodigo]
Contratos ←→ Trabajadores      [cttrabajador]
estadi ←→ MCANCentros          [Sucursal]
Rappels ←→ Clientes            [mvcentro, mvcliente]
RRMM ←→ Clientes               [clcentro, clcifdni]
HistorN01 ←→ Clientes          [hncentro, clcodigo]
```

---

## ESTADÍSTICAS DE DATOS

| Métrica | Valor |
|---|---|
| Tablas Totales | 24 |
| Medidas Totales | 150+ |
| Columnas Calculadas | 40+ |
| Jerarquías de Fecha | 7 |
| Período Mínimo de Datos | 2021 |
| Período Máximo de Datos | 2025 (presente) |
| Fuentes SQL | 1 (TEMPORING) |
| Fuentes Excel | 1 (Excels PBIs) |
| Tablas Calculadas | 3 |

---

## TRANSFORMACIONES Y VALIDACIONES

### En Clientes
- **Join Múltiple**: UNION de contratos activos, facturas 2022+, clientes específicos
- **Filtro**: Excluye clientes con 'fijo' en nombre

### En Epis
- **Join**: Cliente múltiple
- **Transform**: Centro 71 → 22 si fecha > 2024-03
- **Mapeo**: Códigos antiguos a nuevos (tabla manual)

### En RRMM MP/PREVAE
- **Join NFI**: Contrato por NIF
- **Validación**: Fecha en rango reconocimiento
- **Transform**: Centro 71 → 22

### En HistorN01
- **Filtro Nómina**: Solo tipo 'N'
- **Conceptos**: Incluye 90900, 90997, 90011, 90995, 95000, 90012-90015, 90996, 14, 295, 297, 91948, 94000-94005
- **Período**: Desde 2021

---

## PATRONES DE CÁLCULO

### Margen Bruto
```
Margen € = Facturación - (Costo Salarios + Costo SS)
Margen % = 1 - (Costos / Facturación)
```

### Margen Real (con Rappels)
```
Fra.AñoMR = Fra.Año Act - TotRapp + RapNYear
MargenMR € = Fra.AñoMR - Costos
MargenMR % = 1 - (Costos / Fra.AñoMR)
```

### Coeficiente Facturación
```
Coeficiente = Facturación / Costo Salario
```

### Clientes Nuevos (Lógica Compleja)
- Identifica clientes cuya primera factura está dentro del período seleccionado
- Lookback de 5 años
- Solo contar si primera factura >= fecha inicial seleccionada

---

## PARTICULARIDADES DEL MODELO

### 1. Magntitud de Medidas
- Tabla **CNHistorR** contiene 35+ medidas (una por rango de cuentas contables)
- Tabla **estadi** contiene 40+ medidas (múltiples perspectivas de análisis)
- Tabla **VKpei** contiene 20+ medidas de parámetros KPI

### 2. Transformación Dinámica de Centros
- Centro 71 se redirecciona a 22 desde marzo 2024
- Afecta: Epis, RRMM MP, RRMM PREVAE
- Mapeo manual de código de cliente

### 3. Múltiples Fuentes de Vigilancia
- 5 tablas RRMM de diferentes proveedores y años
- Consolidan en medida `TotRRMM34`

### 4. Base de Datos Contable Dual
- **CnHistor**: Transacciones simples agregadas
- **CNHistorR**: Análisis detallado por conceptos contables

### 5. Cálculos Móviles Basados en Calendario
- Todas las fechas relativas calculadas desde tabla Calendario
- Permite análisis dinámico sin filtros estáticos
- Soporta comparativas móviles (año anterior, mes anterior, etc.)

---

## GUÍA DE USO POR ANÁLISIS

### Para Análisis de Facturación
Usar: `estadi` + `Calendario` + `Clientes` + `MCANCentros`
Medidas: `Tfra`, `'Fra.Año Act'`, `'%Fact.A'`

### Para Análisis de Márgenes
Usar: `estadi` + `Rappels` + `CNHistorR`
Medidas: `'Margen €'`, `'MargenMR %'`, `Coeficiente`

### Para Análisis de Asignaciones
Usar: `contratos` + `Calendario`
Medidas: `Asignaciones`, `AvWeek`, `FraXAsig`

### Para Análisis de Costos
Usar: `HistorN01` + `CNHistorR`
Medidas: `CosteAbsen€`, `'Coste NExternos'`, medidas por concepto

### Para Análisis de Vigilancia
Usar: `RRMMQUIRON24/25` + `RRMM MP` + `Clientes`
Medidas: `TFraRRMM`, `TotRevis`, `TotRRMM34`

---

## NOTAS DE MANTENIMIENTO

1. **Actualización de Datos**: SQL + Excel mensual
2. **Transformaciones de Centro**: Revisar anualmente (cambios en 2024)
3. **Conceptos de Nómina**: Validar si cambian códigos RRHH
4. **Cuentas Contables**: Validar rangos si varía estructura PLCuentas
5. **Parámetros VKpei**: Revisar valores mensualmente

---

**Última actualización**: Marzo 2026  
**Documentación**: Análisis TMDL Completo
