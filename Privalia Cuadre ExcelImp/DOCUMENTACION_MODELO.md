# DOCUMENTACIÓN DEL MODELO

## 1. Descripción general

Este informe se construye sobre el modelo del archivo `Privalia Cuadreymas 151726.pbip`. El modelo combina:
- datos de horas Net4 / CIP (`CipHoras`) obtenidos de una base de datos SQL,
- datos de horas Excel (`HORASOK`) importados desde un fichero local de OneDrive,
- información de contratos y trabajadores para cruzar horas con asignaciones vigentes,
- una dimensión de calendario calculada en el propio modelo.

El objetivo principal del modelo es permitir la comparación y reconciliación de horas entre la fuente de Excel y el sistema Net4/CIP, con un enfoque en trabajador, semana y tipo de hora.

## 2. Tablas del modelo

### Tablas de hechos

- `CipHoras`
  - Hechos de horas del sistema Net4/CIP.
  - Contiene detalle de horas por trabajador, fecha y categoría.
  - Usada directamente en la página `Net4` y en la comparación de diferencias.

- `HORASOK`
  - Hechos de horas importadas desde Excel.
  - Contiene totales de normal, noche, extra y total por trabajador/semana.
  - Usada en las páginas `Excel` y `Diferencias`.

### Tablas de dimensiones y soporte

- `Trabajadores`
  - Dimension de trabajadores / productores.
  - Contiene `cttrabajador`, `trnombrecompleto`, `trnif`.
  - Usada en casi todas las páginas para mostrar el nombre y NIF.

- `Calendario`
  - Dimensión de fechas calculada con años, meses, semanas, día, día de semana, trimestre.
  - Incluye un campo numérico `SemMia` para unir con el campo semanal de `HORASOK`.
  - Usada para filtrar por fecha, año y semana.

- `Contratos`
  - Tabla de contratos activos para los trabajadores.
  - Incluye fecha inicio, fecha fin real y trabajador asociado.
  - Usada en la página `Excel Import` para validar contratos vigentes.

### Tablas del modelo que no aparecen en el informe

- `TipHoras`
  - Tabla auxiliar de tipos de hora.
  - No se ha encontrado uso directo en las páginas del reporte.

- `HORASOK W17`
  - Variante de datos Excel para la semana W17.
  - No aparece referenciada en la definición del informe actual.

## 3. Relaciones principales

- `CipHoras.mrfecha` → `Calendario.Date`
  - Relación de fecha para analizar Net4 por días, semanas y meses.

- `CipHoras.mrproductor` → `Trabajadores.cttrabajador`
  - Relación de trabajador entre el origen Net4 y la dimensión de personas.

- `Contratos.cttrabajador` → `Trabajadores.cttrabajador`
  - Relación que permite calcular contratos activos por trabajador.

- `HORASOK.DNI` → `Trabajadores.trnif`
  - Relación para unir datos Excel con los trabajadores.

- `HORASOK.semana` → `Calendario.SemMia`
  - Relación semanal para mostrar datos Excel por semana.
  - Usa el campo calculado `SemMia` del calendario.

## 4. Medidas principales agrupadas por área funcional

### Horas Net4 / CIP

- `TotH Net4`
- `TotHPres`
- `TotHNormales`
- `TotHNoctNorm`
- `TotHExtraNorm`
- `TotHExtraSab`
- `TotHExtraFest`
- `TotHNoctExtra`
- `TotHNoctSab`
- `TotHNoctFest`
- `TotHComp`
- `TotHInci`

Estas medidas suman los valores de las columnas de horas de `CipHoras`. Son la base del análisis Net4 y permiten desagregar por tipo de hora.

### Horas Excel

- `TotH Excel`
- `TotNormal Excel`
- `TotNoche Excel`
- `TotExtras Excel`

Estas medidas suman las columnas importadas desde `HORASOK`. El informe las utiliza para comparar la fuente Excel con Net4.

### Reconciliación y contrato

- `Diferencia`
  - Calcula `TotH Net4 - TotH Excel`.
  - Es el indicador clave de la página `Diferencias`.

- `Asignaciones`
  - Cuenta los contratos activos en el periodo seleccionado.
  - Evalúa contratos cuyo inicio es anterior o igual al final del periodo y cuya fecha de fin real está vacía o es posterior al inicio.

- `ContratoActivoSemana`
  - Devuelve el contrato activo de un trabajador en la semana seleccionada.

- `FIniContSem`, `FFinContSem`
  - Devuelven fechas de inicio y fin de contrato para la semana seleccionada.
  - Estas medidas intentan armonizar contratos con el período analizado.

### Calendario

- `fecini`
- `fecfin`

Estas medidas devuelven la primera y última fecha del contexto de calendario seleccionado. Se emplean en filtros de periodo y en el cálculo de contratos.

## 5. Lógica de negocio del informe

- El modelo compara horas registradas en el sistema Net4 (`CipHoras`) con horas importadas desde Excel (`HORASOK`).
- Se vinculan trabajadores mediante NIF y código de productor, y se cruzan con contratos vigentes para validar si el trabajador estaba en alta en el periodo.
- Las medidas de horas se agrupan por normal, noche, extra y total para identificar diferencias de origen.
- La página `Diferencias` es el núcleo de la lógica de control: muestra la brecha entre horas Excel y Net4.
- El calendario calculado permite análisis por año, mes, semana y día.

## 6. Áreas de análisis que permite el modelo

- Control operacional de horas por trabajador.
- Reconciliación entre horas Excel y horas Net4.
- Comparación de horas normales, nocturnas y extras.
- Validación de contratos activos y asignaciones.
- Análisis temporal por año, mes y semana.

## 7. Cómo se utiliza el modelo en el reporte

- Página `Net4`
  - Muestra el detalle de horas del sistema Net4 por trabajador.
  - Usa principalmente `CipHoras` y `Trabajadores`.

- Página `Excel`
  - Muestra el detalle de horas importadas desde Excel por trabajador.
  - Usa `HORASOK` y `Trabajadores`.

- Página `Excel Import`
  - Muestra la importación y datos contractuales por trabajador.
  - Usa `HORASOK`, `Trabajadores` y `Contratos`.

- Página `Diferencias`
  - Muestra la brecha entre `TotH Net4` y `TotH Excel`.
  - Usa medidas calculadas de reconciliación y visuales de resumen.

## 8. Observaciones y posibles áreas de mejora

- El modelo incluye `TipHoras` y `HORASOK W17`, pero estos objetos no se detectan en las páginas del informe actuales.
- La medida `FechaFin` en `HORASOK` tiene la misma lógica que `FechaIni`; esto podría ser un error de copia y pegar si se esperaba una fecha de fin distinta.
- El uso de `HORASOK.semana` con `Calendario.SemMia` sugiere que el análisis Excel es semanal y no diario.
