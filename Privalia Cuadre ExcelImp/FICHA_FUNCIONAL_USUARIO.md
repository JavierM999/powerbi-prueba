# Ficha funcional de usuario

## Nombre del reporte
Privalia Cuadreymas 151726

## Propósito general
Este reporte presenta una comparación operativa entre las horas registradas en el archivo Excel de importación y los valores Net4 calculados, permitiendo validar discrepancias por trabajador, contrato y calendario.

## Destinatarios
- Analistas de control de horas
- Equipos de operaciones y coordinación
- Gestión de nómina y supervisores de horarios

## Estructura del reporte
El informe está compuesto por 4 páginas:

1. **Excel Import**
   - Muestra los datos importados desde Excel y la relación con referencias de trabajador y contrato.
   - Incluye columnas clave como DNI, nombre, fechas de contrato y totales Excel por trabajador.
   - Permite verificar la fuente de datos original antes de las comparaciones.

2. **Excel**
   - Presenta los totales de horas extraídas del archivo Excel por trabajador.
   - Incluye filtros de calendario para Año, Semana y Mes.
   - Es útil para revisar el detalle de horas Excel por empleado y verificar el contenido importado.

3. **Net4**
   - Muestra los totales Net4 por trabajador.
   - Incluye columnas de TotH Net4 y otros totales de horas procesadas.
   - Permite comparar el resultado Net4 con el origen importado.

4. **Diferencias**
   - Panel de comparación rápida con tarjetas y valores clave:
     - `TotH Excel`
     - `TotH Net4`
   - Incluye filtros por Año, Semana y Día.
   - Permite identificar diferencias operativas y analizar variaciones en el cálculo.

## Funcionalidad y uso

### Filtros disponibles
- **Año**: filtro activo fijado en `2026`.
- **Semana**: filtro activo fijado en `S17`.
- **Mes**: filtro activo fijado en `04`.
- **Día**: disponible en la página `Diferencias` para análisis diario.

> Importante: los slicers del reporte están configurados para filtrar otras visualizaciones del mismo informe (`drillFilterOtherVisuals = true`).

### Métricas clave visibles
- **TotH Excel**: suma de horas registradas en el archivo Excel.
- **TotH Net4**: horas netas calculadas desde el modelo Net4.
- **TotHNormales**, **TotHNoctExtra**, **TotHNoctNorm**, **TotHExtraNorm**, **TotHExtraSab**, **TotHExtraFest**, **TotHNoctFest**, **TotHNoctSab**, **TotHComp**: totales detallados de horas por tipo.
- **TotHInci**: horas de incidencia registradas.
- **TotNormal Excel**, **TotNoche Excel**, **TotExtras Excel**: subtotales Excel por tipo de jornada.

### Tablas de detalle
- La página `Net4` incluye una tabla de detalle por trabajador con los totales de horas calculados en Net4 y datos de identificación.
- La página `Excel` incluye una tabla de detalle por trabajador con totales Excel y datos de origen.
- La página `Excel Import` incluye datos de contrato y fechas clave para validar asignaciones y vigencia.

## Datos y orígenes utilizados
- **Calendario**: para la segmentación por año, semana, mes y día.
- **HORASOK**: fuente principal de horas importadas desde Excel.
- **CipHoras**: fuente de horas Net4 y métricas calculadas.
- **Trabajadores**: identifica al personal por nombre completo y NIF.
- **Contratos**: datos de asignaciones y vigencia contractual.

## Resultado esperado
El reporte debe permitir a los usuarios:
- Comparar rápidamente las horas totales del Excel frente a Net4.
- Verificar discrepancias por trabajador y contrato.
- Identificar si la diferencia ocurre en un día específico, semana o mes.
- Validar si los datos importados se correspondan con los totales del modelo Net4.

## Recomendaciones de uso
- Empiece siempre por la página `Excel Import` para validar datos origen.
- Use la página `Excel` para comprobar el desglose del fichero Excel.
- Use la página `Net4` para verificar lo que el modelo calcula como horas netas.
- Use la página `Diferencias` para detectar rápidamente desajustes y patrones de desviación.
- Verifique los filtros de calendario antes de extraer conclusiones.

## Observaciones
- El informe está diseñado para análisis operativo, no para métricas financieras.
- Las visualizaciones son interactivas y cruzan filtros entre sí.
- La configuración actual está orientada al ejercicio `2026` y la semana `S17`, pero los filtros pueden ajustarse si se actualizan los datos.
