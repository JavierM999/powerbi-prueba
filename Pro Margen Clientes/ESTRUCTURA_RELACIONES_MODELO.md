# Estructura y Relaciones del Modelo Semántico
**Pro Facturación Margen Clientes - Diagrama Conceptual**

---

## ARQUITECTURA GENERAL

```
┌─────────────────────────────────────────────────────────────────┐
│                    MODELO SEMÁNTICO                            │
│           Pro Facturación Margen Clientes (PBIP)               │
└─────────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    │                   │
        ┌───────────▼─────────┐  ┌─────▼──────────────┐
        │  DIMENSIONES        │  │  HECHOS/MÉTRICAS  │
        │  (Referencia)       │  │  (Transacciones)  │
        └─────────────────────┘  └───────────────────┘
```

---

## CAPAS DEL MODELO

### CAPA 1: DIMENSIONES (Tablas de Referencia)

```
CALENDARIO                          PERSONA
┌──────────────────┐               ┌──────────────────┐
│ Date (PK)        │               │ cttrabajador(PK) │
│ DateKey          │               │ trnombrecompleto │
│ Año              │               │ trnif            │
│ Mes (Número)     │               │ trsexo           │
│ Mes (Corto)      │               └──────────────────┘
│ Año/Mes          │
│ + 10 Medidas     │               CLIENTES
└──────────────────┘               ┌──────────────────────┐
        │                          │ clcentro + clcodigo  │
        │                          │    (PK Compuesta)    │
   Jerarquía:                       │ clnombre             │
   Year →                           │ clgrupo              │
   Month →                          │ clsubgrupo           │
   Day                              │ clcifdni             │
                                    │ ClCenCli (FK)        │
                                    │ ClUniGruS (FK)       │
                                    └──────────────────────┘
                                            │
CENTRO/DELEGACIÓN                           │
┌──────────────────┐                        │
│ Id (PK)          │                        │
│ Sucursal         │                        │
│ Texto            │                        │
│ Nombre           │                        │
│ Delegado         │                        │
└──────────────────┘                        │
                                            │
GRUPOS/CATEGORÍAS                           │
┌──────────────────┐                        │
│ gegrupo (PK1)    │◄───────────────────────┘
│ gesubgrupo (PK2) │
│ gedescripcion    │
│ gevendedor       │
│ geclcentro       │
│ geclcodigo       │
└──────────────────┘
```

---

### CAPA 2: HECHOS Y TRANSACCIONES

```
┌─────────────────────────────────────────────────────────────────────┐
│                      TRANSACCIONES PRINCIPALES                      │
└─────────────────────────────────────────────────────────────────────┘

CONTRATOS (Núcleo de Asignaciones)
┌──────────────────────────────────┐
│ ctcentro + ctcontrato +          │
│   cttrabajador (PK Compuesta)    │
│                                  │
│ FK: ctcentro → Calendario        │
│ FK: cttrabajador → Trabajadores  │
│ FK: ctcliente → Clientes         │
│                                  │
│ Fechas: ctfechaini, ctfechafinreal
│ Medidas: Asignaciones, AvWeek,   │
│          FraXAsig, AvAnyoWeek    │
└──────────────────────────────────┘
         │
         ├─────────────────────────────┐
         │                             │
         ▼                             ▼
   FACTURAS                      NÓMINA/AUSENCIAS
┌────────────┐                  ┌──────────────────┐
│ fccentro   │                  │ hncentro         │
│ fcdocum    │                  │ hncontrato       │
│ fcfecha─┐  │                  │ cttrabajador     │
│ fccliente  │  │                  │ hnanyoliq        │
│ fccencli   │  │                  │ hnmesliq         │
│ Medidas:   │◄──┼──────────────────│ FechaH (DateTime)
│ TotFra     │   │                  │ hnconcepto       │
│ Abonos     │   │                  │                  │
│ Clientes   │   │                  │ Medidas:         │
│ Nuevos     │   │                  │ CosteIT          │
└────────────┘   │                  │ CostePermiso     │
                 │                  │ CosteAbsen€      │
              [PK] Composite        │ % ABS            │
                                    └──────────────────┘
```

---

