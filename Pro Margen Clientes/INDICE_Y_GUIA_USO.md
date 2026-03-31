# Documentación Técnica - Índice y Guía de Uso
**Pro Facturación Margen Clientes - Power BI Semantic Model**

---

## 📋 DOCUMENTOS GENERADOS

### 1. **ANALISIS_TABLAS_MODELO.md** 
📄 Documento Principal - Detallado y Exhaustivo

**Contenido**:
- ✅ Análisis completo de las 24 tablas principales
- ✅ Para cada tabla: 
  - Nombre y propósito
  - Número y nombres de columnas
  - Tipos de datos por columna
  - Medidas definidas (si aplica)
  - Breve descripción funcional
  - Características especiales y transformaciones
  - Jerarquías y validaciones
- ✅ Resumen de relaciones y jerarquías
- ✅ Estadísticas generales del modelo
- ✅ Áreas de análisis por dominio
- ✅ Observaciones técnicas
- ✅ Próximos pasos recomendados

**A quién está dirigido**: 
- Analistas de datos que necesitan comprensión profunda
- Desarrolladores Power BI
- Administradores de modelos
- Auditoría técnica

**Cómo usarlo**:
1. IR A: Tabla específica por nombre (Ctrl+F)
2. REVISAR: Estructura, medidas, joins
3. ENTENDER: Lógica de cálculos
4. INTEGRAR: En tus consultas/reportes

---

### 2. **RESUMEN_RAPIDO_TABLAS.md**
⚡ Documento de Referencia - Tabular y Compacto

**Contenido**:
- ✅ Tabla de referencia rápida (tablas x características)
- ✅ Tablas categorizadas por tipo (Referencia, Transacciones, Contabilidad, RRMM, Especiales)
- ✅ Columnas clave por tabla (estructuradas)
- ✅ Medidas clave agrupadas por área (Ingresos, Márgenes, Costos, etc)
- ✅ Jerarquías de fecha
- ✅ Joins automáticos principales
- ✅ Estadísticas de datos
- ✅ Transformaciones y validaciones
- ✅ Patrones de cálculo (fórmulas)
- ✅ Particularidades especiales
- ✅ Guía de uso por tipo análisis
- ✅ Notas de mantenimiento

**A quién está dirigido**:
- Usuarios de reportes que necesitan referencia rápida
- Consultores que preparan presentaciones
- Data Scientists en análisis exploratorio
- Cualquiera que necesita encontrar información RÁPIDO

**Cómo usarlo**:
1. BUSCAR: Tabla/medida en tablas compactas (Ctrl+F)
2. SCANNEAR: Resumen rápido en tablas
3. COPY: Información para presentaciones
4. REFERENCIAR: Patrones y ejemplos

---

### 3. **ESTRUCTURA_RELACIONES_MODELO.md**
🔗 Documento Visual - Diagramas y Arquitectura

**Contenido**:
- ✅ Arquitectura general del modelo (capas)
- ✅ Diagrama de dimensiones (tablas de referencia)
- ✅ Diagrama de hechos y transacciones
- ✅ Diagrama de análisis y agregaciones
- ✅ Diagrama de contabilidad
- ✅ Diagrama de vigilancia (RRMM)
- ✅ Flujo de datos y relaciones (visual)
- ✅ Matriz de relaciones (FK/PK)
- ✅ Flujo de cálculo de márgenes (step-by-step)
- ✅ Transformaciones especiales (centros, clientes)
- ✅ Configuración de períodos dinámicos
- ✅ Puntos de integración clave
- ✅ Índices y cardinales
- ✅ Resumen visual del flujo

**A quién está dirigido**:
- Arquitectos de soluciones BI
- Nuevos miembros del equipo (onboarding)
- Personas visuales que necesitan mapas
- Diseñadores de reportes
- Stakeholders presentación de estructura

**Cómo usarlo**:
1. VISUALIZAR: Los diagramas ASCII art
2. ENTENDER: Relaciones y flujos
3. NAVEGAR: Camino de joins
4. PRESENTAR: A stakeholders

---

## 🎯 MATRIZ DE CONSULTA RÁPIDA

### Si buscas...

