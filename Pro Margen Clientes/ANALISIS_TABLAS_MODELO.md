# Análisis de Tablas del Modelo Semántico
**Pro Facturación Margen Clientes - Power BI**

---

## Resumen Ejecutivo

El modelo semántico contiene **24 tablas principales** que forman la base del análisis de facturación, márgenes y gestión de clientes. Las tablas se organizan en cuatro categorías principales:

1. **Tablas de Referencia**: Información maestra (Calendario, Clientes, Trabajadores, etc.)
2. **Tablas de Transacciones**: Datos de operaciones (Facturas, Contratos, Epis, Ofertas, etc.)
3. **Tablas de Análisis Contable**: Información de contabilidad (CnHistor, CNHistorR, HistorN01)
4. **Tablas Especializadas**: Reportes de revisiones médicas (RRMM MP, RRMM PREVAE, RRMMQUIRON23/24/25)

---

## TABLAS PRINCIPALES

### 1. **Calendario**
**Propósito**: Tabla de dimensión fecha para filtrado temporal y cálculos de períodos

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 8+ |
| **Columnas** | Date, DateKey, Año, Mes (Número), Año/Mes, Mes (Corto) |
| **Tipos de Datos** | DateTime (Date), Int64 (DateKey, Año, Mes) |
| **Medidas Definidas** | 10 |
| **Medidas Principales** | fecini, fecfin, fecfinma, feciniaa, fecinima, fecininy, fecfinny, fecfinaa, CtaMeses, fecinianyo |

**Descripción Funcional**: 
- Tabla calendario con medidas que calculan fechas de inicio/fin de períodos
- Proporciona variables dinámicas para filtrado temporal (año actual, año anterior, mes anterior, mes siguiente, año próximo)
- Integración de jerarquías de fecha desde LocalDateTable

**Jerarquías**: 
- Date Hierarchy (LocalDateTable_efacd82c-63fc-41fd-8a22-6a764a0d734f)

---

### 2. **Catego**
**Propósito**: Tabla de categorías/clasificaciones

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 2 |
| **Columnas** | cacodigo, canombre |
| **Tipos de Datos** | Int64 (cacodigo), String (canombre) |
| **Medidas Definidas** | 0 |
| **Fuente de Datos** | SQL Server (10.10.138.5\TEMPORING, base no3001) |

**Descripción Funcional**: 
- Tabla dimensión pequeña de categorías
- Vinculada a: SELECT cacodigo, canombre from catego

---

### 3. **Clientes**
**Propósito**: Tabla maestra de clientes activos y relevantes

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 12 |
| **Columnas** | clcentro, clcodigo, clnombre, clnomfis, clcifdni, clgrupo, clsubgrupo, gedescripcion, MCSucursal, ClCenCli, ClUniGruS |
| **Tipos de Datos** | Int64 (clcentro, clcodigo, clgrupo, clsubgrupo, MCSucursal), String (clnombre, clnomfis, clcifdni, gedescripcion) |
| **Medidas Definidas** | 0 |
| **Columnas Calculadas** | ClCenCli (clave combinada centro-cliente), ClUniGruS (clave combinada grupo-subgrupo) |

**Descripción Funcional**: 
- Clientes únicos filtrados con criterios específicos:
  - Contratos activos desde 2022 o facturas desde 2022
  - Excluye clientes ficticios (nombre contiene "fijo")
  - Centros específicos incluidos manualmente
- Join con GruposEmp para obtener descripción de grupos empresariales

**Filtros de Datos**:
- Contiene: contratos activos, facturas desde 2022, centros 22 y 16 con clientes específicos
- Excluye: clientes de prueba/ficticios

---

### 4. **CnHistor**
**Propósito**: Histórico de transacciones contables

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 9 |
| **Columnas** | hidelegacion, hiseccion, hicuenta, hidocum, hitipo, hifechamd, importe, MiImport |
| **Tipos de Datos** | Int64 (hidelegacion, hicuenta), Double (hiseccion, importe), String (hidocum, hitipo), DateTime (hifechamd) |
| **Medidas Definidas** | 1 |
| **Medidas** | 'Servicos de Selección' = SUM(MiImport) donde hicuenta entre 7050010000-7050019999 |

