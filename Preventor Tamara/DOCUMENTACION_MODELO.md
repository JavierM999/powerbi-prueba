# DOCUMENTACIÓN DEL MODELO

## 1. Descripción General

Este modelo semántico de Power BI gestiona información relacionada con **cumplimiento de prevención de riesgos laborales (PRL)**, **gestión de formación continua** y **asignaciones laborales**. El modelo integra datos de trabajadores, contratos, cursos de formación, evaluaciones de riesgos y validaciones de caducidad de certificaciones.

El propósito principal es proporcionar visibilidad sobre:
- Trabajadores activos y sus asignaciones
- Cumplimiento de formación y validaciones de competencias
- Estado de contratos y altas laborales
- Evaluaciones de riesgos laborales

---

## 2. Estructura de Tablas

### Tablas de Hechos

#### **Contratos** (Principal)
Tabla transaccional que registra asignaciones y altas de trabajadores.

**Campos principales:**
- `CodContrato` (Clave primaria): Identificador único del contrato
- `CodTrabajador`: Vínculo con trabajador
- `FechaAlta`: Fecha de inicio de la asignación
- `FechaBaja`: Fecha de fin (si aplica)
- `TipoContrato`: Categorización del contrato
- `CodCentro`: Centro de trabajo asociado
- `TipoNovacion`: Tipo de cambio en el contrato

**Medidas principales:**
- `Contratos Activos`: Contratos vigentes en el período seleccionado
- `Altas Período`: Nuevos contratos en el período
- `Contratos Vigentes`: Contratos activos al cierre

---

#### **CursoXTrab** (Hechos de Formación)
Tabla que vincula trabajadores con cursos completados y su estado de validación.

**Campos principales:**
- `IdCursoXTrab` (Clave primaria): Identificador de la relación curso-trabajador
- `CodTrabajador`: Trabajador que realizó el curso
- `CodCurso`: Curso realizado
- `FechaRealizacion`: Fecha de finalización del curso
- `FechaCaducidad`: Fecha de vencimiento de la competencia
- `Estado`: Validación del curso (aprobado, pendiente, caducado)
- `CodCentro`: Centro donde se realizó

**Medidas principales:**
- `Cursos Realizados`: Total de cursos completados
- `Cursos Válidos`: Cursos cuya validez no ha expirado
- `Cursos Caducados`: Cursos que han perdido vigencia
- `% Cumplimiento Cursos`: Porcentaje de trabajadores con cursos válidos
- `Cursos Aplicables Resumen`: Detalle consolidado de cursos activos por trabajador

---

### Tablas de Dimensiones

#### **Trabajador**
Dimensión de personas.

**Campos:**
- `CodTrabajador` (Clave primaria)
- `Nombre`: Nombre completo
- `NIF`: Número de identificación fiscal
- `Nacionalidad`: País de origen
- `TipoIdentificacion`: Tipo de documento

---

#### **Cursos**
Catálogo de cursos y formación disponible.

**Campos:**
- `CodCurso` (Clave primaria)
- `Nombre`: Nombre descriptivo del curso
- `Caducidad`: Años de validez del certificado
- `Tipo`: Categoría del curso (PRL, Seguridad, Técnico, etc.)
- `Descripción`: Detalles adicionales

---

#### **Calendario**
Dimensión temporal para análisis históricos.

**Campos:**
- `Fecha` (Clave primaria)
- `Año`, `Mes`, `Día`
- `NombreMes`, `NombreDia`
- `Trimestre`: Agrupación trimestral
- `Semana`: Número de semana ISO
- **Jerarquía:** Año → Trimestre → Mes → Día

---

#### **Centros (MCANCentros)**
Ubicaciones físicas de trabajo.

**Campos:**
- `CodCentro` (Clave primaria)
- `Nombre`: Nombre del centro
- `Provincia`, `Ciudad`

---

#### **Clientes**
Información de clientes o sedes organizacionales.

**Campos:**
- `CodCliente` (Clave primaria)
- `Nombre`, `Contacto`, `Email`

---

#### **Categorías**
Clasificación de trabajadores o tipos de personal.

**Campos:**
- `CodCategoria` (Clave primaria)
- `Descripción`

---

#### **FormPRL**
Evaluaciones y formularios de prevención de riesgos.

**Campos:**
- `IdFormPRL` (Clave primaria)
- `CodTrabajador`, `CodCentro`
- `FechaEvaluacion`: Fecha de la evaluación de riesgos
- `Resultado`: Valoración del riesgo (bajo, medio, alto)
- `Recomendaciones`: Acciones derivadas

---

#### **ContFirmados**
Contratos con validación de firma digital (auditoría).

**Campos:**
- `CodContrato` (Clave primaria)
- `FechaFirma`: Fecha de formalización
- `Firmado`: Indicador de firma (Sí/No)
- `Responsable`: Persona que firmó

---

## 3. Relaciones Principales

```
Trabajador
    ↓
Contratos ← CodTrabajador
    ↓
CursoXTrab ← CodTrabajador
    ↓
Cursos ← CodCurso

Contratos
    ↓
Centros ← CodCentro

Contratos
    ↓
ContFirmados ← CodContrato

CursoXTrab
    ↓
Calendario ← FechaCaducidad
```

**Cardinalidad:**
- Trabajador → Contratos: 1:N (un trabajador puede tener múltiples contratos)
- Contratos → CursoXTrab: 1:N (un contrato puede asociarse a múltiples cursos)
- Cursos ← CursoXTrab: 1:N (un curso se asigna a múltiples trabajadores)
- Centros ← Contratos: 1:N

---

## 4. Lógica de Negocio

### Validaciones de Cumplimiento
El modelo incluye lógica compleja para:
1. **Validación de PRL**: Verifica que trabajadores tengan formación PRL activa
2. **Cálculo de Caducidad**: Estima automáticamente cuándo expira la competencia (basado en años de validez del curso)
3. **Estado de Contratos**: Diferencia entre altas, bajas y vigentes en el período analizado

### Cálculos Principales
- **Contratos Activos** = Contratos donde FechaAlta ≤ período Y (FechaBaja es vacío O FechaBaja > período)
- **Cursos Válidos** = CursoXTrab donde FechaCaducidad > fecha actual
- **% Cumplimiento** = DIVIDE(Cursos Válidos, Total Trabajadores)
- **Cursos Aplicables Resumen** = Consolidación textual de cursos activos por trabajador (formato legible)

---

## 5. Áreas de Análisis

### 📊 Gestión de Personal
- Trabajadores activos por centro y período
- Historial de altas y bajas
- Rotación y permanencia

### 🎓 Cumplimiento de Formación
- Porcentaje de trabajadores con cursos válidos
- Identificación de competencias próximas a caducar
- Seguimiento de cursos obligatorios vs. opcionales

### ⚠️ Prevención de Riesgos Laborales (PRL)
- Evaluaciones de riesgos por centro y trabajador
- Recomendaciones derivadas y su seguimiento
- Trabajadores sin evaluación PRL actualizada

### 📋 Auditoría y Control
- Contratos con firma digital validada
- Trazabilidad de cambios (novaciones)
- Responsables de autorización

---

## 6. Notas Técnicas

- **Periodo de Análisis:** Controlado mediante filtros de Calendario (filtro por mes/año disponible)
- **Estructura Temporal:** Jerarquía año-trimestre-mes permite análisis de tendencias
- **Expresiones DAX Complejas:** Usa TREATAS, CALCULATETABLE y CONCATENATEX para validaciones cruzadas
- **Filtros Cruzados:** Las dimensiones se relacionan bidireccionalmente con las tablas de hechos para análisis dinámicos

