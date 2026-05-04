# ÍNDICE Y GUÍA DE USO

## Documentos generados

- `DOCUMENTACION_MODELO.md`
  - Describe la estructura del modelo, las tablas, relaciones, medidas y la lógica de negocio del informe.

- `RESUMEN_EJECUTIVO.md`
  - Presenta el objetivo del informe, las áreas de análisis clave y los usos de negocio principales.

- `DICCIONARIO_DATOS.md`
  - Contiene la descripción de las tablas, campos relevantes, medidas clave y un glosario de términos.

- `INDICE_Y_GUIA_USO.md`
  - Este documento ayuda a navegar la documentación y a identificar qué leer según el rol.

## Para qué sirve cada documento

- `DOCUMENTACION_MODELO.md`
  - Ideal para equipos BI y técnicos que necesitan entender el diseño del modelo y cómo se usa en el informe.

- `RESUMEN_EJECUTIVO.md`
  - Ideal para líderes de negocio, gestores de proyecto y usuarios que necesitan rápidamente qué hace el informe.

- `DICCIONARIO_DATOS.md`
  - Ideal para analistas, desarrolladores y auditores que requieren detalles de columnas y medidas.

- `INDICE_Y_GUIA_USO.md`
  - Ideal para onboarding y para quien accede por primera vez a la documentación.

## A quién está dirigido

- Analistas de datos que deben entender qué se mide y cómo se cruza.
- Desarrolladores Power BI que trabajan en ajustes o nuevas visualizaciones.
- Responsables de control de horas, nómina y operaciones.
- Auditores internos que revisan la calidad de los datos.

## Cómo utilizarlos

1. Leer primero `RESUMEN_EJECUTIVO.md` para conocer el enfoque y las métricas clave.
2. Consultar `DOCUMENTACION_MODELO.md` para entender la estructura, las relaciones y las páginas del informe.
3. Usar `DICCIONARIO_DATOS.md` cuando necesites detalles concretos de tablas, campos o medidas.
4. Volver a este documento para ubicar qué sección consultar según la tarea.

## Casos de uso típicos

- Crear un nuevo visual
  - Revisar `DOCUMENTACION_MODELO.md` para conocer las tablas y relaciones.
  - Consultar `DICCIONARIO_DATOS.md` para identificar las medidas necesarias.

- Auditar una medida
  - Usar `DICCIONARIO_DATOS.md` para ver el significado de la medida.
  - Revisar `DOCUMENTACION_MODELO.md` para entender en qué páginas se usa.

- Onboarding de un nuevo miembro del equipo
  - Leer `RESUMEN_EJECUTIVO.md` primero para situarse.
  - Profundizar en `DOCUMENTACION_MODELO.md` y `DICCIONARIO_DATOS.md` según el rol.

- Validar discrepancias entre fuentes de horas
  - Consultar `DOCUMENTACION_MODELO.md` para ver cómo se compara `TotH Net4` con `TotH Excel`.
  - Revisar el glosario para interpretar correctamente los términos.

## Nota final

Esta documentación se ha generado a partir de los archivos del proyecto y de la definición del reporte. Se ha priorizado lo que está realmente implementado en el informe frente a elementos del modelo que no aparecen en los visuales actuales.