**Descripción Funcional**: 
- Transacciones contables desde 2021
- Cálculo special: MiImport ajusta signo basado en hitipo (D = negativo)
- Excluye asientos de regularización

**Validaciones de Datos**:
- hiseccion: Transformaciones de valores 96→99, 97→98

---

### 5. **CNHistorR**
**Propósito**: Histórico de contabilidad con análisis de ingresos y gastos por concepto

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 6+ |
| **Columnas** | hidelegacion, hiseccion, hicuenta, hidocum, hitipo, hifechamd, hiimporte, UltDigCta |
| **Tipos de Datos** | Int64, Double, String, DateTime |
| **Medidas Definidas** | 35+ |

**Medidas Principales** (selección representativa):
- **Ingresos**: Prestación Servicios (7050000000-7050009999), Ingresos Servicios Diversos (7590000000-7599999999), Rappel Ventas (7090000000-7090999999)
- **Gastos de Personal**: Selección Personal (7050010000-7050019999), Costos Personal Externo (6400000000-6400999999)
- **Gastos Operativos**: Comisiones Ventas, Servicios Bancarios, Formación, Viajes, Vestuario, Prevención RL
- **Otros**: Pérdida Créditos, Reversiones, Excepciones Operacionales

**Descripción Funcional**: 
- Análisis detallado de contabilidad analítica por rangos de cuentas
- Cada medida filtra por rango específico de cuentas contables
- Base para cálculos de margen y rentabilidad

---

### 6. **contratos**
**Propósito**: Tabla de contratos trabajador-cliente con datos de asignación

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 14 |
| **Columnas** | ctcentro, ctcontrato, cttrabajador, ctcliente, ctcencli, ctfechaini, ctfechafinreal, ctcatepuesto, ctcatesalario, ConCenCli, ConCenCon, Contounido2, trnif, ctfecfinrmia |
| **Tipos de Datos** | Int64 (centros, códigos, trabajador), DateTime (fechas), String (nif) |
| **Medidas Definidas** | 6 |
| **Medidas** | Asignaciones, FraXAsig, AvWeek, AvLastWeek nochuta, AsignaAnyoMA, AvAnyoWeek |

**Columnas Calculadas**:
- ConCenCli: Identificador único cliente (centro + cliente)
- ConCenCon: Identificador único contrato (centro + contrato)
- Contounido2: Identificador único contrato-trabajador (centro + contrato + trabajador)
- ctfecfinrmia: Fecha fin o HOY si contrato activo

**Medidas Analíticas**:
- **Asignaciones**: Conteo de contratos activos en período
- **AvWeek**: Promedio de asignaciones por semana
- **FraXAsig**: Facturación por asignación
- **AvAnyoWeek**: Promedio anual de asignaciones por semana

---

### 7. **Epis**
**Propósito**: Movimientos de equipos de protección individual (EPIs)

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 15 |
| **Columnas** | mvsucursal, mventidad, mvarticulo, mvfecha, mvcantid, mvprecio, mvtotal, clcifdni, epicentro, clcodigo, ClienMiooo, SupCentrooo, EpiCenCli |
| **Tipos de Datos** | Int64 (sucursal, entidad, cantidad), String (articulo, nif), DateTime (fecha), Double (precio, total) |
| **Medidas Definidas** | 2 |
| **Medidas** | Epis = SUM(mvtotal), EpisMA (Epis del mes anterior) |

**Descripción Funcional**: 
- Control de gastos en EPIs desde 2023
- Join con Clientes para obtener información de centro y código
- Transformaciones complejas para mapeo de centros (71→22 en 2024+)
- Lógica especial para reasignación de clientes en 2024
- Cálculo de cliente final (ClienMiooo) y super-centro (SupCentrooo)

**Particularidades**:
- Mapeo manual de clientes antiguos a nuevos códigos (ej: 60492→160242)
- Cambio de estructura centers a partir de 2024

---

### 8. **estadi**
**Propósito**: Estadísticas de facturación, costos y márgenes por cliente

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 9+ |
| **Columnas** | esfecha, escliente, SImpFra, SCosSal, SCosSs, SIndem, y derivadas |
| **Tipos de Datos** | DateTime (esfecha), Int64 (escliente), Double (importes, costos) |
| **Medidas Definidas** | 40+ |

