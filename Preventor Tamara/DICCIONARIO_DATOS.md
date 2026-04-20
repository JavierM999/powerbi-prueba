# DICCIONARIO DE DATOS

## Descripción de Tablas Principales

---

## 1. TRABAJADOR
**Tipo:** Dimensión  
**Descripción:** Registro de personas empleadas en la organización.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `CodTrabajador` | Texto (Clave) | Identificador único del trabajador |
| `Nombre` | Texto | Nombre completo |
| `NIF` | Texto | Número de Identificación Fiscal |
| `Nacionalidad` | Texto | País de origen o residencia |
| `TipoIdentificacion` | Texto | Tipo de documento (DNI, NIE, Pasaporte, etc.) |

---

## 2. CONTRATOS
**Tipo:** Tabla de Hechos (Principal)  
**Descripción:** Registra asignaciones laborales y cambios en estado contractual.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `CodContrato` | Texto (Clave) | Identificador único del contrato |
| `CodTrabajador` | Texto | Vínculo con tabla Trabajador |
| `FechaAlta` | Fecha | Fecha de inicio de la asignación |
| `FechaBaja` | Fecha | Fecha de finalización (vacío si activo) |
| `TipoContrato` | Texto | Categoría (indefinido, temporal, prácticas) |
| `CodCentro` | Texto | Centro de trabajo asociado |
| `CodCliente` | Texto | Cliente o sede organizacional |
| `CodCategoria` | Texto | Categoría de trabajador |
| `TipoNovacion` | Texto | Tipo de cambio (promoción, cambio centro, etc.) |

**Medidas Principales:**

| Medida | Fórmula Conceptual | Uso |
|--------|-------------------|-----|
| `Contratos Activos` | Contratos vigentes en período seleccionado | KPI de cobertura de personal |
| `Altas Período` | Nuevos contratos en período actual | Indicador de crecimiento |
| `Contratos Vigentes` | Contratos activos al cierre del período | Base para análisis de cumplimiento |

---

## 3. CURSOXTRA B
**Tipo:** Tabla de Hechos (Secundaria)  
**Descripción:** Registro de formación completada por trabajadores y su validez.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `IdCursoXTrab` | Número (Clave) | Identificador único de la relación |
| `CodTrabajador` | Texto | Trabajador que realizó el curso |
| `CodCurso` | Texto | Curso completado |
| `FechaRealizacion` | Fecha | Fecha de finalización del curso |
| `FechaCaducidad` | Fecha | Fecha en que expira la validez |
| `Estado` | Texto | Validación (Válido, Caducado, Pendiente) |
| `CodCentro` | Texto | Centro donde se realizó |
| `Calificacion` | Número | Puntuación obtenida (0-100) |

**Medidas Principales:**

| Medida | Descripción |
|--------|-------------|
| `Cursos Realizados` | Total de formaciones completadas |
| `Cursos Válidos` | Formaciones cuya validez no ha expirado |
| `Cursos Caducados` | Formaciones vencidas |
| `% Cumplimiento Cursos` | Porcentaje de trabajadores con competencias válidas |
| `Cursos Aplicables Resumen` | Consolidado legible de cursos activos por trabajador |

---

## 4. CURSOS
**Tipo:** Dimensión  
**Descripción:** Catálogo de formación disponible.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `CodCurso` | Texto (Clave) | Identificador del curso |
| `Nombre` | Texto | Denominación del curso |
| `Caducidad` | Número | Años de validez del certificado |
| `Tipo` | Texto | Categoría (PRL, Seguridad, Técnico, Administrativo) |
| `Descripcion` | Texto | Detalles y contenido resumido |
| `Obligatorio` | Lógico | Si es requerido para ciertos puestos |
| `Duracion` | Número | Horas lectivas |

---

## 5. FORMPRL
**Tipo:** Tabla de Hechos (Auditoría)  
**Descripción:** Evaluaciones de prevención de riesgos laborales.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `IdFormPRL` | Número (Clave) | Identificador del formulario |
| `CodTrabajador` | Texto | Trabajador evaluado |
| `CodCentro` | Texto | Centro donde se realizó la evaluación |
| `FechaEvaluacion` | Fecha | Fecha de realización |
| `Resultado` | Texto | Nivel de riesgo (Bajo, Medio, Alto, Crítico) |
| `Recomendaciones` | Texto | Acciones sugeridas |
| `EvaluadorResponsable` | Texto | Profesional que realizó la evaluación |

---