| Necesidad | Documento | Sección | Búsqueda |
|---|---|---|---|
| Detalles completos de una tabla | Análisis | Busca tabla por nombre | `### 1. Calendario` |
| Medidas de una tabla rápido | Resumen Rápido | Sección "MEDIDAS CLAVE" | `**Tabla: estadi**` |
| Cómo se calcula el margen | Estructura | Flujo de Cálculo | `CÁLCULO DE MARGEN` |
| Qué columnas tiene tabla X | Resumen Rápido | Sección "COLUMNAS CLAVE" | `### Clientes` |
| Cómo están relacionadas 2 tablas | Estructura | Matriz de Relaciones | Busca tablas |
| Tipos de datos de columnas | Análisis | Tabla específica | `Tipos de Datos` |
| Todas las jerarquías | Resumen Rápido | Sección "JERARQUÍAS" | `JERARQUÍAS DE FECHA` |
| Transformaciones especiales | Estructura | Sección "TRANSFORMACIONES" | `TRANSFORMACIONES ESPECIALES` |
| Cómo usar para análisis X | Resumen Rápido | Sección "GUÍA DE USO" | `Para Análisis de...` |
| Próximos pasos recomendados | Análisis | Al final | `PRÓXIMOS PASOS` |
| Cardinalidad de un join | Estructura | Cardinales de Relaciones | `CARDINALES` |
| Período dinámico | Estructura | Configuración Análisis | `SELECCIONES DE PERÍODO` |
| Totales/agregaciones modelo | Resumen Rápido | Estadísticas | `ESTADÍSTICAS DE DATOS` |
| Diagrama ER simple | Estructura | Arquitectura General | `ARQUITECTURA GENERAL` |

---

## 📊 NAVEGACIÓN POR CATEGORÍA

### TABLAS DE REFERENCIA

| Tabla | Análisis | Resumen | Estructura | Línea |
|---|---|---|---|---|
| Calendario | ✅ p.X | ✅ | ✅ | 1 |
| Catego | ✅ p.X | ✅ | - | 2 |
| Clientes | ✅ p.X | ✅✅ | ✅ | 3 |
| GruposEmp | ✅ p.X | ✅ | - | 9 |
| MCANCentros | ✅ p.X | ✅ | - | 11 |
| Trabajadores | ✅ p.X | ✅ | - | 22 |
| TMargen | ✅ p.X | ✅ | - | 21 |
| Selecciono EoD | ✅ p.X | ✅ | - | 20 |

### TABLAS DE TRANSACCIONES

| Tabla | Análisis | Resumen | Estructura | Línea |
|---|---|---|---|---|
| Facturas | ✅ p.X | ✅ | ✅ | 24 |
| Contratos | ✅ p.X | ✅ | ✅ | 6 |
| Epis | ✅ p.X | ✅ | ✅ | 7 |
| Ofertas | ✅ p.X | ✅ | - | 12 |
| OFlineas | ✅ p.X | ✅ | - | 13 |
| Rappels | ✅ p.X | ✅ | ✅ | 14 |
| estadi | ✅ p.X | ✅✅ | ✅ | 8 |

### TABLAS DE CONTABILIDAD

| Tabla | Análisis | Resumen | Estructura | Línea |
|---|---|---|---|---|
| CnHistor | ✅ p.X | ✅ | ✅ | 4 |
| CNHistorR | ✅ p.X | ✅ | ✅ | 5 |
| HistorN01 | ✅ p.X | ✅ | ✅ | 10 |

### VIGILANCIA MÉDICA (RRMM)

| Tabla | Análisis | Resumen | Estructura | Línea |
|---|---|---|---|---|
| RRMM MP | ✅ p.X | ✅ | ✅ | 15 |
| RRMM PREVAE | ✅ p.X | ✅ | ✅ | 16 |
| RRMMQUIRON23 | ✅ p.X | ✅ | - | 17 |
| RRMMQUIRON24 | ✅ p.X | ✅ | - | 18 |
| RRMMQUIRON25 | ✅ p.X | ✅ | - | 19 |

### TABLA ESPECIALIZADA

| Tabla | Análisis | Resumen | Estructura | Línea |
|---|---|---|---|---|
| VKpei | ✅ p.X | ✅ | - | 23 |

---

## 🔍 BÚSQUEDAS COMUNES Y DÓNDE ENCONTRARLAS

