# Documentación del modelo

## Descripción general
El proyecto combina un modelo semántico con un reporte de Power BI centrado en el desempeño financiero de delegaciones. El informe utiliza datos de centros, clientes, contratos, facturación y costes reales para mostrar ingresos, márgenes, productividad y riesgo.

## Tablas del modelo

### Tablas de hechos
- **estadi**: agrega ingresos, costes salariales, costes de seguridad social e indemnizaciones por cliente, centro y mes.
- **Contratos**: contiene contratos, horas reales y el cálculo de horas trabajadas para medir productividad.
- **CNHistor Fra**: registra facturación por cliente y cuenta, con ingresos de servicio, selección y rappel.
- **CnHistor**: recoge resultados contables y gastos utilizados para calcular beneficios antes de impuestos.

### Tablas de dimensiones
- **MCANCentros**: delegaciones y centros, con nombre visible (`Texto`) y código de sucursal.
- **Clientes**: cliente, centro, código y clasificación CNAE.
- **Agrupación**: sectores de actividad.
- **Agrupación xCNAE**: clasificación CNAE por grupo económico.
- **Calendario**: jerarquía temporal Año/Mes y fechas usadas en las selecciones.
- **Riesgos03**: exposición de riesgo por cliente y cuenta.
- **TRating**: categorías de riesgo.
- **Pseu Clientes** / **TopN Pareto**: tablas de soporte para selección de clientes y análisis Pareto.

## Relaciones principales
- **Clientes → MCANCentros**: permite analizar datos por delegación.
- **Clientes → Agrupación xCNAE → Agrupación**: permite agrupar ingresos por sector y CNAE.
- **Contratos → Clientes** y **CNHistor Fra → Clientes**: cruzan contratos, facturación y cliente.
- **estadi → Clientes** y **estadi → Calendario**: soportan el cálculo de ingresos y costes reales por periodo.
- **Calendario → CNHistor Fra / CnHistor / Contratos**: habilita la comparación año contra año.
- **Riesgos03 → CtaContRec → TRating**: ofrece contexto de riesgo financiero.

## Medidas principales por área funcional

### Desempeño comercial
- **TotFraCN3**: total de facturación relevante por cliente.
- **PrestServF, RappelSVta, Seleccion**: componentes de ingresos por servicios.
- **Fra.Año Act. / Fra.Año Ant.**: comparación de facturación actual vs año anterior.
- **Variacion %**: evolución de ingresos año a año.

### Productividad
- **Horas Realizadas**: horas trabajadas reales en el periodo.
- **FraXHora / FraXHora AA**: ingresos por hora actual y del año anterior.

### Rentabilidad
- **MARGEN DE CONTRIBUCIÓN** y **MargenGra**: margen operativo sobre facturación.
- **MargenGrAA**: margen del año anterior.
- **Gastos Generales** y variantes centrales: costes generales asociados.
- **BENEFICIOS ANTES DE IMPUESTOS**: resultado financiero antes de impuestos.

### Indicadores de panel
- **PrimCuadro, TercCuadro, QuintCuadro, sEGCuadro**: tarjetas de resumen combinan ingresos, variación, gastos y margen.
- **Top N Pareto, Top 5 FraCNAE, Top 5 Fraestadi**: resaltan la concentración de ingresos en clientes o CNAE.

### Riesgo
- **TRiesgo**: importe expuesto por riesgo en la cartera.

## Lógica de negocio del informe
El informe aplica filtros de delegación, periodo y sector para enfocar el análisis en un subconjunto controlado de centros. Se combina:
- facturación por cliente y CNAE,
- horas reales de contrato y productividad,
- costes reales de personal y otros gastos,
- y comparación con el año anterior para medir tendencia.

El modelo calcula los ingresos relevantes a partir de cuentas de facturación específicas, luego mide su rentabilidad y su eficiencia por hora trabajada.

## Cómo se utiliza el modelo en el reporte
- **Panel Diseño**: muestra el estado general con tarjetas de margen, un gráfico combinando ingresos y productividad, y listas de clientes y sectores clave.
- **CNAE-Cliente**: presenta detalle de cliente por sector y CNAE con facturación y métricas de selección.
- **Duplicado de CNAE-Cliente**: versión adicional del análisis por cliente/CNAE.
- **Resultado Final Descuadra**: muestra el resultado financiero con beneficios antes de impuestos y componentes de gastos.
- **Gráfico arriba descuadra**: combina tendencia de ingresos, productividad y margen por sector.

## Observaciones
- El reporte aplica un filtro de página sobre `MCANCentros.Sucursal = 0` que limita los datos a un subconjunto de centros.
- Existe una página duplicada de análisis CNAE-Cliente, lo que puede indicar redundancia en la presentación.