## 6. CALENDARIO
**Tipo:** Dimensión Temporal  
**Descripción:** Tabla para análisis históricos y tendencias.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `Fecha` | Fecha (Clave) | Fecha completa |
| `Año` | Número | Año calendario |
| `Mes` | Número | Mes (1-12) |
| `Día` | Número | Día del mes |
| `NombreMes` | Texto | Denominación (enero, febrero, etc.) |
| `NombreDia` | Texto | Día de la semana (lunes, martes, etc.) |
| `Trimestre` | Texto | Trimestre (Q1, Q2, Q3, Q4) |
| `Semana` | Número | Semana ISO del año |

**Jerarquía Disponible:** Año → Trimestre → Mes → Día

---

## 7. CENTROS (MCANCentros)
**Tipo:** Dimensión  
**Descripción:** Ubicaciones físicas de trabajo.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `CodCentro` | Texto (Clave) | Código del centro |
| `Nombre` | Texto | Nombre de la ubicación |
| `Provincia` | Texto | Provincia o región |
| `Ciudad` | Texto | Municipio |
| `Direccion` | Texto | Dirección física |

---

## 8. CATEGORÍAS
**Tipo:** Dimensión  
**Descripción:** Clasificación de trabajadores.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `CodCategoria` | Texto (Clave) | Código de categoría |
| `Descripcion` | Texto | Denominación (Encargado, Técnico, Administrativo, etc.) |

---

## 9. CLIENTES
**Tipo:** Dimensión  
**Descripción:** Información de clientes o sedes organizacionales.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `CodCliente` | Texto (Clave) | Identificador de cliente |
| `Nombre` | Texto | Razón social |
| `Contacto` | Texto | Persona de contacto |
| `Email` | Texto | Correo de contacto |
| `Telefono` | Texto | Teléfono principal |

---

## 10. CONTFIRMADOS
**Tipo:** Tabla de Control (Auditoría)  
**Descripción:** Validación de contratos con firma digital.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `CodContrato` | Texto (Clave) | Referencia al contrato |
| `FechaFirma` | Fecha | Fecha de formalización |
| `Firmado` | Lógico | Estado de firma (Sí/No) |
| `Responsable` | Texto | Persona que autorizó |
| `NumeroFirma` | Texto | Identificador de firma digital |

---

## GLOSARIO DE TÉRMINOS DE NEGOCIO

### **Asignación**
Vinculación laboral de un trabajador a un centro o proyecto específico mediante un contrato.

### **Altas**
Nuevas asignaciones o cambios de estado de un trabajador al pasar de inactivo a activo.

### **Bajas**
Finalización de una asignación laboral o cambio a estado de inactividad.

### **Caducidad**
Fecha en la que una certificación o competencia pierde validez oficial.

### **Centro**
Ubicación física donde se desarrolla la actividad laboral.

### **Contrato**
Documento legal que formaliza una relación laboral entre empresa y trabajador.

### **Cumplimiento**
Satisfacción de requisitos normativos, principalmente en prevención de riesgos laborales (PRL).

### **Cursos**
Programas de formación que capacitan a trabajadores en competencias específicas.

### **Evaluación de Riesgos**
Proceso de identificación de peligros y valoración de su nivel de riesgo en ambiente laboral.

### **Formación PRL**
Capacitación específica en Prevención de Riesgos Laborales requerida por normativa.

### **Medida**
Cálculo o indicador derivado de datos transaccionales (ejemplo: "Contratos Activos").

### **Novación**
Cambio o modificación en los términos de un contrato existente (centro, categoría, etc.).

### **Responsable**
Persona autorizada que valida, autoriza o realiza una acción en el sistema.

### **Validez**
Período durante el cual una formación, certificación o documento tiene vigencia legal.

---

## RELACIÓN ENTRE TABLAS

```
Trabajador (1) ──→ (N) Contratos
Trabajador (1) ──→ (N) CursoXTrab
Trabajador (1) ──→ (N) FormPRL

Contratos (1) ──→ (N) CursoXTrab
Contratos (1) ──→ (1) ContFirmados

Cursos (1) ──→ (N) CursoXTrab

Centros (1) ──→ (N) Contratos
Centros (1) ──→ (N) CursoXTrab
Centros (1) ──→ (N) FormPRL

Clientes (1) ──→ (N) Contratos

Categorías (1) ──→ (N) Contratos

Calendario (1) ──→ (N) CursoXTrab (por FechaCaducidad)
```

---

## NOTAS TÉCNICAS

- **Filtros Dinámicos:** Use los filtros de Trabajador, Centro y Calendario para análisis específicos
- **Integridad Referencial:** Las claves foráneas se validan automáticamente
- **Cálculos Complejos:** Algunas medidas usan TREATAS y CALCULATETABLE para validaciones cruzadas
- **Actualización:** Los datos se sincronizaban según el ciclo operacional de la organización