### CAPA 3: ANÁLISIS Y AGREGACIONES

```
ESTADÍSTICAS (Tabla Clave de Márgenes)
┌─────────────────────────────────────────────┐
│ esfecha (DateTime)                          │
│ escliente (int)                             │
│                                             │
│ Importes Base:                              │
│ • SImpFra (Facturación)                     │
│ • SCosSal (Costo Salario)                   │
│ • SCosSs (Seguridad Social)                 │
│ • SIndem (Indemnizaciones)                  │
│                                             │
│ Medidas (40+):                              │
│ • Tfra, Tfra año ant, Tfra mes anterior    │
│ • Margen €, Margen %, Margen Real %        │
│ • Coeficiente (Fra/Costo)                   │
│ • Variaciones, Comparativas                 │
│ • Clientes Activos                          │
│ • % Participación                           │
│                                             │
│ FK: esfecha → Calendario                    │
│ FK: escliente → Clientes → MCANCentros     │
│ FK: Integra Rappels[RapNYear]              │
└─────────────────────────────────────────────┘

RAPPELS (Descuentos/Compensaciones)
┌──────────────────────────────────┐
│ mvcentro + mvcliente +           │
│   mvcencli + mvfecha (PK)        │
│                                  │
│ Totfra (Total Rappel)            │
│                                  │
│ Medidas:                         │
│ • TotRapp, RapNYear             │
│ • RapAAnt, RapAEnt              │
│                                  │
│ FK: mvcentro, mvcliente → Clientes
└──────────────────────────────────┘
```

---

### CAPA 4: ANÁLISIS CONTABLE

```
CONTABILIDAD SIMPLIFICADA          CONTABILIDAD ANALÍTICA DETALLADA
┌────────────────────────┐        ┌──────────────────────────────┐
│ CnHistor               │        │ CNHistorR                    │
│                        │        │                              │
│ hidelegacion           │        │ Medidas por Rango Contable:  │
│ hiseccion              │        │ • Ingresos Servicios (7050)  │
│ hicuenta               │        │ • Ingresos Diversos (7590)   │
│ hidocum                │        │ • Selección Personal (7050.1)│
│ hitipo                 │        │ • Personal Externo (6400)    │
│ hifechamd              │        │ • Comisiones (6230)          │
│ importe                │        │ • Servicios Bancarios (6260) │
│ MiImport (ajustado)    │        │ • Formación (6480)           │
│                        │        │ • Viajes (6290)              │
│ Medidas:               │        │ • Otros (6270, 6490, etc)    │
│ Servicos de Selección  │        │ • Pérdidas (6500, 6940)      │
│                        │        │ • Reversiones (7940)         │
└────────────────────────┘        └──────────────────────────────┘
         │
         └──────────────────────┬─────────────────────┘
                                │
                        Base para margen
                        y análisis contable
```

---

### CAPA 5: VIGILANCIA DE SALUD (RRMM)

```
VIGILANCIA MÉDICA - Múltiples Proveedores
┌──────────────────────────────┐
│   RRMM MP                    │
│   (Mutua Quirón)             │
│   • Período: Múltiple        │
│   • Fuente: Excel            │
│   • Medida: TFraRRMMMP       │
└──────────┬───────────────────┘
           │
           │ FK: NIF ↔ Contratos → Clientes
           │
┌──────────▼───────────────────┐    ┌──────────────────────────────┐
│   RRMM PREVAE                │    │   RRMMQUIRON23/24/25         │
│   (Prevention)               │    │   (3 Tablas por Año)         │
│   • Período: Múltiple        │    │   • Período: 2023, 2024,2025 │
│   • Fuente: Excel            │    │   • Fuente: Cálculo          │
│   • Medida: TotRMPrevae      │    │   • Medida: TFraRRMM+        │
└──────────┬───────────────────┘    └──────────────┬───────────────┘
           │                                      │
           │ FK: DNI ↔ Contratos                  │
           │                                      │
           └──────────────────┬───────────────────┘
                              │
                    FK: Clientes, Centro
                              │
                    ┌─────────▼──────────┐
                    │   CONSOLIDACIÓN   │
                    │ TotRRMM34 = Sum   │
                    │ (Todas RRMM)      │
                    └───────────────────┘
```