**Medidas Principales**:
- **Base**: Tfra (Total Facturación), 'Fra.Año Act.NV', 'Fra.Año Ant.', 'Fra Mes Ant'
- **Costos**: 'Coste NExternos', CostoSalario, esSumCosSalP, esSumCosSSP
- **Márgenes**: 'Margen €', 'Margen %', 'MargenMR €', 'MargenMR %'
- **Análisis Comparativo**: 'Variación €', 'VariacionMR %', '% Dif.Mes Ant'
- **Ratios**: Coeficiente (Fra/Costo Salario), '%Fact.A' (% sobre total)
- **Clientes**: 'Clientes Act.', 'Clientes Act.AA'
- **Especiales**: 'Obj.Margen Bruto' (9%), FraACentro, 'Fra.AñoMR' (con Rappels)

**Descripción Funcional**: 
- Tabla de análisis principal para márgenes brutos y rentabilidad
- Cálculos de margen considerando salarios internos + SS + indemnes
- Comparativas año actual vs. año anterior
- Integración con tabla Rappels para margen real
- Múltiples perspectivas: por cliente, por centro, por período

---

### 9. **GruposEmp**
**Propósito**: Clasificación de grupos empresariales/clientes

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 8 |
| **Columnas** | gegrupo, gesubgrupo, gedescripcion, gevendedor, geclcentro, geclcodigo, GEUniGruS |
| **Tipos de Datos** | Int64 (grupo, subgrupo, vendedor, centro cliente), String (descripción) |
| **Medidas Definidas** | 0 |
| **Columnas Calculadas** | GEUniGruS (clave grupo-subgrupo) |

**Descripción Funcional**: 
- Mapeo de grupos empresariales con descripciones
- Incluye vendedor asignado y cliente representativo
- Usada para enriquecer información en Clientes

---

### 10. **HistorN01**
**Propósito**: Histórico de nóminas con detalle de conceptos (ausencias, horas, indemnizaciones)

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 17 |
| **Columnas** | hncentro, ctcliente, ctcpd, hncontrato, cttrabajador, hnanyoliq, hnmesliq, hntiponom, hnconcepto, hnimporte, FechaH, HisCenCli, Ccontratounido2, clcifdni, clcodigo, hnmicentro, ClienteMioo, SuperCentroo |
| **Tipos de Datos** | Int64 (centros, conceptos, códigos), Double (importe), String (tiponom), DateTime (FechaH) |
| **Medidas Definidas** | 5 |
| **Medidas** | CosteAbsen€, CosteIT, CostePermiso, 'Coste IT' (desglosado), 'ILT ENF', '% ABS' |

**Descripción Funcional**: 
- Datos de nómina desde 2021 con conceptos específicos
- Conceptos incluidos: ausencias (IT, enfermedades), permisos, indemnizaciones
- Cálculos de costo de ausencias con factor (1.3435 para permisos)
- Desglose de costos por tipo (IT, enfermedades, indemnización)
- Relación con contratos y clientes para análisis de impacto de ausencias

**Conceptos de Nómina Incluidos**: 90900, 90997, 90011, 90995, 95000, 90012, 90013, 90014, 90015, 90996, 14, 295, 297, 91948, 94000-94005

---

### 11. **MCANCentros**
**Propósito**: Información de centros/sucursales MCA

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 5 |
| **Columnas** | Id, Sucursal, Texto, Nombre, Delegado |
| **Tipos de Datos** | Int64 (Id, Sucursal), String (Texto, Nombre, Delegado) |
| **Medidas Definidas** | 0 |
| **Fuente de Datos** | Excel (\\10.10.138.5\Excels PBIs\MCA Oficinas.xlsx) |

**Descripción Funcional**: 
- Directorio de oficinas MCA con delegados responsables
- Usada para labels y filtros en reportes por centro

---

### 12. **Ofertas**
**Propósito**: Histórico de ofertas comerciales a clientes

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 13 |
| **Columnas** | ofcentro, ofcodigo, ofcliente, ofcencli, ofnombre, ofprovin, offechaoferta, offechavalidez, ofpedidocliente, ofestado, ofconvenio, ofvendedor, ofusuario, IdOferta, OfeCenCli |
| **Tipos de Datos** | Int64 (centro, código, cliente, convenio, vendedor), String (nombre, provincia, estado, usuario, pedido), DateTime (fechas) |
| **Medidas Definidas** | 0 |

