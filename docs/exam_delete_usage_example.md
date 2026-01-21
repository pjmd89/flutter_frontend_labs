# Ejemplo de Uso: Exam Delete

Este documento muestra cómo usar el módulo de eliminación de exámenes (ExamDeletePage) desde diferentes partes de la aplicación.

## ✅ Implementación Completada

Se ha implementado el módulo DELETE completo para Exam siguiendo el patrón establecido:

### Archivos Actualizados

1. **`/lib/src/presentation/pages/Exam/delete/main.dart`**
   - Diálogo de confirmación con AlertDialog
   - Muestra warning icon y mensaje personalizado
   - Advertencia sobre acción irreversible
   - Botones Cancelar/Eliminar con estados de loading
   - Retorna `true` si eliminación exitosa, `false` si se cancela

2. **`/lib/src/presentation/pages/Exam/delete/view_model.dart`**
   - Método `delete({required String id})` que retorna `Future<bool>`
   - Manejo completo de errores con try-catch-finally
   - Mensajes específicos según tipo de error
   - Feedback visual con ErrorService (success/error)
   - Debug prints con emojis para tracking

### Dependencias Verificadas ✅

- ✅ `DeleteExamMutation` en `/domain/operation/mutations/deleteExam/`
- ✅ `DeleteExamUsecase` en `/domain/usecases/Exam/`
- ✅ `ExamFieldsBuilderExtension` con `defaultValues()`
- ✅ Todas las claves i18n necesarias

## Cómo Invocar el Delete

### Opción 1: Desde un IconButton (Recomendado)

```dart
import 'package:flutter/material.dart';
import '/src/presentation/pages/Exam/delete/main.dart';

// En tu widget de item de lista o card
IconButton(
  icon: const Icon(Icons.delete),
  tooltip: l10n.delete,
  onPressed: () async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ExamDeletePage(
        id: exam.id,
        examName: exam.template?.name, // Opcional: para mensaje personalizado
      ),
    );
    
    // ✅ Recargar lista si se eliminó exitosamente
    if (result == true && context.mounted) {
      viewModel.getExams(); // O el método que uses para recargar
    }
  },
)
```

### Opción 2: Desde un PopupMenuButton

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
          const Icon(Icons.delete),
          const SizedBox(width: 8),
          Text(l10n.delete),
        ],
      ),
    ),
  ],
  onSelected: (value) async {
    if (value == 'delete') {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => ExamDeletePage(
          id: exam.id,
          examName: exam.template?.name,
        ),
      );
      
      if (result == true && context.mounted) {
        viewModel.getExams();
      }
    } else if (value == 'edit') {
      // Navegar a edición
    }
  },
)
```

### Opción 3: Desde un ListTile onLongPress

```dart
ListTile(
  title: Text(exam.template?.name ?? 'Sin nombre'),
  subtitle: Text('Costo: \$${exam.baseCost}'),
  onTap: () {
    // Navegar a detalles
  },
  onLongPress: () async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ExamDeletePage(
        id: exam.id,
        examName: exam.template?.name,
      ),
    );
    
    if (result == true && context.mounted) {
      viewModel.getExams();
    }
  },
)
```

### Opción 4: Con GoRouter (Navegación)

```dart
// En la configuración de rutas (router.dart)
GoRoute(
  path: '/exams/:id/delete',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    final examName = state.uri.queryParameters['name'];
    
    return ExamDeletePage(
      id: id,
      examName: examName,
    );
  },
),

