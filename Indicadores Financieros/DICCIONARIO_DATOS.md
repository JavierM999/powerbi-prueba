# Diccionario de Datos

## Tablas principales

- **MCANCentros**: delegaciones controladas por sucursal. La columna `Texto` identifica la delegación usada en filtros y etiquetas del informe.
- **Clientes**: cliente y centro. `ClCenCli` es la clave que conecta facturación y contratos con el centro.
- **Agrupación**: sectores de actividad.
- **Agrupación xCNAE**: CNAE y su sector asociado.
- **Calendario**: fechas y periodos seleccionados. Genera texto de periodo y rango de meses.
- **Contratos**: contratos, horas y cálculo de horas realizadas.
- **CNHistor Fra**: origen de la facturación por servicio, selección y rappel.
- **CnHistor**: resultados contables y gastos usados para calcular beneficios.
- **estadi**: agregación de ingresos y costes reales por cliente/centro/mes.
- **Riesgos03**: exposiciones de riesgo por cliente.
- **TRating**: categoría de riesgo sincronizada con Riesgos03.
- **Pseu Clientes**: lista de clientes extendida con la opción “Otros” para análisis Pareto.
- **TopN Pareto**: valores de porcentaje usados para seleccionar top clientes.

## Campos más relevantes

- **MCANCentros.Texto**: delegación visible en los filtros.
- **Clientes.ClCenCli**: clave cliente-centro.
- **Clientes.clnombre**: nombre de cliente.
- **Clientes.clicnae2d**: CNAE de cliente.
- **Agrupación.Sectores de Actividad**: sector para agrupar resultados.
- **Agrupación xCNAE.Nombre**: clasificación CNAE utilizada en los informes.
- **Calendario.Año/Mes**: selector temporal principal.
- **Calendario.PeriodoSel / Calendario.MesesSel**: resumen del periodo seleccionado.
- **Contratos.Horas Realizadas**: horas de contrato ajustadas al periodo.
- **Contratos.FraXHora / Contratos.FraXHora AA**: ingresos por hora actual y del año anterior.
- **CNHistor Fra.PrestServF / RappelSVta / Seleccion**: componentes principales de la facturación.
- **CNHistor Fra.TotFraCN3**: facturación total relevante por cliente.
- **CnHistor.BENEFICIOS ANTES DE IMPUESTOS**: resultado financiero antes de impuestos.
- **CnHistor.GASTOS FINANCIEROS / Gastos Generales**: costes financieros y generales.
- **CnHistor.INGRESOS**: ingresos totales del periodo.
- **CnHistor.OfTot / OfSelecc**: conteos de delegaciones o selecciones.
- **estadi.Fra.Año Act. / estadi.Fra.Año Ant.**: facturación actual y año anterior en el resumen de estadi.
- **estadi.MargenGra / estadi.MargenGrAA**: margen actual y año anterior.
- **estadi.PrimCuadro / estadi.TercCuadro / estadi.QuintCuadro / estadi.sEGCuadro**: indicadores de cuadro usados en tarjetas.
- **estadi.TopN Pareto / estadi.Top 5 FraCNAE / estadi.Top 5 Fraestadi**: métricas de concentración de ingresos.
- **Riesgos03.TRiesgo**: importe de riesgo por cliente.
- **TRating.Riesgo**: categoría de riesgo.

## Medidas clave explicadas

- **TotFraCN3**: suma de los ingresos más relevantes para un cliente, incluyendo servicio, selección y rappel.
- **FraXHora**: métrica de eficiencia que mide cuánto factura cada hora trabajada.
- **Fra.Año Act. / Fra.Año Ant.**: facturación actual y del mismo periodo del año anterior.
- **Variacion %**: cambio porcentual de facturación entre periodos.
- **MargenGra**: margen operativo sobre ingresos.
- **MargenGrAA**: margen comparable del año anterior.
- **BENEFICIOS ANTES DE IMPUESTOS**: resultado financiero sin impuestos.
- **Top N Pareto**: permite identificar los clientes que concentran el mayor porcentaje de ingresos.
- **TRiesgo**: monto de exposición asociado a clientes en riesgo.

## Glosario de términos de negocio

- **Delegación**: unidad operativa o centro reportado por `MCANCentros`.
- **Cliente**: entidad que genera facturación y se asocia a una delegación.
- **CNAE**: clasificación de la actividad económica usada para agrupar resultados.
- **Contrato**: acuerdo con horas asociadas, usado para calcular productividad.
- **Top N Pareto**: selección de los clientes más importantes por facturación.
- **Margen**: porcentaje que queda después de descontar costes directos.
- **Rappel**: parte de la facturación asociada a descuentos o comisiones comerciales.
- **Selección**: ingresos vinculados a servicios de selección de personal.
- **Periodo**: rango temporal definido por Año/Mes.
- **Riesgo**: exposición financiera de un cliente bajo clasificación de riesgo.