**Descripción Funcional**: 
- Seguimiento de ofertas desde 2021
- Estado de oferta, validez temporal, asociación con convenios
- Vendedor responsable asignado
- Claves combinadas para join con otras tablas

**Jerarquías**: 
- Date Hierarchy (offechaoferta y offechavalidez)

---

### 13. **OFlineas**
**Propósito**: Líneas detalladas de ofertas con tarifas y salarios

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 15+ |
| **Columnas** | ofcentro, ofcodigo, oflcatepuesto, ofestado, offechaoferta, oflepigrafe, oflporcmargen, ofltarifahora, ofltarifames, ofltarifa7dias, oflsalariohora, oflsalariomes, oflcoefhora, oflcoefhora7dias, oflcoefmes |
| **Tipos de Datos** | Int64 (centro, código, categoría, epígrafe), Double (tarifa, margen, coeficientes), DateTime (fecha) |
| **Medidas Definidas** | 0 |

**Descripción Funcional**: 
- Detalle de cada línea de oferta con estructura de precios
- Incluye componentes: tarifa por hora/mes/7días, salario, coeficientes
- Permite cálculo de márgenes por categoría de puesto
- Base para simulaciones de presupuestos

---

### 14. **Rappels**
**Propósito**: Descuentos y compensaciones aplicados a clientes

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 10 |
| **Columnas** | mvcentro, mvcliente, mvcpd, mvcencli, mvfecha, mvconcepto, Totfra, RPCenCli, cpdcatesalario |
| **Tipos de Datos** | Int64 (centros, cliente, concepto, categoría), DateTime (mvfecha), Double (Totfra) |
| **Medidas Definidas** | 7 |
| **Medidas** | TotRapp, RapNYear, RapAAnt, RapAEnt, TRapNYear, RapFfinny, RapFininy |

**Descripción Funcional**: 
- Rappels desde 2023 (conceptos 5780, 1155)
- Integración con tabla Clientes para enriquecimiento
- Cálculos de período actual, año anterior, año próximo
- Base para cálculo de margen real (Fra.AñoMR)

---

### 15. **RRMM MP** (Revisiones Médicas - Mutua Quirón)
**Propósito**: Revisiones médicas de vigilancia de la salud - Mutua Quirón

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 16 |
| **Columnas** | Del, NIF, Apellidos y Nombre, Puesto, Fecha, IMPORTE, FACTURA, PRUEBAS, ctcentro, ctcliente, MinContra, clcifdni, RMmicentro, clcodigo, RMMPCenCli |
| **Tipos de Datos** | Int64 (Del, centros, clientes), String (NIF, nombre, puesto, factura, pruebas), DateTime (Fecha), Double (Importe, MinContra) |
| **Medidas Definidas** | 1 |
| **Medidas** | TFraRRMMMP = SUM(IMPORTE) |
| **Fuente de Datos** | Excel (\\10.10.138.5\Excels PBIs\CartasS de Aptitud.xlsx) |

**Características Especiales**:
- Join con contratos por NIF para obtener centro/cliente
- Transformación de centros (71→22 en 2024+)
- Mapeo de clientes antiguos a nuevos

---

### 16. **RRMM PREVAE** (Revisiones Médicas - Prevención AE)
**Propósito**: Revisiones médicas de vigilancia prevención

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 14 |
| **Columnas** | DEL, NOMBRE, FECHA, IMPORTE, FACTURA, OBSERVACIONES, ctcentro, ctcliente, MinContra, clcifdni, RMmicentro, clcodigo, RMPreCenCli |
| **Tipos de Datos** | String (DEL, NOMBRE, FACTURA, OBSERVACIONES), DateTime (FECHA), Double (IMPORTE, MinContra), Int64 (centros, códigos) |
| **Medidas Definidas** | 1 |
| **Medidas** | TotRMPrevae = SUM(IMPORTE) |
| **Fuente de Datos** | Excel (\\10.10.138.5\Excels PBIs\CartasS de Aptitud.xlsx) |

