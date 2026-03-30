# 📋 FICHA FUNCIONAL - INFORME POWER BI
## Para Usuarios de Negocio

---

### Nombre del informe
**Evolución de Asignaciones MCA 2026**

---

### Área / Proceso
**Recursos Humanos / Operaciones** | Gestión de asignaciones laborales

---

### ¿Para qué sirve?

Este informe te permite **monitorear todas las asignaciones de trabajadores a clientes** en tiempo real, ver cómo ha evolucionado el volumen de contrataciones a lo largo del tiempo, y analizar tendencias de crecimiento o decrecimiento. Es tu herramienta para tomar decisiones sobre capacidad de recursos, identificar dónde están tus trabajadores y hacia dónde va el negocio.

---

### Qué puedes consultar aquí

- **Número de asignaciones activas** en cualquier momento (cuántos contratos hay en vigor)
- **Comparativas con períodos anteriores** (¿estamos creciendo o cayendo que el año pasado?)
- **Altas y bajas de personal** en cada período (quién entra y quién se va)
- **Cálculos de horas y productividad** (cuántas horas trabajan nuestros empleados)
- **Análisis por cliente** (quién es mi cliente más grande, cuánta gente asignamos a cada uno)
- **Distribución de trabajadores** por centro, categoría, género, nacionalidad
- **Información de centros** y ubicaciones operacionales
- **Detalles de trabajadores** (edad, experiencia, discapacidad para compliance)

---

### Indicadores clave

| Indicador | ¿Qué significa? |
|-----------|-----------------|
| **Asignaciones** | Número total de contratos en vigor en este momento |
| **Trabajadores activos** | Cuántos empleados diferentes estamos usando (sin duplicados) |
| **Crecimiento** | Aumentamos o disminuimos respecto al mismo período del año pasado (en %) |
| **Altas** | Nuevos contratos empezados en este mes/trimestre |
| **Bajas** | Contratos finalizados en este mes/trimestre |
| **Horas realizadas** | Total de horas trabajadas por todos nuestros empleados |
| **Media de horas/trabajador** | Promedio de horas que trabaja cada empleado |
| **Total clientes** | Cuántos clientes diferentes contratamos en este período |

---

### Filtros disponibles

- **Por período** (mes, trimestre, año) — mira cualquier rango de fechas
- **Por centro** — filtra solo una sucursal o todas
- **Por cliente** — enfócate en un cliente específico o en todos
- **Por categoría de puesto** — técnico, junior, senior, etc.
- **Por trabajador** — análisis individual si lo necesitas
- **Por sexo, edad, nacionalidad** — análisis de diversidad e igualdad
- **Últimos 7 días / 31 días / año anterior** — atajos rápidos para análisis comunes

---

### A quién le sirve

- **Directores de RRHH** — para monitorear volumen de personal y asignaciones
- **Responsables operacionales** — para conocer disponibilidad de recursos en cada centro
- **Directores comerciales** — para entender la capacidad de servicio a clientes
- **Gerentes de proyectos** — para verificar cantidad de horas/recursos asignados
- **Responsables de cumplimiento normativo** — para auditorías de igualdad y accesibilidad
- **Finance** — para análisis de costes de personal por cliente

---

### Ejemplo de uso

*"Quiero saber si hemos crecido en asignaciones respecto a marzo del año pasado y cuántos trabajadores nuevos incorporamos. Voy al informe, selecciono marzo 2026, veo que tengo 1.250 asignaciones vs 980 el año pasado (crecimiento del 27%), y que incorporé 85 trabajadores nuevos este mes."*

---

### Qué decisiones permite tomar

- **¿Necesitamos más personal o menos?** — Compara asignaciones actuales vs capacidad máxima disponible
- **¿Cuál es nuestro crecimiento real?** — Analiza tendencias YoY para planes de negocio
- **¿Dónde están concentrados nuestros recursos?** — Identifica qué centros/clientes tienen más volumen
- **¿Somos eficientes en asignaciones?** — Compara horas/trabajador con estándares internos
- **¿Cuáles son nuestros clientes estratégicos?** — Detecta dónde invertir en relación
- **¿Cumplimos con diversidad?** — Monitorea equidad por sexo, edad, discapacidad
- **¿Qué categorías de perfiles demanda más?** — Planifica formación y reclutamiento
- **¿Hay rotación interna?** — Analiza si los mismos trabajadores se reasignan o entran nuevos

---

### Consideraciones

- ⏰ **Histórico desde 2019**: El informe tiene datos desde enero de 2019 hacia adelante, así que puedes hacer análisis de tendencias multi-año
  
- 🏢 **Múltiples empresas separadas**: Los datos de centros DUN, Badajoz (BW), intermedia e IT se muestran por separado. No se mezclan automáticamente en un total consolidado (salvo que creemos un análisis específico)

- 📅 **Período actual incluido parcialmente**: Si estamos a mitad de mes, el mes actual puede estar incompleto. Usa el filtro "Ayer" si necesitas datos confirmados sin influencia del día de hoy

- 👥 **Un trabajador ≠ un contrato**: Un mismo trabajador puede tener varias asignaciones (múltiples clientes o múltiples períodos). El indicador "Trabajadores activos" los cuenta solo una vez

- 🕐 **Cálculo de horas lineal**: Las horas se calculan multiplicando días por 8h/día. No considera festivos, vacaciones o licencias. La cifra es aproximada

- 📊 **Clientes internos excluidos**: Los clientes con "fijo" en el nombre están excluidos del análisis (son internos)

- 🔄 **Comparativas con periodicidad**: Los filtros "Último mes", "Últimos 7 días", etc., se actualizan automáticamente cada día. Son dinámicos

---

### Cómo acceder y navegar

1. **Abre el informe** desde Power BI Desktop o Power BI Service
2. **Usa los filtros de la izquierda** (período, centros, clientes)
3. **Las tarjetas grandes** muestran los KPIs principals
4. **Los gráficos de línea** te muestran evolución temporal
5. **Las tablas** te dan detalle granular si necesitas entender qué está pasando

---

### Preguntas frecuentes

**P: ¿Por qué mi cliente no aparece en el informe?**  
R: Probablemente porque no tiene asignaciones activas en el período seleccionado, o porque es un cliente interno (excluidos por defecto).

**P: ¿Cómo comparo dos períodos diferentes?**  
R: Usa filtros temporal. La columna "Crecimiento" te da automáticamente % vs. año anterior. Para mes anterior, verás "AsignacionesMA".

**P: ¿Los datos se actualizan en tiempo real?**  
R: Se actualizan con la frecuencia de refresco del servidor (típicamente diaria en la mañana). Revisa la fecha de última actualización en el informe.

**P: ¿Qué hago si falta un trabajador o un cliente?**  
R: Verifica que el período seleccionado sea correcto y que el cliente/trabajador tenga asignaciones activas en esa fecha. Contacta a RRHH si los datos parecen incorrectos en origen.

---

### Contacto y soporte

Si necesitas ayuda con el informe:
- **Problemas de acceso**: Tu administrador de BI
- **Dudas sobre datos**: Equipo de RRHH
- **Sugerencias de mejora**: Crear ticket en sistema de solicitudes

---

**Última actualización**: 30 de marzo de 2026  
**Versión del modelo**: Evolución AsignacionesMCA 2026  
**Período de datos**: 2019 - Presente