---

## FLUJO DE DATOS Y RELACIONES

### Relación Central: CLIENTES

```
                              ┌─────────────┐
                              │  SELECTOREO │
                              │   EoD       │
                              │ (Empresa vs │
                              │ Delegación) │
                              └─────┬───────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
        ┌───────────▼───────────┐   │   ┌───────────▼───────┐
        │     CLIENTES (Eje)    │   │   │  MCANCentros      │
        │ clcentro + clcodigo   │   │   │  (Oficinas)       │
        │      (PK)             │   │   └───────────────────┘
        │                       │   │
        ├───────────────────────┤   │   ┌───────────────────┐
        │ FK: clgrupo,          │   │   │  GruposEmp        │
        │     clsubgrupo →      │   │   │  (Clasificación)  │
        │     GruposEmp         │   │   └───────────────────┘
        └───┬──────┬───────┬────┘   │
            │      │       │        │
     ┌──────▼──┐  │   ┌───▼────┐   │
     │Cada     │  │   │Cada    │   │
     │Tabla    │  │   │Tabla   │   │
     │Fact     │  │   │RRMM    │   │
     │usa      │  │   │usa     │   │
     │CenCli   │  │   │CenCli  │   │
     │como FK  │  │   │como FK │   │
     └────┬────┘  │   └────┬───┘   │
          │       │        │       │
    ┌─────▼───┬───▼──┬──────▼────┐ │
    │ Facturas│ Epis │ RRMM...  │ │
    │Contratos│Ofertas│ Rappels │ │
    │   ...   │        │         │ │
    └─────────┴────────┴─────────┘ │
                                    │
                            Calendario
                            como filtro
```

### Secuencia de JOIN Lógicos

```
1. CLIENTE BASE
   Clientes (clcentro, clcodigo)

2. INFORMACIÓN COMPLEMENTARIA
   ├─ GruposEmp (gegrupo, gesubgrupo)
   └─ MCANCentros (Id, Sucursal)

3. OPERACIONES
   ├─ Facturas (por fccentro, fccliente)
   ├─ Contratos (por ctcentro, ctcliente, cttrabajador)
   ├─ Ofertas (por ofcentro, ofcliente)
   └─ OFlineas (por ofcentro, ofcodigo)

4. COSTOS Y GASTOS
   ├─ Nómina (HistorN01 por centro, cliente, concepto)
   ├─ RRMM (múltiples por nif/dni)
   └─ Contabilidad (CNHistorR por cuenta)

5. ANÁLISIS AGREGADO
   ├─ estadi (facturación + márgenes)
   └─ Rappels (descuentos)

6. RESULTADO
   Margen = Fra - Costos (después aplicar Rappels)
```

---

## MATRIZ DE RELACIONES