### Búsqueda: "¿Cómo se calcula el margen?"
**Respuesta**: Documento Estructura, apartado "Flujo de Cálculo de Márgenes"
```
Margen € = Facturación - (CostoSalarios + CostoSS)
Margen % = 1 - (Costos / Facturación)
MargenMR = margen bruto - Rappels
```

### Búsqueda: "¿Qué medidas tiene la tabla estadi?"
**Respuesta**: Documento Análisis, tabla "Medidas Principales"
```
Medidas principales: Tfra, Fra.Año Act, Margen €, Margen %, 
Coeficiente, Clientes Activos, y 35+ más
```

### Búsqueda: "¿Cómo se unen Clientes y Facturas?"
**Respuesta**: Documento Estructura, matriz de relaciones
```
FK: fccentro, fccliente → PK: clcentro, clcodigo (JOIN izquierdo)
```

### Búsqueda: "¿De dónde viene la data?"
**Respuesta**: Documento Análisis, tabla específica, campo "Fuente"
```
Mayoría: SQL Server (10.10.138.5\TEMPORING, base no3001)
RRMM: Excel (\\10.10.138.5\Excels PBIs\CartasS de Aptitud.xlsx)
Centros: Excel (\\10.10.138.5\Excels PBIs\MCA Oficinas.xlsx)
```

### Búsqueda: "¿Qué columnas tiene Clientes?"
**Respuesta**: Documento Resumen Rápido, sección "COLUMNAS CLAVE"
```
clcentro, clcodigo, clnombre, clnomfis, clcifdni, clgrupo, 
clsubgrupo, gedescripcion, MCSucursal, + calculadas
```

### Búsqueda: "¿Hay transformaciones especiales?"
**Respuesta**: Documento Estructura, "TRANSFORMACIONES ESPECIALES"
```
Epis: Centro 71 → 22 en 2024+
RRMM: Mapeo de clientes antiguos a nuevos
HistorN01: Filtro de conceptos de nómina
```

---

## 📈 FLUJOS DE TRABAJO RECOMENDADOS

### 1️⃣ NUEVO EN EL PROYECTO
```
1. Leer: ESTRUCTURA_RELACIONES_MODELO.md
   └─ Apartado: "ARQUITECTURA GENERAL" (5 min)
   
2. Revisar: RESUMEN_RAPIDO_TABLAS.md
   └─ Sección: "TABLA DE REFERENCIA RÁPIDA" (10 min)
   
3. Profundizar: ANALISIS_TABLAS_MODELO.md
   └─ Tablas de interés (15-30 min por tabla)
   
4. Consolidar: Diagrama mental del flujo de datos
   └─ REF: ESTRUCTURA_RELACIONES_MODELO.md "FLUJO DE DATOS"
```

### 2️⃣ CREAR REPORTE NUEVO
```
1. Identificar: Qué necesito (facturación, margen, costos)
   
2. Consultar: RESUMEN_RAPIDO_TABLAS.md
   └─ Sección: "GUÍA DE USO POR ANÁLISIS"
   
3. Diseñar: Qué medidas usaré
   └─ Copiar: DEL ANÁLISIS_TABLAS_MODELO.md
   
4. Entender: Cómo se calculan
   └─ LEER: ESTRUCTURA_RELACIONES_MODELO.md
   
5. Implementar: En Power BI
```

### 3️⃣ AUDITAR MEDIDA EXISTENTE
```
1. Buscar: Medida en ANALISIS_TABLAS_MODELO.md
   └─ Ctrl+F: nombre de medida
   
2. Entender: Lógica y argumentos
   └─ REVISAR: Descripción en Medidas Definidas
   
3. Validar: Relaciones usadas
   └─ CONSULTAR: ESTRUCTURA_RELACIONES_MODELO.md
   
4. Verificar: Período y filtros
   └─ REVISAR: "Configuración de Análisis"
```

### 4️⃣ OPTIMIZAR RENDIMIENTO
```
1. Identificar: Tabla lenta
   └─ REF: ANALISIS_TABLAS_MODELO.md
   
2. Revisar: Joins y transformaciones
   └─ LEER: "Transformaciones" en Tabla
   
3. Analizar: Cardinalidad
   └─ CONSULTAR: ESTRUCTURA_RELACIONES_MODELO.md
   
4. Considerar: Agregaciones o índices
   └─ REF: "Próximos pasos" en Análisis
```

