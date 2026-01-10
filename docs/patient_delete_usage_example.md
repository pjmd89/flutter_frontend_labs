# Uso del Módulo DELETE de Patient

## Ejemplo de Invocación desde Listado

### Opción A: IconButton Inline

```dart
// En el widget de item de lista de pacientes
IconButton(
  icon: const Icon(Icons.delete),
  onPressed: () async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => PatientDeletePage(
        id: patient.id,
        patientName: '${patient.firstName} ${patient.lastName}',
      ),
    );
    
    // ✅ Recargar lista si se eliminó exitosamente
    if (result == true && context.mounted) {
      viewModel.getPatients();  // Refrescar listado
    }
  },
)
```

### Opción B: Menú Contextual

```dart
PopupMenuButton<String>(
  itemBuilder: (context) => [
    PopupMenuItem(
      value: 'edit',
      child: Row(
        children: [
          const Icon(Icons.edit),
          const SizedBox(width: 8),
          Text(l10n.edit),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'delete',
      child: Row(
        children: [
          Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: 8),
          Text(
            l10n.delete,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    ),
  ],
  onSelected: (value) async {
    if (value == 'delete') {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => PatientDeletePage(
          id: patient.id,
          patientName: '${patient.firstName} ${patient.lastName}',
        ),
      );
      
      if (result == true && context.mounted) {
        viewModel.getPatients();
      }
    } else if (value == 'edit') {
      // Navegar a página de edición
      context.push('/patients/${patient.id}/edit');
    }
  },
)
```

### Opción C: Dismissible (Swipe to Delete)

```dart
Dismissible(
  key: Key(patient.id),
  direction: DismissDirection.endToStart,
  confirmDismiss: (direction) async {
    // Mostrar diálogo de confirmación
    return await showDialog<bool>(
      context: context,
      builder: (context) => PatientDeletePage(
        id: patient.id,
        patientName: '${patient.firstName} ${patient.lastName}',
      ),
    );
  },
  background: Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    color: Theme.of(context).colorScheme.error,
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  child: ListTile(
    title: Text('${patient.firstName} ${patient.lastName}'),
    subtitle: Text(patient.dni ?? patient.email ?? ''),
  ),
  onDismissed: (direction) {
    // Ya se ejecutó el delete, solo actualizar UI
    viewModel.getPatients();
  },
)
```

## Características del Módulo DELETE

### 1. Confirmación Obligatoria
- ✅ Diálogo de confirmación con AlertDialog
- ✅ Muestra información del paciente (nombre)
- ✅ Advertencia sobre acción irreversible
- ✅ Botones diferenciados: Cancelar / Eliminar

### 2. Feedback Visual
- ✅ Loading state durante la operación
- ✅ Botón deshabilitado cuando está procesando
- ✅ Indicador de progreso con texto "Eliminando..."
- ✅ Mensaje de éxito/error usando ErrorService

### 3. Manejo Robusto de Errores
- ✅ Captura de excepciones con stackTrace
- ✅ Mensajes específicos según tipo de error:
  - Registro no encontrado
  - Tiene dependencias (foreign key)
  - Sin permisos
  - Error genérico
- ✅ debugPrint con emojis para fácil filtrado en logs

### 4. Retorno de Resultado
- ✅ Retorna `true` si eliminación fue exitosa
- ✅ Retorna `false` si hubo error
- ✅ Permite al listado refrescar datos solo si fue exitoso

## Internacionalización

El módulo usa las siguientes keys de i18n:

### Español (app_es.arb)
```json
"patient": "Paciente",
"deleteThing": "Eliminar {thing}",
"deleteQuestion": "¿Está seguro de eliminar {thing}?",
"delete": "Eliminar",
"deleting": "Eliminando...",
"cancel": "Cancelar",
"thingDeletedSuccessfully": "{thing} eliminado exitosamente",
"errorDeleting": "Error al eliminar {thing}",
"actionIsIrreversible": "Esta acción es irreversible",
"recordNotFound": "El registro no fue encontrado",
"cannotDeleteHasDependencies": "No se puede eliminar porque tiene registros relacionados",
"permissionDenied": "No tiene permisos para realizar esta acción"
```

### Inglés (app_en.arb)
```json
"patient": "Patient",
"deleteThing": "Delete {thing}",
"deleteQuestion": "Are you sure you want to delete {thing}?",
"delete": "Delete",
"deleting": "Deleting...",
"cancel": "Cancel",
"thingDeletedSuccessfully": "{thing} deleted successfully",
"errorDeleting": "Error deleting {thing}",
"actionIsIrreversible": "This action is irreversible",
"recordNotFound": "Record not found",
"cannotDeleteHasDependencies": "Cannot delete because it has related records",
"permissionDenied": "You do not have permission to perform this action"
```

## Flujo Completo

```
1. Usuario hace clic en ícono/botón eliminar
   → showDialog(PatientDeletePage(...))

2. Se abre diálogo de confirmación
   → Muestra nombre del paciente
   → Advertencia de acción irreversible

3. Usuario hace clic en "Cancelar"
   → context.pop(false)
   → No se refresca lista

4. O usuario hace clic en "Eliminar"
   → viewModel.delete(id: patient.id)
   → Muestra loading
   → Ejecuta DeletePatientMutation
   → GraphQL elimina registro

5. Resultado exitoso
   → ErrorService muestra SnackBar de éxito
   → context.pop(true)
   → Lista detecta true y se refresca

6. O resultado con error
   → ErrorService muestra SnackBar de error
   → context.pop(false) o no cierra diálogo
   → Lista no se refresca
```

## Estructura de Archivos

```
/pages/Patient/delete/
  ├── main.dart              # PatientDeletePage - Diálogo de confirmación
  └── view_model.dart        # ViewModel con método delete()

/domain/
  /operation/
    /mutations/deletePatient/
      └── deletepatient_mutation.dart    # DeletePatientMutation
  /extensions/
    └── patient_fields_builder_extension.dart  # Extension con defaultValues()
```

## Mejores Prácticas

### ✅ HACER
- Mostrar nombre del paciente en confirmación
- Usar ErrorService para feedback
- Capturar stackTrace en catch
- Usar debugPrint con emojis (🗑️ ✅ 💥 📍)
- Verificar `context.mounted` antes de `context.pop()`
- Recargar lista solo si resultado es `true`

### ❌ NO HACER
- Eliminar sin confirmación
- Hardcodear textos (usar l10n)
- Ignorar errores sin mostrar feedback
- Usar `print()` en lugar de `debugPrint()`
- Olvidar verificar `context.mounted` en callbacks async

## Ejemplo de Logs

```
🗑️ Eliminando Patient con ID: 123456
✅ Patient eliminado exitosamente

// O en caso de error:
💥 Error al eliminar Patient: NotFoundException: Patient not found
📍 StackTrace: #0 GqlConn.operation (package:agile_front/...)
```