```
╔════════════════════╦═════════════╦═════════════╦══════════════╗
║ TABLA ORIGEN       ║ FK COLUMNA  ║ TABLA DEST  ║ PK COLUMNA   ║
╠════════════════════╬═════════════╬═════════════╬══════════════╣
║ Clientes           ║ clgrupo,    ║ GruposEmp   ║ gegrupo,     ║
║                    ║ clsubgrupo  ║             ║ gesubgrupo   ║
╠════════════════════╬═════════════╬═════════════╬══════════════╣
║ Contratos          ║ cttrabajador║ Trabajadores║ cttrabajador ║
║                    ║ ctcentro,   ║ Clientes    ║ clcentro,    ║
║                    ║ ctcliente   ║             ║ clcodigo     ║
╠════════════════════╬═════════════╬═════════════╬══════════════╣
║ Facturas           ║ fccentro,   ║ Clientes    ║ clcentro,    ║
║                    ║ fccliente   ║ Calendario  ║ clcodigo/Date║
╠════════════════════╬═════════════╬═════════════╬══════════════╣
║ estadi             ║ esfecha     ║ Calendario  ║ Date         ║
║                    ║ escliente   ║ Clientes    ║ clcodigo     ║
║                    ║ (implícito) ║ Rappels     ║ (cálculo)    ║
╠════════════════════╬═════════════╬═════════════╬══════════════╣
║ Epis               ║ epicentro,  ║ Clientes    ║ clcentro,    ║
║                    ║ clcodigo,   ║ Calendario  ║ clcodigo/Date║
║                    ║ mvfecha     ║             ║              ║
╠════════════════════╬═════════════╬═════════════╬══════════════╣
║ Rappels            ║ mvcentro,   ║ Clientes    ║ clcentro,    ║
║                    ║ mvcliente   ║ Calendario  ║ clcodigo/Date║
║                    ║ mvfecha     ║             ║              ║
╠════════════════════╬═════════════╬═════════════╬══════════════╣
║ HistorN01          ║ hncentro,   ║ Clientes    ║ clcentro,    ║
║                    ║ cttrabajador║ Contratos   ║ clcodigo     ║
║                    ║ FechaH      ║ Calendario  ║ cttrabajador ║
╠════════════════════╬═════════════╬═════════════╬══════════════╣
║ RRMM MP            ║ ctcentro,   ║ Contratos   ║ ctcentro,    ║
║ RRMM PREVAE        ║ ctcliente   ║ Clientes    ║ ctcentro,    ║
║ RRMMQUIRON24/25    ║ trnif/DNI   ║             ║ clcodigo     ║
║                    ║             ║             ║ / trnif      ║
╠════════════════════╬═════════════╬═════════════╬══════════════╣
║ Ofertas            ║ ofcentro,   ║ Clientes    ║ clcentro,    ║
║ OFlineas           ║ ofcliente   ║ Calendario  ║ clcodigo/Date║
║                    ║ offechaoferta              ║              ║
╠════════════════════╬═════════════╬═════════════╬══════════════╣
║ estadi             ║ Implícito   ║ MCANCentros ║ Sucursal     ║
║                    ║ (a través   ║             ║              ║
║                    ║ de Clientes)║             ║              ║
╚════════════════════╩═════════════╩═════════════╩══════════════╝
```

---

## FLUJO DE CÁLCULO DE MÁRGENES

```
┌─────────────────────────────────────────────────────────────────┐
│                     CÁLCULO DE MARGEN BRUTO                     │
└─────────────────────────────────────────────────────────────────┘

1. BASE: FACTURACIÓN
   estadi.SImpFra
   ↓
   Tfra = SUM(SImpFra)
   ↓
   'Fra.Año Act.NV' = CALCULATE(Tfra, [Período Seleccionado])

2. COSTOS DE PERSONAL
   HistorN01.hnimporte (Nómina: Salario básico seleccionado)
   ↓
   CostoSalario = SUM(HistorN01[hnimporte])
   ↓
   esSumCosSalP = SUM(SCosSal) + SUM(SIndem)
   esSumCosSSP = SUM(SCosSs)
   ↓
   CosteNExternos = esSumCosSalP + esSumCosSSP

3. MARGEN BRUTO
   'Margen €' = Facturación - CosteNExternos
   ↓
   'Margen %' = IF(Fra > 0, 1 - (Costos/Fra), BLANK())
   ↓
   Coeficiente = Facturación / CostoSalario

4. AJUSTES (RAPPELS)
   + RapNYear = CALCULATE(SUM(Rappels[Totfra]), 
                 DATESBETWEEN([Period]))
   ↓
   Fra.AñoMR = Fra.Año - TotRapp + RapNYear
   ↓
   'MargenMR %' = 1 - (Costos / Fra.AñoMR)

5. COMPARATIVAS
   Fra.Año Ant. = CALCULATE(Fra, [Período Año Anterior])
   ↓
   'Variación €' = Fra.Año Act - Fra.Año Ant
   ↓
   '%Variación' = IF(Fra.Año Ant > 0, 
                    (Fra.Año Act - Fra.Año Ant) / Fra.Año Ant,
                    1)

6. DIMENSIONES
   %Fact.A = Fra.Año Act / AllFraAñoAct (SIN FILTROS)
   ↓
   'Clientes Act.' = DISTINCTCOUNT(escliente)
   ↓
   Competencia = FraACentro vs Fra (múltiples perspectivas)
```