// Uso
context.push('/exams/${exam.id}/delete?name=${exam.template?.name}');
```

## Parámetros

### Obligatorios

- **`id`** (String): ID del examen a eliminar

### Opcionales

- **`examName`** (String?): Nombre del examen para personalizar el mensaje
  - Si se proporciona: "¿Está seguro de eliminar Hemograma Completo?"
  - Si NO se proporciona: "¿Está seguro de eliminar Examen?"

## Flujo de Ejecución

1. Usuario hace clic en botón/ícono eliminar
2. Se abre diálogo de confirmación (AlertDialog)
3. Usuario ve:
   - Ícono de advertencia
   - Título: "Eliminar Examen"
   - Pregunta: "¿Está seguro de eliminar [nombre]?"
   - Advertencia: "Esta acción es irreversible"
   - Botones: Cancelar / Eliminar
4. Usuario hace clic en "Cancelar":
   - Diálogo se cierra
   - Retorna `false`
   - No se recarga la lista
5. Usuario hace clic en "Eliminar":
   - Botón muestra loading (CircularProgressIndicator)
   - Se ejecuta mutation GraphQL
   - Si éxito:
     - Muestra SnackBar verde: "Examen eliminado exitosamente"
     - Diálogo se cierra
     - Retorna `true`
     - Lista se recarga automáticamente
   - Si error:
     - Muestra SnackBar rojo con mensaje específico
     - Diálogo permanece abierto
     - Usuario puede reintentar o cancelar

## Manejo de Errores

El ViewModel maneja automáticamente los siguientes errores:

### Registro No Encontrado
```
Mensaje: "El registro no fue encontrado"
```

### Tiene Dependencias (Foreign Key)
```
Mensaje: "No se puede eliminar porque tiene registros relacionados"
```

### Sin Permisos
```
Mensaje: "No tiene permisos para realizar esta acción"
```

### Error Genérico
```
Mensaje: "Error al eliminar Examen"
```

## Ejemplo Completo en Context

```dart
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import '/src/domain/entities/main.dart';
import '/src/presentation/pages/Exam/delete/main.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback onDeleted;

  const ExamCard({
    super.key,
    required this.exam,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: ListTile(
        title: Text(exam.template?.name ?? l10n.noName),
        subtitle: Text('${l10n.baseCost}: \$${exam.baseCost}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          tooltip: l10n.delete,
          onPressed: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (context) => ExamDeletePage(
                id: exam.id,
                examName: exam.template?.name,
              ),
            );

            if (result == true) {
              onDeleted(); // Callback para recargar lista
            }
          },
        ),
      ),
    );
  }
}
```

## Verificación de Implementación ✅

- [x] ExamDeletePage con parámetros `id` (obligatorio) y `examName` (opcional)
- [x] AlertDialog con icon, title, content, actions
- [x] Usa l10n para todos los textos
- [x] ViewModel con método `delete({required String id})`
- [x] Manejo de errores con try-catch-finally y stackTrace
- [x] ErrorService para feedback visual
- [x] debugPrint con emojis (🗑️, ✅, 💥, 📍)
- [x] Loading state durante operación
- [x] Retorna bool (true = éxito, false = error/cancelado)
- [x] Verifica context.mounted antes de pop
- [x] DeleteExamMutation configurada correctamente
- [x] ExamFieldsBuilder().defaultValues() usado
- [x] Sin errores de compilación

## Notas Importantes

1. **Siempre capturar el resultado del diálogo** para saber si se debe recargar la lista
2. **Verificar context.mounted** antes de usar context en callbacks async
3. **Pasar examName** para mejor UX (mensaje personalizado)
4. **No hardcodear textos** - usar siempre l10n
5. **El diálogo es responsable de mostrar feedback** - no necesitas mostrar SnackBar adicional

## Características Implementadas

- ✅ Confirmación obligatoria antes de eliminar
- ✅ Información contextual (nombre del examen si se proporciona)
- ✅ Feedback visual claro (SnackBar success/error)
- ✅ Manejo robusto de errores con mensajes específicos
- ✅ Loading state durante operación
- ✅ Botones diferenciados (Cancelar/Eliminar)
- ✅ Advertencia sobre acción irreversible
- ✅ Multiidioma completo (i18n)
- ✅ Refresh automático del listado tras eliminación exitosa
- ✅ Debug tracking con emojis para desarrollo

## Próximos Pasos (Opcional)

Si necesitas funcionalidad adicional, considera:

1. **Soft Delete**: Usar UpdateExamMutation para marcar como inactivo en lugar de eliminar
2. **Verificación de Dependencias**: Implementar check previo antes de eliminar
3. **Cascade Delete**: Mostrar advertencia y lista de registros relacionados que se eliminarán
4. **Restore Functionality**: Si usas soft delete, implementar página para restaurar
5. **Bulk Delete**: Eliminar múltiples exámenes a la vez