**Características Especiales**:
- Similar a RRMM MP pero desde proveedor Prevention
- Join por DNI con contratos
- Filtros de contrato válido (entre fecha ±10 días iniciales y fin real)

---

### 17. **RRMMQUIRON23** (Revisiones Médicas - Quirón 2023)
**Propósito**: Reconocimientos médicos Quirón año 2023

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 15+ |
| **Columnas** | Del, DNI/NIE, Nombre, CentrodeTrabajo, PuestodeTrabajo, FechaReconocimiento, Vigencia(meses), GradoAptitud, Importe, Factura, ImporteAnaliticas, Factura_1, ctcentro, ctcliente, TotFra |
| **Tipos de Datos** | Int64, String, DateTime, Double |
| **Medidas Definidas** | 3 |
| **Medidas** | TFraRRMM, TotRevis, 'TFraRRMM MA', TotRRMM34 (suma de todas) |
| **Propiedades** | excludeFromModelRefresh = true |

**Descripción Funcional**: 
- Reconocimientos de 2023
- Grado de aptitud registrado
- Cálculo de total = Importe + ImporteAnaliticas

---

### 18. **RRMMQUIRON24** (Revisiones Médicas - Quirón 2024)
**Propósito**: Reconocimientos médicos Quirón año 2024

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 13+ |
| **Columnas** | Del, DNI/NIE, Nombre, CentrodeTrabajo, PuestodeTrabajo, FechaReconocimiento, Vigencia(meses), GradoAptitud, Importe, Factura, ImporteAnaliticas, Factura_1, ctcentro, ctcliente |
| **Medidas Definidas** | 4 |
| **Medidas** | TFraRRMM4, 'TFraRRMM MA4', TotRevis4, TotRRMM34 (suma de todas RRMM) |

**Descripción Funcional**: 
- Continuación de reconocimientos para 2024
- Estructura similar a RRMMQUIRON23

---

### 19. **RRMMQUIRON25** (Revisiones Médicas - Quirón 2025)
**Propósito**: Reconocimientos médicos Quirón año 2025

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 13+ |
| **Columnas** | Del, DNI/NIE, Nombre, CentrodeTrabajo, PuestodeTrabajo, FechaReconocimiento, Vigencia(meses), GradoAptitud, Importe, Factura, ImporteAnaliticas, Factura_1, ctcentro, ctcliente |
| **Medidas Definidas** | 1 |
| **Medidas** | TFraRRMM5 = SUM(TotFra5) |

**Descripción Funcional**: 
- Reconocimientos 2025
- Integrada en medida TotRRMM34 para totalización

---

### 20. **Selecciono EoD**
**Propósito**: Tabla de parámetro para selección de empresa/delegación

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 1 |
| **Columnas** | Ambito |
| **Tipos de Datos** | String |
| **Medidas Definidas** | 0 |
| **Fuente de Datos** | Tabla calculada con valores: "Empresa", "Delegación" |

**Descripción Funcional**: 
- Control dinámico para filtros scope
- Selección de perspectiva: totales empresa vs. delegación

---

### 21. **TMargen**
**Propósito**: Tabla de parámetro para selecciones de margen

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 1 |
| **Columnas** | NMargen |
| **Tipos de Datos** | Int64 |
| **Medidas Definidas** | 0 |
| **Fuente de Datos** | Tabla calculada con valores númericos |

**Descripción Funcional**: 
- Control dinámico para análisis de margen
- Valores posibles para selección de escenarios

---

### 22. **Trabajadores**
**Propósito**: Tabla maestra de trabajadores con contratos activos

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 4 |
| **Columnas** | cttrabajador, trnombrecompleto, trnif, trsexo |
| **Tipos de Datos** | Int64 (cttrabajador), String (nombre, nif, sexo) |
| **Medidas Definidas** | 0 |

**Descripción Funcional**: 
- Trabajadores únicos con contratos activos desde 2022
- Información demográfica básica
- NIF como clave para joins con pruebas médicas

---

### 23. **VKpei**
**Propósito**: Tabla de valores clave/parametrización para visualizaciones

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 2 |
| **Columnas** | Nombre, Importe |
| **Tipos de Datos** | String (Nombre), Double (Importe) |
| **Medidas Definidas** | 20+ |