---

## TRANSFORMACIONES ESPECIALES

```
┌──────────────────────────────────────────────────────────┐
│         TRANSFORMACIÓN DE DATOS EN CARGA                 │
└──────────────────────────────────────────────────────────┘

EPIS:
┌─ Entrada: mvsucursal, mventidad
│  ├─ Si mvsucursal = 71 Y Fecha >= 2024-03
│  │  └─ epicentro = 22
│  └─ Si no
│     └─ epicentro = mvsucursal
│
├─ Entrada: clcodigo (del join)
│  ├─ Si Año(mvfecha) = 2024
│  │  └─ ClienMiooo = MAPEO_MANUAL[clcodigo]
│  │     Ej: 60492 → 160242, 60378 → 160225, etc.
│  └─ Si no
│     └─ ClienMiooo = clcodigo (original)
│
└─ Salida: SupCentrooo
   ├─ Si ClienMiooo ∈ [160228, 160230, 160227, ...]
   │  └─ SupCentrooo = 16
   └─ Si no
      └─ SupCentrooo = epicentro

RRMM MP / PREVAE:
├─ Join por NIF ↔ Contratos
├─ Filtro: FECHA ∈ [ctfechaini - 10 días, ctfechafinreal]
├─ Transformación: Centro 71 → 22 (si 2024+)
└─ Mapeo Cliente (igual a EPIS)
```

---

## CONFIGURACIÓN DE ANÁLISIS

```
┌─────────────────────────────────────────────────────────┐
│         SELECCIONES DE PERÍODO (Dinámicas)             │
└─────────────────────────────────────────────────────────┘

Calendario proporciona:
┌─ fecini: FIRSTDATE(Calendario[Date])           [Min]
├─ fecfin: LASTDATE(Calendario[Date])            [Max]
│
├─ Período Anterior:
│  ├─ fecinima: Date(Year, Month-1, Day)
│  └─ fecfinma: Date(Year, Month, Day) - 1
│
├─ Año Anterior:
│  ├─ feciniaa: Date(Year-1, Month, Day)
│  └─ fecfinaa: Date(Year-1, Month+1, Day) - 1
│
├─ Año Próximo:
│  ├─ fecininy: Date(Year+1, Month, Day)
│  └─ fecfinny: Date(Year+1, Month+1, Day) - 1
│
└─ Agregadas:
   └─ CtaMeses: MONTH(fecini) - 1

Uso:
All measures calculan:
  CALCULATE([Base Measure],
    FILTER(Tabla, Tabla[Date] >= [fecini]),
    FILTER(Tabla, Tabla[Date] <= [fecfin])
  )
```

---

## PUNTOS DE INTEGRACIÓN CLAVE

```
PUNTO 1: CLIENTES (Hub Central)
├─ Acepta: Centro + Código Cliente
├─ Valida: Activa desde 2022 (contratos o facturas)
├─ Enriquece con: Grupo, Subgrupo, Centro MCA, NIF
└─ Distribuye a: Todos los análisis

PUNTO 2: PERÍODO (Calendario)
├─ Acepta: Selección de fecha en reportes
├─ Calcula: Períodos comparativos automáticamente
└─ Proporciona: Contexto temporal a todas las medidas

PUNTO 3: MARGEN (estadi + CNHistorR)
├─ Integra: Facturación + Costos específicos
├─ Compara: Período actual vs. anterior
├─ Ajusta: Por Rappels y otros descuentos
└─ Genera: KPIs de rentabilidad

PUNTO 4: VIGILANCIA (RRMM Consolidada)
├─ Ingresa: 5 fuentes diferentes
├─ Consolida: En TotRRMM34
├─ Vincula: A clientes por NIF/Centro
└─ Reporta: Cobertura y costos RRHH
```

---

## ÍNDICES Y CLAVES PRIMARIAS

