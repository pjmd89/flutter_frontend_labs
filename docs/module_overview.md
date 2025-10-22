# Panorama de módulos de dominio

Este documento resume los módulos que cuentan con casos de uso en `lib/src/domain/usecases`. Para cada módulo se describe su objetivo, las entidades centrales implicadas, relaciones relevantes y los principales casos de uso disponibles en el proyecto.

## Company
- **Objetivo**: Gestión de compañías propietarias de los laboratorios.
- **Entidad principal**: `Company` (`id`, `name`, `logo`, `taxID`, `owner`, `created`, `updated`).
- **Relaciones**:
  - `owner` referencia a un `User` con rol de dueño.
  - Asociada a `Laboratory` como empresa matriz.
- **Casos de uso**: `create_company`, `read_company`, `update_company`, `delete_company`.
- **Entradas típicas**: `CreateCompanyInput`, `UpdateCompanyInput` (definidas en `types/company/inputs`).
- **Resultados habituales**: `Company`, listas paginadas (`EdgeCompany` + `PageInfo`).

## EvaluationPackage
- **Objetivo**: Control de paquetes de evaluación que agrupan resultados de exámenes.
- **Entidad principal**: `EvaluationPackage` (`id`, `valuesByExam`, `status`, `pdfFilepath`, `completedAt`, `referred`, `observations`).
- **Relaciones**:
  - `valuesByExam` es una lista de `ExamResult`, cada uno enlazado a un `Exam` y sus `IndicatorValue`.
  - `status` usa el enum `ResultStatus`.
- **Casos de uso**: `create_evaluationpackage`, `read_evaluationpackage`, `update_evaluationpackage`, `delete_evaluationpackage`.
- **Entradas típicas**: `UpdateEvaluationInput` y otros modelos en `inputs/`.
- **Resultados habituales**: `EvaluationPackage`, colecciones `EdgeEvaluationPackage`.

## Exam
- **Objetivo**: Administración de exámenes clínicos ofertados.
- **Entidad principal**: `Exam` (`id`, `template`, `laboratory`, `baseCost`, `created`, `updated`).
- **Relaciones**:
  - `template` apunta a `ExamTemplate`, que define indicadores y descripción.
  - `laboratory` referencia al `Laboratory` que ejecuta el examen.
- **Casos de uso**: `create_exam`, `read_exam`, `update_exam`, `delete_exam`.
- **Entradas típicas**: `CreateExamInput`, `UpdateExamInput`, `CreateExamIndicatorInput` cuando se trabajan indicadores asociados.
- **Resultados habituales**: `Exam`, paginación vía `EdgeExam`.

## ExamIndicator
- **Objetivo**: Configurar los indicadores medibles dentro de un examen.
- **Entidad principal**: `ExamIndicator` (`name`, `valueType`, `unit`, `normalRange`).
- **Relaciones**:
  - `valueType` usa el enum `ValueType` (por ejemplo numérico, texto, booleano).
  - Se incluye dentro de `ExamTemplate` y de los resultados (`IndicatorValue`).
- **Casos de uso**: `create_examindicator`, `read_examindicator`, `update_examindicator`, `delete_examindicator`.
- **Entradas típicas**: `CreateExamIndicatorInput`.
- **Resultados habituales**: Instancias de `ExamIndicator` o colecciones integradas a plantillas/exámenes.

## ExamTemplate
- **Objetivo**: Definir plantillas reutilizables de exámenes, agrupando indicadores y metadatos.
- **Entidad principal**: `ExamTemplate` (`id`, `name`, `description`, `indicators`, `created`, `updated`).
- **Relaciones**:
  - `indicators` lista de `ExamIndicator`.
  - Puede estar asociada a múltiples `Exam` a través de `EdgeExamTemplate`.