**Medidas Principales**:
- Límites de rango: Vmin, Vmax, Vmin2, Vmax2, Vmin3, Vmax3, Vmin4, Vmax4
- Parámetros temporales: tastart, taend, tastart2, taend2, tastart3, taend3, tastart4
- Parámetros anuales: taast, taaend, taast2, taaend2, taast3, taaend3

**Propósito**:
- Almacena umbrales y parámetros para KPI y visualizaciones
- Cada medida extrae un valor específico por nombre de parámetro

---

### 24. **Facturas** (Tabla Transaccional Principal)
**Propósito**: Transacciones de facturación a clientes

| Característica | Detalle |
|---|---|
| **Número de Columnas** | 12+ |
| **Columnas** | fccentro, fcdocum, fcfecha, fccliente, fccencli, (más columnas según query) |
| **Tipos de Datos** | Int64 (centros, documentos, clientes), DateTime (fcfecha), Double (montos) |
| **Medidas Definidas** | 5 |
| **Medidas** | TotFra, Abonos, 'Fra.Año Act', TotFraf, 'Clientes Nuevos' |

**Descripción Funcional**: 
- Base de facturación periodo analizado
- Cálculos de totales brutos, abonos (facturas negativas)
- Identificación de clientes nuevos con lógica compleja de fechas
- Integración con Calendario para filtrado temporal

**Jerarquías**: 
- Date Hierarchy (fcfecha)

---

## RESUMEN DE RELACIONES Y JERARQUÍAS

### Jerarquías de Fecha Identificadas

Las tablas con columnas de fecha habilitan jerarquías Date Hierarchy automáticas:
- **Calendario**: LocalDateTable_efacd82c-63fc-41fd-8a22-6a764a0d734f
- **Contratos**: LocalDateTable_0702f593-7c21-4127-a0e3-33dd33b75b67 (ctfechaini)
- **Contratos**: LocalDateTable_a70b479b-b2d2-4a77-b433-1c15951b113c (ctfechafinreal)
- **Facturas**: LocalDateTable_a55274b3-16bb-47c6-ab9e-be44d9e22044 (fcfecha)
- **Ofertas**: LocalDateTable_34dfd877-e3ba-44b1-a381-98f3f5becb90 (offechaoferta)
- **Ofertas**: LocalDateTable_1f49e0ec-106f-43a5-b555-df88f09d0977 (offechavalidez)
- **OFlineas**: LocalDateTable_b48a78c4-fde4-4541-8238-2c1e5eb0f545 (offechaoferta)

### Joins Principales Identificados

| Tablas | Columnas | Tipo | Propósito |
|---|---|---|---|
| Clientes ↔ GruposEmp | clgrupo, clsubgrupo ↔ gegrupo, gesubgrupo | Left Outer | Enriquecer con descripción grupo |
| Clientes ↔ Contratos | clcentro, clcodigo ↔ ctcentro, ctcliente | Inner | Validación cliente en contratos |
| Clientes ↔ Facturas | clcentro, clcodigo ↔ fccentro, fccliente | Inner | Validación cliente en facturas |
| Epis ↔ Clientes | (múltiples) | Left Outer | Mapeo de centros y clientes |
| Rappels ↔ Clientes | (múltiples) | Inner | Detalles de cliente |
| RRMM tables ↔ Contratos | trnif/DNI ↔ trnif | Left Outer | Asociar RRMM a contratos |
| RRMM tables ↔ Clientes | (múltiples) | Left Outer | Detalles finales de cliente/centro |
| HistorN01 ↔ Clientes | (múltiples) | Left Outer | Enriquecimiento Centro/Cliente |

---

## ESTADÍSTICAS GENERALES