---

## 🎓 CONCEPTOS CLAVE DEL MODELO

### 1. Período Dinámico
El modelo usa **Tabla Calendario** para calcular automáticamente:
- Período seleccionado (fecini, fecfin)
- Período año anterior (feciniaa, fecfinaa)
- Período mes anterior (fecinima, fecfinma)
- Período próximo año (fecininy, fecfinny)

**Beneficio**: Reportes totalmente dinámicos sin filtros fijos

### 2. Margen Bruto vs. Margen Real
- **Margen Bruto**: Facturación - Costos Salario - SS
- **Margen Real**: Margen Bruto - Rappels (descuentos)
- Se calcula en tabla **estadi** con 40+ medidas

### 3. Cliente Central (Hub)
La tabla **Clientes** es el hub central del modelo:
- Se relaciona con: Facturas, Contratos, RRMM, Epis, Ofertas, Rappels, etc.
- Filtra por: Centro + Código Cliente (clave compuesta)
- Enriquece con: Grupo, Subgrupo, Centro MCA, NIF

### 4. Transformación de Centros (2024)
Desde marzo 2024:
- Centro 71 → Centro 22
- Clientes antiguos → Clientes nuevos (mapeo manual)
- Afecta: Epis, RRMM MP, RRMM PREVAE

### 5. Vigilancia de Salud (RRMM)
Consolida 5 tablas diferentes:
- RRMM MP (Mutua Quirón)
- RRMM PREVAE (Prevention)
- RRMMQUIRON23/24/25 (3 años diferentes)
- Total consolidado en medida **TotRRMM34**

---

## ⚡ TIPS DE BÚSQUEDA

### En Word/PDF Viewer
```
Ctrl+F: Abre buscador
Luego escribe:
  - Nombre tabla
  - Nombre medida
  - Palabra clave
```

### Búsquedas Comunes
```
"### " + Nombre tabla         (Análisis)
"| # | " + Nombre tabla       (Resumen)
"FK:" + nombre tabla          (Estructura)
"Medidas:" o "measure:"       (Cualquier doc)
"JOIN" o "relationship"       (Estructura)
```

---

## 📋 CICLO DE MANTENIMIENTO

### Mensual
- [ ] Revisar valores en tabla **VKpei** (parámetros)
- [ ] Validar transformación de centros (71→22)

### Trimestral
- [ ] Auditar medidas de margen en **estadi**
- [ ] Verificar joins en tablas RRMM
- [ ] Revisar período dinámico del Calendario

### Anual
- [ ] Revisar conceptos contables (si cambian códigos)
- [ ] Actualizar documentación si hay cambios
- [ ] Validar mappings manuales (centros, clientes)

---

## 🔗 REFERENCIAS CRUZADAS

Es común ir entre documentos:

```
Análisis
  └─→ "Ver Estructura" 
      └─→ ESTRUCTURA_RELACIONES_MODELO.md

Estructura
  └─→ "Detalles de tabla"
      └─→ ANALISIS_TABLAS_MODELO.md

Resumen Rápido
  └─→ "Detalles"
      └─→ ANALISIS_TABLAS_MODELO.md
  └─→ "Visualmente"
      └─→ ESTRUCTURA_RELACIONES_MODELO.md
```

---

## 📞 PRÓXIMOS PASOS

1. **Leer** este índice completamente (5 min)
2. **Seleccionar** el documento que necesitas (30 seg)
3. **Buscar** la sección específica (Ctrl+F)
4. **Aplicar** en tu análisis/reporte
5. **Consultar** nuevamente si dudas

---

## 📝 NOTAS

- ✅ Documentación generada: Marzo 2026
- ✅ Basada en: Análisis TMDL de 24 tablas principales
- ✅ Período de datos: 2021 en adelante
- ✅ Última actualización del modelo: [Verificar fecha en Power BI]

**Mantén estos documentos actualizados si hay cambios en el modelo semántico.**

---

*Documentación técnica completa: 4 archivos markdown*
*Total de páginas equivalentes: ~50 páginas*
*Información detallada de: 24 tablas, 150+ medidas, 40+ columnas calculadas*