- **Casos de uso**: `create_examtemplate`, `read_examtemplate`, `update_examtemplate`, `delete_examtemplate`.
- **Entradas típicas**: `CreateExamTemplateInput`, `UpdateExamTemplateInput`.
- **Resultados habituales**: `ExamTemplate`, colecciones `EdgeExamTemplate`.

## Invoice
- **Objetivo**: Gestionar facturas vinculadas a pacientes y paquetes de evaluación.
- **Entidad principal**: `Invoice` (`id`, `patient`, `totalAmount`, `laboratory`, `evaluationPackage`, `created`, `updated`).
- **Relaciones**:
  - `patient` -> `Patient` facturado.
  - `laboratory` -> `Laboratory` que generó el servicio.
  - `evaluationPackage` -> `EvaluationPackage` asociado.
- **Casos de uso**: `create_invoice`, `read_invoice`, `update_invoice`, `delete_invoice`.
- **Entradas típicas**: `CreateInvoiceInput`.
- **Resultados habituales**: `Invoice`, colecciones `EdgeInvoice`.

## Laboratory
- **Objetivo**: Administración de laboratorios físicos.
- **Entidad principal**: `Laboratory` (`id`, `company`, `employees`, `address`, `contactPhoneNumbers`, `created`, `updated`).
- **Relaciones**:
  - `company` -> `Company` propietaria.
  - `employees` -> `EdgeUser` listando personal vinculado.
  - Referenciado por `Exam`, `Invoice`, `Patient`.
- **Casos de uso**: `create_laboratory`, `read_laboratory`, `update_laboratory`, `delete_laboratory`.
- **Entradas típicas**: `CreateLaboratoryInput`, `UpdateLaboratoryInput`.
- **Resultados habituales**: `Laboratory`, colecciones `EdgeLaboratory`.

## Patient
- **Objetivo**: Gestión de pacientes (humanos o animales) atendidos en los laboratorios.
- **Entidad principal**: `Patient` (`id`, `firstName`, `lastName`, `sex`, `birthDate`, `species`, `dni`, `phone`, `email`, `address`, `laboratory`, `created`, `updated`).
- **Relaciones**:
  - `sex` usa el enum `Sex`.
  - `laboratory` indica el laboratorio habitual.
  - Referenciado por `Invoice` y `EvaluationPackage` a través de resultados.
- **Casos de uso**: `create_patient`, `read_patient`, `update_patient`, `delete_patient`.
- **Entradas típicas**: `CreatePatientInput`, `UpdatePatientInput`.
- **Resultados habituales**: `Patient`, colecciones `EdgePatient`.

## User
- **Objetivo**: Administración de usuarios del sistema (dueños, técnicos, facturación, etc.).
- **Entidad principal**: `User` (`id`, `firstName`, `lastName`, `role`, `email`, `cutOffDate`, `fee`, `created`, `updated`).
- **Relaciones**:
  - `role` usa el enum `Role` (owner, technician, billing, root, etc.).
  - Vínculos con `Company` (propietario) y `Laboratory` (empleados a través de `EdgeUser`).
- **Casos de uso**: `create_user`, `read_user`, `read_user_logged`, `update_user`, `delete_user`.
- **Entradas típicas**: `CreateUserInput`, `UpdateUserInput`.
- **Resultados habituales**: `User`, colecciones `EdgeUser`.

---

### Notas transversales
- Las clases `Edge*` (por ejemplo `EdgeCompany`, `EdgeExam`) modelan respuestas paginadas con `PageInfo` y listas `edges`.
- Los modelos bajo `types/*/inputs` describen la estructura esperada en las mutaciones GraphQL para crear/actualizar.
- Los enum en `enums/` establecen dominios restringidos (roles de usuario, estado de resultados, sexo, operadores de búsqueda, etc.).
- Todos los casos de uso siguen la misma plantilla de `af.UseCase`: reciben un `Operation` y un `Service` de `agile_front`, ejecutan la operación y ofrecen un `callback` para procesar la respuesta (pendiente de implementación específica).