| Métrica | Valor |
|---|---|
| **Total de Tablas Principales** | 24 |
| **Tablas de Referencia** | 7 (Calendario, Catego, Clientes, GruposEmp, MCANCentros, Trabajadores) |
| **Tablas de Transacciones** | 8 (Facturas, Contratos, Epis, Ofertas, OFlineas, Rappels, estadi) |
| **Tablas de Contabilidad** | 3 (CnHistor, CNHistorR, HistorN01) |
| **Tablas de RRMM** | 5 (RRMM MP, RRMM PREVAE, RRMMQUIRON23, RRMMQUIRON24, RRMMQUIRON25) |
| **Tablas de Parámetros** | 2 (Selecciono EoD, TMargen) |
| **Tabla Especializada** | 1 (VKpei) |
| **Total Medidas Estimadas** | 150+ |
| **Total Columnas Calculadas** | 40+ |
| **Período de Datos** | 2021 en adelante (varía por tabla) |
| **Fuentes de Datos** | SQL Server + Excel |

---

## ÁREAS DE ANÁLISIS PRINCIPALES

### 1. **Análisis de Facturación y Ingresos**
- Facturación total por cliente, centro, período
- Contribución por cliente (% sobre total)
- Comparativas año actual vs. año anterior
- Facturación mes anterior

### 2. **Análisis de Márgenes y Rentabilidad**
- Margen bruto (facturación - costos salarios - SS)
- Margen real (margen bruto - rappels)
- Margen por cliente y período
- Ratio de coeficiente (facturación / coste salario)
- Objetivo de margen bruto (9%)

### 3. **Gestión de Recursos Humanos**
- Asignaciones activas por período
- Promedio de asignaciones por semana/mes/año
- Costos de ausencias (IT, enfermedades, permisos de salud)
- Indemnizaciones e impacto en margen
- Facturación por asignación

### 4. **Control de Costos**
- Costos de personal interno
- Costos de servicios externos
- Desglose analítico por concepto contable
- Costos de vigilancia de salud (RRMM)
- Control de gastos operativos

### 5. **Vigilancia de Salud (RRMM)**
- Seguimiento de reconocimientos médicos
- Proveedores: Quirón (2023, 2024, 2025), PREVAE
- Gastos de aptitud y vigilancia
- Cobertura por centro y puesto

### 6. **Análisis de Ofertas y Contracts**
- Ofertas en vigencia por cliente
- Estructura de tarificación (hora, mes, 7 días)
- Márgenes por categoría de puesto
- Validez temporal y estados

### 7. **Análisis de Clientes**
- Clientes activos y nuevos
- Grupos empresariales y estructuras
- Distribución por centros
- Contacto de delegados

---

## OBSERVACIONES TÉCNICAS

### Particularidades del Modelo

1. **Transformaciones de Centros**: 
   - Lógica especial donde centro 71 se transforma a 22 a partir de marzo 2024
   - Afecta tablas: Epis, RRMM MP, RRMM PREVAE

2. **Mapeo de Clientes (2024+)**:
   - En Epis: mapeo manual de códigos antiguos a nuevos (ej: 60492→160242)
   - Aplicado temporalmente para uniformidad de data

3. **Fuentes Mixtas**:
   - SQL Server (TEMPORING database, n4db003): mayoria de tablas operativas
   - Excel: Centros MCA, Cartas de Aptitud (RRMM MP, PREVAE)
   - Tablas calculadas: Selecciono EoD, TMargen, VKpei

4. **Medidas de Período Dinámicas**:
   - Calendario proporciona variables de fecha calculadas
   - Permite análisis móviles sin filtros estáticos
   - Base para cálculos de comparativas

5. **Filtros de Datos Aplicados**:
   - Clientes: solo activos desde 2022
   - HistorN01: solo nómina tipo "N" y conceptos específicos
   - Epis: solo artículos con marca "respi"
   - Ofertas: desde 2021

6. **Cardinalidad de Joins**:
   - Muchos joins Left Outer para enriquecimiento
   - Algunos Inner para validación
   - Potencial para múltiples-a-uno require precaución

---

## PRÓXIMOS PASOS RECOMENDADOS

1. **Documentación de Relaciones**: Crear diagrama ER del modelo completo
2. **Validación de Calidad**: Auditoría de datos en tablas clave
3. **Optimización de Rendimiento**: Revisar índices y agregaciones
4. **Documentación de Lógica de Negocio**: Detalle de cada medida
5. **Plan de Mantenimiento**: Procedimientos de actualización de datos

---

**Documento generado**: {{ fecha actual }}  
**Fuentes analizadas**: 24 archivos TMDL  
**Versión del Modelo**: 1.0 Análisis Inicial