```
┌─────────────────────┬────────────────────────────────┐
│ TABLA               │ CLAVE PRIMARIA / ÍNDICES       │
├─────────────────────┼────────────────────────────────┤
│ Calendario          │ Date                           │
│ Catego              │ cacodigo                       │
│ Clientes            │ clcentro + clcodigo            │
│ GruposEmp           │ gegrupo + gesubgrupo           │
│ MCANCentros         │ Id, Sucursal                   │
│ Trabajadores        │ cttrabajador                   │
│ Contratos           │ ctcentro + ctcontrato +        │
│                     │ cttrabajador + ctcliente       │
│ Facturas            │ fccentro + fcdocum +           │
│                     │ fccliente + fcfecha (Implicit) │
│ Epis                │ No explícita (Agregada)        │
│ estadi              │ No explícita (Agregada)        │
│ Ofertas             │ ofcentro + ofcodigo            │
│ OFlineas            │ ofcentro + ofcodigo + (Line#)  │
│ Rappels             │ mvcentro + mvcliente +         │
│                     │ mvcencli + mvfecha             │
│ HistorN01           │ No explícita (Agregada)        │
│ CnHistor            │ No explícita (Agregada)        │
│ CNHistorR           │ No explícita (Agregada)        │
│ RRMM (todas)        │ Tabla + Fecha + Personal        │
│ VKpei               │ Nombre (Parámetro)             │
│ TMargen             │ NMargen                        │
│ Selecciono EoD      │ Ambito (Parámetro)             │
└─────────────────────┴────────────────────────────────┘
```

---

## CARDINALES DE RELACIONES

```
CLIENTES                        ┬── 1:M ──→ FACTURAS
┌────────────────┐              │
│ clcentro       │──────┐       ├── 1:M ──→ CONTRATOS
│ clcodigo  (PK) │      │       │
└────────────────┘      │       ├── 1:M ──→ EPIS
         ▲              │       │
         │              │       ├── 1:M ──→ RRMM (todas)
         │              │       │
    1:M  │              │       ├── 1:M ──→ OFERTAS
         │              │       │
    GruposEmp           │       ├── 1:M ──→ OFlineas
    (1:M)               │       │
                        │       ├── 1:M ──→ estadi
                        │       │
                        └───────┴── 1:M ──→ Rappels

CALENDARIO              ┬── 1:M ──→ FACTURAS.fcfecha
┌────────────┐          │
│ Date (PK)  │──────┐   ├── 1:M ──→ CONTRATOS.ctfechaini
└────────────┘      │   │
                    │   ├── 1:M ──→ CONTRATOS.ctfechafinreal
                    │   │
                1:M  │   ├── 1:M ──→ OFERTAS.offechaoferta
                    │   │
                    │   ├── 1:M ──→ OFERTAS.offechavalidez
                    │   │
                    │   ├── 1:M ──→ EPIS.mvfecha
                    │   │
                    │   ├── 1:M ──→ Rappels.mvfecha
                    │   │
                    │   ├── 1:M ──→ RRMM.Fecha
                    │   │
                    └───┴── 1:M ──→ estadi.esfecha
```

---

## RESUMEN VISUAL DEL FLUJO DE ANÁLISIS

```
ENTRADA: Selección de Período (Calendario)
         ↓
         ├─→ Fecini, Fecfin calculadas automáticamente
         ├─→ Período Año Anterior calculado
         └─→ Período Mes Anterior calculado

APLICACIÓN: Filtros a Tablas
         ├─→ Clientes: Filtro de centro/grupo
         ├─→ Facturas: Filtro por fechas
         ├─→ Contratos: Filtro por validez
         ├─→ Nómina: Filtro por período
         └─→ RRMM: Filtro por período

CÁLCULO: Medidas
         ├─→ Facturación = SUM(Facturas)
         ├─→ Costos = SUM(Nómina + SS)
         ├─→ Rappels = SUM(Rappels con ajuste período)
         ├─→ Margen = Fra - Costos - Rappels
         ├─→ Comparativa = Período Act vs Período Ant
         └─→ KPI = Ratio, %, coeficientes

SALIDA: Reportes
         ├─→ Por Cliente (máximo detalle)
         ├─→ Por Centro (agregado geografía)
         ├─→ Por Período (Series temporales)
         └─→ Comparativas (Análisis Variación)
```

---

**Documentación**: Octubre 2024  
**Versión Diagrama**: 1.0  
**Basada en**: Análisis TMDL Completo
