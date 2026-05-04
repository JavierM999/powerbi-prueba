# DICCIONARIO DE DATOS

## Tablas principales

### CipHoras
- Descripción: Tabla de horas del sistema Net4/CIP.
- Uso: página `Net4` y página `Diferencias`.
- Campos clave:
  - `mrfecha`: fecha de registro.
  - `mrproductor`: código del trabajador/productor.
  - `mrhorpres`: horas netas.
  - `mrhorinci`: horas de incidencias.
  - `Horas normales`, `Nocturno normal`, `Extra normal`, `Extra sábado`, `Extra festivo`, `Nocturno extra`, `Nocturno sábado`, `Nocturno festivo`, `Horas compensacion`, `mrhoras10`.

### HORASOK
- Descripción: Tabla de horas importadas desde Excel.
- Uso: páginas `Excel`, `Excel Import` y `Diferencias`.
- Campos clave:
  - `DNI`: NIF del trabajador.
  - `NOMBRE`: nombre del trabajador.
  - `normal`, `noche`, `extra`, `TOTAL`.
  - `semana`: semana asociada a la fila.
  - `CATEGORIA`, `OPERATIVA`, `RESPONSABLE`.

### Trabajadores
- Descripción: dimensión de trabajadores.
- Uso: referencia para unir a `CipHoras`, `HORASOK` y `Contratos`.
- Campos clave:
  - `cttrabajador`: identificador interno del trabajador.
  - `trnombrecompleto`: nombre completo.
  - `trnif`: NIF del trabajador.

### Contratos
- Descripción: contratos activos de trabajadores.
- Uso: página `Excel Import` y medidas de asignación.
- Campos clave:
  - `ctcontrato`: identificador de contrato.
  - `cttrabajador`: trabajador asociado.
  - `ctfechaini`: fecha de inicio del contrato.
  - `ctfechafinreal`: fecha real de fin del contrato.

### Calendario
- Descripción: dimensión de fechas calculada en el modelo.
- Uso: filtro temporal para análisis por año, mes, semana y día.
- Campos clave:
  - `Date`: fecha real.
  - `Año`, `Mes`, `Semana`, `Día`.
  - `Semana ISO`, `Año ISO`, `Trimestre`, `Trimestre Año`.
  - `SemMia`: semana numérica para unir con `HORASOK.semana`.

### TipHoras
- Descripción: tabla auxiliar de tipos de hora.
- Uso: no aparece utilizada en la definición del informe.
- Campos clave:
  - `Código`
  - `Tipo de Hora`

### HORASOK W17
- Descripción: variante de Excel para la semana W17.
- Uso: no referenciada en los visuales del informe actual.

## Medidas clave

### Horas Net4 / CIP
- `TotH Net4`
  - Suma de las horas netas de `CipHoras`.
- `TotHPres`
  - Medida equivalente a `TotH Net4` en el informe.
- `TotHNormales`, `TotHNoctNorm`, `TotHExtraNorm`, `TotHExtraSab`, `TotHExtraFest`, `TotHNoctExtra`, `TotHNoctSab`, `TotHNoctFest`, `TotHComp`, `TotHInci`
  - Desglosan las horas Net4 por categoría.

### Horas Excel
- `TotH Excel`
  - Suma del total de horas de `HORASOK`.
- `TotNormal Excel`
- `TotNoche Excel`
- `TotExtras Excel`
  - Desglosan las horas del archivo Excel.

### Reconciliación y contratos
- `Diferencia`
  - Cálculo principal de brecha: `TotH Net4 - TotH Excel`.
- `Asignaciones`
  - Cuenta los contratos vigentes en el periodo seleccionado.
- `ContratoActivoSemana`
  - Indica el contrato actual para un trabajador en la semana.
- `FIniContSem`, `FFinContSem`
  - Fechas de inicio y fin del contrato aplicadas a la semana.

### Calendario
- `fecini`
- `fecfin`
  - Determinan los extremos del periodo seleccionado en el calendario.

## Glosario de términos de negocio

- `Net4` / `CIP`
  - Sistema de origen de horas utilizado en `CipHoras`.

- `Excel`
  - Fuente de datos importada desde un fichero de horas (`HORASOK`).

- `DNI`
  - Identificador fiscal del trabajador usado para unir fuentes.

- `cttrabajador`
  - Identificador interno de trabajador en el modelo de contratos.

- `Asignaciones`
  - Número de contratos activos en el periodo.

- `TotH Net4`
  - Horas total calculadas desde el sistema Net4.

- `TotH Excel`
  - Horas total calculadas desde la tabla Excel.

- `Diferencia`
  - Gap entre la hora registrada en Net4 y la hora importada desde Excel.

- `semana`
  - Periodo semanal que agrupa los datos de `HORASOK`.

- `SemMia`
  - Código semana del calendario usado para unir Excel con la dimensión temporal.

- `ContratoActivoSemana`
  - Contrato válido para un trabajador durante la semana analizada.
