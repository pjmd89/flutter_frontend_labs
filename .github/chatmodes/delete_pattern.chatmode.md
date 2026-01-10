````chatagent
# Patrón de Arquitectura Modular Flutter - DELETE (Eliminación con Confirmación)

Este chatmode documenta el patrón completo para implementar módulos de **eliminación** con confirmación en Flutter usando agile_front framework y GraphQL.

**Alcance:** Operación DELETE  
**Otros patrones:** CREATE, READ, UPDATE se documentan en chatmodes separados

## Principios Fundamentales

### 1. Separación de Responsabilidades
Cada archivo tiene una única responsabilidad clara:
- El archivo principal (`main.dart`) orquesta el diálogo de confirmación
- La lógica de negocio está en el `view_model.dart`
- La mutation GraphQL maneja la operación de eliminación

### 2. Nombres Genéricos y Reutilizables
Usa nombres estándar para facilitar la clonación de módulos y mantener consistencia.

### 3. Confirmación Obligatoria
La eliminación SIEMPRE requiere confirmación explícita del usuario:
- Diálogo de confirmación con pregunta clara
- Muestra información del registro a eliminar
- Botones diferenciados (Cancelar/Eliminar)
- Loading state durante la operación
- Feedback visual al completar

### 4. Consideraciones Clave DELETE
- ✅ **Confirmación obligatoria** - Nunca eliminar sin confirmación
- ✅ **Información contextual** - Mostrar datos del registro (nombre, ID, etc.)
- ✅ **Mensaje claro** - Usar `l10n.deleteQuestion(l10n.{feature})`
- ✅ **Botón destructivo** - Usar color de advertencia para el botón eliminar
- ✅ **Soft delete vs Hard delete** - Considerar eliminación lógica
- ✅ **Manejo de dependencias** - Validar relaciones antes de eliminar
- ✅ **Acción irreversible** - Advertir claramente sobre la permanencia

## Estructura de Archivos para DELETE

```
/pages/{Feature}/delete/
  ├── main.dart              # Diálogo de confirmación - 40-60 líneas
  └── view_model.dart        # Lógica de negocio con GraphQL mutation

/domain/
  /usecases/{Feature}/
    └── delete_{feature}_usecase.dart      # UseCase con execute()
  /operation/
    /mutations/delete{Feature}/
      └── delete{feature}_mutation.dart    # Mutation GraphQL
  /extensions/
    └── {feature}_fields_builder_extension.dart  # Extension con defaultValues()
```

### Ejemplo Real: Módulo User/delete

**Presentación:**
```
/pages/User/delete/
  ├── main.dart              # UserDeletePage con diálogo de confirmación
  └── view_model.dart        # ViewModel con delete()
```

**Dominio:**
```
/domain/
  /usecases/User/
    └── delete_user_usecase.dart           # DeleteUserUsecase
  /operation/
    /mutations/deleteUser/
      └── deleteuser_mutation.dart         # DeleteUserMutation
  /extensions/
    └── user_fields_builder_extension.dart # Extension con defaultValues()
```

## Análisis del Delete: Parámetros Requeridos

### Parámetro Mínimo: ID
La operación DELETE típicamente solo requiere el ID del registro:

```dart
class UserDeletePage extends StatefulWidget {
  const UserDeletePage({
    super.key,
    required this.id,           // ✅ ID obligatorio
    this.userName,              // ⚠️ Opcional: para mostrar en confirmación
  });
  
  final String id;
  final String? userName;      // Mostrar "¿Eliminar a Juan Pérez?"
}
```

### Opciones de Información Contextual

**Opción A: Solo ID (mínimo)**
```dart
UserDeletePage(id: user.id)
```
- Ventaja: Más simple
- Desventaja: Mensaje genérico "¿Eliminar este registro?"

**Opción B: ID + Nombre (recomendado)**
```dart
UserDeletePage(
  id: user.id,
  userName: user.fullName,
)
```
- Ventaja: Mensaje personalizado "¿Eliminar a Juan Pérez?"
- Recomendado para mejor UX

**Opción C: Objeto Completo**
```dart
UserDeletePage(user: user)
```
- Ventaja: Acceso a todos los datos para mostrar información detallada
- Usar cuando necesitas mostrar múltiples campos

## Convención de Nombres para DELETE

### Archivos y Directorios
```
/pages/{Feature}/delete/
  main.dart           # {Feature}DeletePage
  view_model.dart     # ViewModel
```

### Clases y Métodos
```dart
// Presentación
class UserDeletePage extends StatefulWidget
class _UserDeletePageState extends State<UserDeletePage>
class ViewModel extends ChangeNotifier

// Dominio
class DeleteUserMutation implements Operation
class DeleteUserUsecase
```

### Nombres Consistentes
- Página: `{Feature}DeletePage`
- ViewModel: `ViewModel` (genérico, no `UserDeleteViewModel`)
- Mutation: `Delete{Feature}Mutation`
- UseCase: `Delete{Feature}Usecase`
- Método: `delete()` (en ViewModel y UseCase)

## Implementación del Diálogo de Confirmación

### Estructura Básica

```dart
import 'package:flutter/material.dart';
import 'package:agile_front/agile_front.dart';
import '/l10n/app_localizations.dart';
import './view_model.dart';

class UserDeletePage extends StatefulWidget {
  const UserDeletePage({
    super.key,
    required this.id,
    this.userName,
  });
  
  final String id;
  final String? userName;

  @override
  State<UserDeletePage> createState() => _UserDeletePageState();
}

class _UserDeletePageState extends State<UserDeletePage> {
  late ViewModel viewModel;
  late AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
    l10n = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return AlertDialog(
          icon: Icon(
            Icons.warning,
            // Color definido en theme para warnings
          ),
          title: Text(l10n.deleteThing(l10n.user)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pregunta de confirmación
              Text(
                widget.userName != null
                  ? l10n.deleteQuestion(widget.userName!)
                  : l10n.deleteQuestion(l10n.user),
                // Estilo definido en theme
              ),
              
              // Advertencia sobre acción irreversible
              Text(
                l10n.actionIsIrreversible,
                // Estilo definido en theme
              ),
            ],
          ),
          actions: [
            // Botón Cancelar
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(l10n.cancel),
            ),
            
            // Botón Eliminar (destructivo)
            FilledButton(
              onPressed: viewModel.loading ? null : () async {
                bool success = await viewModel.delete(id: widget.id);
                
                if (success && context.mounted) {
                  context.pop(true);  // ✅ Retornar true para recargar lista
                }
              },
              // Estilo destructivo definido en theme
              child: viewModel.loading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),  // Tamaño definido en theme
                      Text(l10n.deleting),
                    ],
                  )
                : Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}
```

### Variante con Información Detallada

```dart
content: Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      l10n.deleteQuestion(widget.userName ?? l10n.user),
      style: Theme.of(context).textTheme.titleMedium,
    ),
    
    // Información del registro
    Card(
      // Color y padding definidos en theme
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.userName != null) ...[
            Text('${l10n.name}: ${widget.userName}'),
          ],
          Text('${l10n.id}: ${widget.id}'),
        ],
      ),
    ),
    
    // Advertencia
    Row(
      children: [
        Icon(Icons.warning_amber, size: Theme.of(context).iconTheme.size),
        Expanded(
          child: Text(
            l10n.actionIsIrreversible,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    ),
  ],
),
```

## Implementación del ViewModel

### Estructura Básica

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agile_front/agile_front.dart';
import '/l10n/app_localizations.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/error_service.dart';
import '/src/domain/usecases/User/delete_user_usecase.dart';
import '/src/domain/operation/mutations/deleteUser/deleteuser_mutation.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/extensions/user_fields_builder_extension.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = false;
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  late AppLocalizations l10n;

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    l10n = AppLocalizations.of(context)!;
  }

  /// Elimina un usuario por ID
  /// Retorna true si fue exitoso, false si hubo error
  Future<bool> delete({required String id}) async {
    loading = true;
    bool success = false;

    try {
      // Crear mutation con ID como argumento
      final mutation = DeleteUserMutation(
        builder: UserFieldsBuilder().defaultValues(),
        declarativeArgs: {"_id": "String!"},
        opArgs: {"_id": GqlVar("_id")},
      );

      // Crear UseCase
      final useCase = DeleteUserUsecase(
        operation: mutation,
        conn: _gqlConn,
      );

      debugPrint('🗑️ Eliminando User con ID: $id');

      // Ejecutar operación
      await _gqlConn.operation(
        operation: mutation,
        variables: {"_id": id},
      );

      success = true;
      
      _errorService.showError(
        message: l10n.thingDeletedSuccessfully(l10n.user),
        type: ErrorType.success,
      );

      debugPrint('✅ User eliminado exitosamente');
    } catch (e, stackTrace) {
      debugPrint('💥 Error al eliminar User: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      
      success = false;
      
      // Manejo de errores específicos
      String errorMessage = l10n.errorDeleting(l10n.user);
      
      if (e.toString().contains('not found') || e.toString().contains('NotFoundException')) {
        errorMessage = l10n.recordNotFound;
      } else if (e.toString().contains('foreign key') || e.toString().contains('has dependencies')) {
        errorMessage = l10n.cannotDeleteHasDependencies;
      } else if (e.toString().contains('permission') || e.toString().contains('PermissionException')) {
        errorMessage = l10n.permissionDenied;
      }
      
      _errorService.showError(
        message: errorMessage,
        type: ErrorType.error,
      );
    } finally {
      loading = false;
    }

    return success;
  }
}
```

### Variante con Soft Delete

```dart
/// Soft delete: marca como inactivo en lugar de eliminar
Future<bool> softDelete({required String id}) async {
  loading = true;
  bool success = false;

  try {
    // Usar UpdateUserMutation para cambiar estado
    final mutation = UpdateUserMutation(
      builder: UserFieldsBuilder().defaultValues(),
      declarativeArgs: {"input": "UpdateUserInput!"},
      opArgs: {"input": GqlVar("input")},
    );

    final input = UpdateUserInput(
      id: id,
      isActive: false,       // ✅ Marcar como inactivo
      deletedAt: DateTime.now(),  // ⚠️ Si existe este campo
    );

    await _gqlConn.operation(
      operation: mutation,
      variables: {"input": input.toJson()},
    );

    success = true;
    
    _errorService.showError(
      message: l10n.thingDeletedSuccessfully(l10n.user),
      type: ErrorType.success,
    );

  } catch (e, stackTrace) {
    debugPrint('💥 Error en soft delete: $e');
    debugPrint('📍 StackTrace: $stackTrace');
    success = false;
    
    _errorService.showError(
      message: l10n.errorDeleting(l10n.user),
      type: ErrorType.error,
    );
  } finally {
    loading = false;
  }

  return success;
}
```

## Tipos de Eliminación

### 1. Hard Delete (Eliminación Física)

**Características:**
- Elimina permanentemente el registro de la base de datos
- Irreversible
- Requiere confirmación explícita
- Usar cuando no hay dependencias

**Cuándo usar:**
- Registros de prueba
- Datos temporales
- Sin relaciones con otros registros
- Cumplimiento normativo (GDPR - derecho al olvido)

**Implementación:**
```dart
// Mutation GraphQL
mutation deleteUser($_id: String!) {
  deleteUser(_id: $_id) {
    _id
    firstName
    lastName
  }
}
```

### 2. Soft Delete (Eliminación Lógica)

**Características:**
- Marca el registro como inactivo/eliminado
- Reversible
- Mantiene integridad referencial
- Histórico de datos

**Cuándo usar:**
- Registros con dependencias
- Auditoría requerida
- Posibilidad de restauración
- Reportes históricos

**Campos comunes:**
```dart
class User {
  bool isActive;          // false = eliminado
  DateTime? deletedAt;    // Fecha de eliminación
  String? deletedBy;      // Usuario que eliminó
}
```

**Implementación:**
```dart
// Usar UpdateMutation en lugar de DeleteMutation
final input = UpdateUserInput(
  id: id,
  isActive: false,
  deletedAt: DateTime.now(),
);
```

### 3. Cascade Delete (Eliminación en Cascada)

**Características:**
- Elimina registro y sus dependencias
- Requiere confirmación explícita de cascada
- Mostrar lista de registros afectados

**Implementación con advertencia:**
```dart
content: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(l10n.deleteQuestion(widget.userName!)),
    
    // Advertencia de cascada
    Card(
      // Estilo definido en theme para warnings
      child: Column(
        children: [
          Text(
            l10n.cascadeDeleteWarning,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text('${l10n.patients}: ${widget.dependentPatientsCount}'),
          Text('${l10n.exams}: ${widget.dependentExamsCount}'),
        ],
      ),
    ),
    
    // Checkbox de confirmación adicional
    CheckboxListTile(
      title: Text(l10n.confirmCascadeDelete),
      value: _confirmCascade,
      onChanged: (value) {
        setState(() => _confirmCascade = value ?? false);
      },
    ),
  ],
),
```

## Manejo de Errores Específicos DELETE

### Errores Comunes

```dart
try {
  await viewModel.delete(id: widget.id);
} catch (e, stackTrace) {
  debugPrint('💥 Error al eliminar: $e');
  debugPrint('📍 StackTrace: $stackTrace');
  
  String errorMessage;
  
  // 1. Registro no encontrado
  if (e.toString().contains('not found') || e is NotFoundException) {
    errorMessage = l10n.recordNotFound;
  }
  
  // 2. Tiene dependencias (foreign key constraint)
  else if (e.toString().contains('foreign key') || 
           e.toString().contains('has dependencies') ||
           e.toString().contains('FOREIGN KEY constraint')) {
    errorMessage = l10n.cannotDeleteHasDependencies;
  }
  
  // 3. Sin permisos
  else if (e.toString().contains('permission') || e is PermissionException) {
    errorMessage = l10n.permissionDenied;
  }
  
  // 4. Registro en uso
  else if (e.toString().contains('in use') || e.toString().contains('active')) {
    errorMessage = l10n.cannotDeleteInUse;
  }
  
  // 5. Error genérico
  else {
    errorMessage = l10n.errorDeleting(l10n.user);
  }
  
  _errorService.showError(
    message: errorMessage,
    type: ErrorType.error,
  );
}
```

### Manejo de Dependencias

```dart
Future<bool> delete({required String id}) async {
  loading = true;

  try {
    // 1. Verificar dependencias primero (opcional)
    final hasDependencies = await _checkDependencies(id);
    
    if (hasDependencies) {
      _errorService.showError(
        message: l10n.cannotDeleteHasDependencies,
        type: ErrorType.warning,
      );
      loading = false;
      return false;
    }

    // 2. Proceder con eliminación
    final mutation = DeleteUserMutation(
      builder: UserFieldsBuilder().defaultValues(),
      declarativeArgs: {"_id": "String!"},
      opArgs: {"_id": GqlVar("_id")},
    );

    await _gqlConn.operation(
      operation: mutation,
      variables: {"_id": id},
    );

    _errorService.showError(
      message: l10n.thingDeletedSuccessfully(l10n.user),
      type: ErrorType.success,
    );

    return true;
  } catch (e, stackTrace) {
    debugPrint('💥 Error: $e');
    debugPrint('📍 StackTrace: $stackTrace');
    
    _errorService.showError(
      message: l10n.errorDeleting(l10n.user),
      type: ErrorType.error,
    );
    
    return false;
  } finally {
    loading = false;
  }
}

/// Verifica si el registro tiene dependencias
Future<bool> _checkDependencies(String id) async {
  try {
    // Query para verificar dependencias
    final query = CheckUserDependenciesQuery(
      builder: DependenciesFieldsBuilder(),
      opArgs: {"_id": id},
    );

    final response = await _gqlConn.operation(operation: query);
    
    // Parsear respuesta
    final dependencies = response['checkUserDependencies'];
    return dependencies['hasDependencies'] as bool;
  } catch (e) {
    debugPrint('⚠️ Error verificando dependencias: $e');
    return false;  // Asumir sin dependencias si falla check
  }
}
```

## Invocación desde el Listado

### Opción A: IconButton Inline

```dart
// En el widget de item de lista
IconButton(
  icon: Icon(Icons.delete),
  // Color definido en theme para acciones destructivas
  onPressed: () async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => UserDeletePage(
        id: user.id,
        userName: user.fullName,
      ),
    );
    
    // ✅ Recargar lista si se eliminó exitosamente
    if (result == true && context.mounted) {
      viewModel.getUsers();  // Refrescar listado
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
          Icon(Icons.edit),
          Text(l10n.edit),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'delete',
      child: Row(
        children: [
          Icon(Icons.delete),
          // Color definido en theme
          Text(l10n.delete),
        ],
      ),
    ),
  ],
  onSelected: (value) async {
    if (value == 'delete') {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => UserDeletePage(
          id: user.id,
          userName: user.fullName,
        ),
      );
      
      if (result == true && context.mounted) {
        viewModel.getUsers();
      }
    }
  },
)
```

### Opción C: Dismissible (Swipe to Delete)

```dart
Dismissible(
  key: Key(user.id),
  direction: DismissDirection.endToStart,
  confirmDismiss: (direction) async {
    // Mostrar diálogo de confirmación
    return await showDialog<bool>(
      context: context,
      builder: (context) => UserDeletePage(
        id: user.id,
        userName: user.fullName,
      ),
    );
  },
  background: Container(
    alignment: Alignment.centerRight,
    // Color y padding definidos en theme
    child: Icon(Icons.delete),
  ),
  child: ListTile(
    title: Text(user.fullName),
    subtitle: Text(user.email),
  ),
  onDismissed: (direction) {
    // Ya se ejecutó el delete, solo actualizar UI
    viewModel.getUsers();
  },
)
```

### Opción D: Navegación con GoRouter

```dart
// En la configuración de rutas
GoRoute(
  path: '/users/:id/delete',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    final userName = state.uri.queryParameters['name'];
    
    return UserDeletePage(
      id: id,
      userName: userName,
    );
  },
),

// Uso
context.push('/users/${user.id}/delete?name=${user.fullName}');
```

## Internacionalización

### Keys Requeridas

**app_es.arb:**
```json
{
  "deleteThing": "Eliminar {thing}",
  "deleteQuestion": "¿Está seguro de eliminar {thing}?",
  "delete": "Eliminar",
  "deleting": "Eliminando...",
  "thingDeletedSuccessfully": "{thing} eliminado exitosamente",
  "femeThingDeletedSuccessfully": "{thing} eliminada exitosamente",
  "errorDeleting": "Error al eliminar {thing}",
  "actionIsIrreversible": "Esta acción es irreversible",
  "cannotDeleteHasDependencies": "No se puede eliminar porque tiene registros relacionados",
  "cannotDeleteInUse": "No se puede eliminar porque está en uso",
  "cascadeDeleteWarning": "Advertencia: Esto también eliminará los registros relacionados",
  "confirmCascadeDelete": "Confirmo que deseo eliminar todos los registros relacionados",
  "recordNotFound": "El registro no fue encontrado",
  "permissionDenied": "No tiene permisos para realizar esta acción"
}
```

**app_en.arb:**
```json
{
  "deleteThing": "Delete {thing}",
  "deleteQuestion": "Are you sure you want to delete {thing}?",
  "delete": "Delete",
  "deleting": "Deleting...",
  "thingDeletedSuccessfully": "{thing} deleted successfully",
  "femeThingDeletedSuccessfully": "{thing} deleted successfully",
  "errorDeleting": "Error deleting {thing}",
  "actionIsIrreversible": "This action is irreversible",
  "cannotDeleteHasDependencies": "Cannot delete because it has related records",
  "cannotDeleteInUse": "Cannot delete because it is in use",
  "cascadeDeleteWarning": "Warning: This will also delete related records",
  "confirmCascadeDelete": "I confirm I want to delete all related records",
  "recordNotFound": "Record not found",
  "permissionDenied": "You do not have permission to perform this action"
}
```

### Uso en el Código

```dart
// Título del diálogo
Text(l10n.deleteThing(l10n.user))  // "Eliminar Usuario"

// Pregunta de confirmación
Text(l10n.deleteQuestion(widget.userName ?? l10n.user))
// "¿Está seguro de eliminar Juan Pérez?"

// Botón
Text(l10n.delete)  // "Eliminar"

// Durante operación
Text(l10n.deleting)  // "Eliminando..."

// Mensaje de éxito
l10n.thingDeletedSuccessfully(l10n.user)  // "Usuario eliminado exitosamente"

// Para entidades femeninas
l10n.femeThingDeletedSuccessfully(l10n.company)  // "Empresa eliminada exitosamente"

// Error
l10n.errorDeleting(l10n.user)  // "Error al eliminar Usuario"

// Advertencias
Text(l10n.actionIsIrreversible)  // "Esta acción es irreversible"
Text(l10n.cannotDeleteHasDependencies)  // "No se puede eliminar porque tiene registros relacionados"
```

## Flujo Completo DELETE

```
1. Usuario hace clic en ícono/botón eliminar
   IconButton(icon: Icon(Icons.delete), onPressed: () => showDialog(...))

2. Se abre diálogo de confirmación
   UserDeletePage(id: user.id, userName: user.fullName)

3. Usuario ve información del registro
   - Nombre/identificador del registro
   - Advertencia sobre acción irreversible
   - Botones: Cancelar / Eliminar

4. Usuario hace clic en "Cancelar"
   context.pop(false)  // No recarga lista

5. O usuario hace clic en "Eliminar"
   await viewModel.delete(id: widget.id)

6. ViewModel muestra loading
   loading = true → notifyListeners()

7. ViewModel ejecuta mutation
   DeleteUserMutation con variables: {"_id": id}

8. GraphQL ejecuta operación
   _gqlConn.operation(operation: mutation, variables: ...)

9. Servidor procesa eliminación
   - Valida permisos
   - Verifica dependencias
   - Elimina registro (hard o soft)

10. ViewModel recibe respuesta
    success = true

11. ViewModel muestra feedback
    ErrorService.showError("Usuario eliminado exitosamente", type: success)

12. Diálogo se cierra con resultado
    context.pop(true)  // ✅ true = éxito

13. Listado detecta resultado exitoso
    if (result == true) viewModel.getUsers()

14. Lista se refresca automáticamente
    Registro eliminado ya no aparece en la lista
```

## Clonación Rápida para Nuevos Módulos DELETE

Para crear un nuevo módulo de eliminación (ej: Product):

### 1. Verificar Delete{Feature}Mutation Existe

**Buscar archivo:**
- `/src/domain/operation/mutations/deleteProduct/deleteproduct_mutation.dart`
- Si NO existe → Crear siguiendo el patrón de DeleteUserMutation

### 2. Verificar Delete{Feature}Usecase Existe

**Buscar archivo:**
- `/src/domain/usecases/Product/delete_product_usecase.dart`
- Si NO existe → Crear siguiendo el patrón de DeleteUserUsecase

### 3. Copiar Estructura

**Copiar de User/delete → Product/delete:**
```bash
cp -r /pages/User/delete /pages/Product/delete
```

### 4. Buscar y Reemplazar

**En todos los archivos copiados:**
- `User` → `Product`
- `user` → `product`
- `Usuario` → `Producto`
- `UserDeletePage` → `ProductDeletePage`
- `DeleteUserMutation` → `DeleteProductMutation`
- `DeleteUserUsecase` → `DeleteProductUsecase`

**Ejemplo con sed:**
```bash
find /pages/Product/delete -type f -exec sed -i 's/User/Product/g' {} \;
find /pages/Product/delete -type f -exec sed -i 's/user/product/g' {} \;
find /pages/Product/delete -type f -exec sed -i 's/Usuario/Producto/g' {} \;
```

### 5. Archivos Genéricos Mantienen Nombre

- ✅ `main.dart` (mismo nombre en todos los módulos)
- ✅ `view_model.dart` (mismo nombre en todos los módulos)

### 6. Ajustar Parámetros en main.dart

**Decidir qué información mostrar:**
```dart
class ProductDeletePage extends StatefulWidget {
  const ProductDeletePage({
    super.key,
    required this.id,
    this.productName,      // ✅ Cambiar a nombre del feature
    this.productCode,      // ✅ Agregar campos adicionales si es necesario
  });
  
  final String id;
  final String? productName;
  final String? productCode;
}
```

### 7. Actualizar Mensaje de Confirmación

```dart
content: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(
      widget.productName != null
        ? l10n.deleteQuestion(widget.productName!)
        : l10n.deleteQuestion(l10n.product),  // ✅ Cambiar feature
    ),
    
    // Información específica del producto
    if (widget.productCode != null)
      Text('${l10n.code}: ${widget.productCode}'),
      
    Text(l10n.actionIsIrreversible),
  ],
),
```

### 8. Implementar delete() en ViewModel

```dart
Future<bool> delete({required String id}) async {
  loading = true;
  bool success = false;

  try {
    final mutation = DeleteProductMutation(  // ✅ Cambiar mutation
      builder: ProductFieldsBuilder().defaultValues(),  // ✅ Cambiar builder
      declarativeArgs: {"_id": "String!"},
      opArgs: {"_id": GqlVar("_id")},
    );

    await _gqlConn.operation(
      operation: mutation,
      variables: {"_id": id},
    );

    success = true;
    
    _errorService.showError(
      message: l10n.thingDeletedSuccessfully(l10n.product),  // ✅ Cambiar feature
      type: ErrorType.success,
    );

    debugPrint('✅ Product eliminado exitosamente');
  } catch (e, stackTrace) {
    debugPrint('💥 Error al eliminar Product: $e');
    debugPrint('📍 StackTrace: $stackTrace');
    
    success = false;
    
    _errorService.showError(
      message: l10n.errorDeleting(l10n.product),  // ✅ Cambiar feature
      type: ErrorType.error,
    );
  } finally {
    loading = false;
  }

  return success;
}
```

### 9. Configurar Invocación desde Listado

```dart
// En product_item.dart o página de listado
IconButton(
  icon: Icon(Icons.delete),
  onPressed: () async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ProductDeletePage(
        id: product.id,
        productName: product.name,
        productCode: product.code,
      ),
    );
    
    if (result == true && context.mounted) {
      viewModel.getProducts();  // ✅ Cambiar método
    }
  },
)
```

### 10. Añadir Keys i18n (si es nueva feature)

**app_es.arb:**
```json
{
  "product": "Producto",
  "products": "Productos"
}
```

**app_en.arb:**
```json
{
  "product": "Product",
  "products": "Products"
}
```

### 11. Considerar Tipo de Eliminación

**Decidir entre Hard Delete o Soft Delete:**

```dart
// Hard Delete (eliminación física)
Future<bool> delete({required String id}) async {
  // Usar DeleteProductMutation
  final mutation = DeleteProductMutation(...)
}

// Soft Delete (eliminación lógica)
Future<bool> softDelete({required String id}) async {
  // Usar UpdateProductMutation
  final input = UpdateProductInput(
    id: id,
    isActive: false,
    deletedAt: DateTime.now(),
  );
}
```

### Checklist de Clonación

- [ ] Delete{Feature}Mutation existe
- [ ] Delete{Feature}Usecase existe
- [ ] {Feature}FieldsBuilder extension con `defaultValues()`
- [ ] Estructura copiada desde User/delete
- [ ] Búsqueda y reemplazo de nombres completada
- [ ] Parámetros ajustados en main.dart (id + información contextual)
- [ ] Mensaje de confirmación personalizado
- [ ] delete() implementado con manejo de errores
- [ ] Invocación configurada desde listado
- [ ] Keys i18n agregadas para el nuevo feature
- [ ] Tipo de eliminación decidido (hard/soft)
- [ ] Manejo de dependencias implementado (si aplica)
- [ ] Feedback visual correcto (success/error)

## Checklist de Verificación DELETE

### Presentación (/pages/{Feature}/delete/)

**main.dart:**
- [ ] Usa `AlertDialog` con icon, title, content, actions
- [ ] Recibe `id` obligatorio como parámetro
- [ ] Recibe información contextual opcional (nombre, código, etc.)
- [ ] Icon de warning en el diálogo
- [ ] `ListenableBuilder` para reactivity
- [ ] Obtiene `l10n` con `AppLocalizations.of(context)!`
- [ ] Usa `l10n.deleteThing(l10n.{feature})` en título
- [ ] Usa `l10n.deleteQuestion()` con nombre del registro
- [ ] Muestra advertencia `l10n.actionIsIrreversible`
- [ ] Botón "Cancelar" hace `context.pop(false)`
- [ ] Botón "Eliminar" llama `viewModel.delete(id: widget.id)`
- [ ] Botón "Eliminar" muestra loading durante operación
- [ ] Botón "Eliminar" deshabilitado cuando loading
- [ ] Verifica `context.mounted` antes de `context.pop(true)`
- [ ] Retorna `true` en `context.pop()` solo si eliminación exitosa
- [ ] Sin strings hardcodeados
- [ ] Sin valores de diseño hardcodeados (colores, padding, SizedBox)

**view_model.dart:**
- [ ] Extiende `ChangeNotifier`
- [ ] Estado `_loading` con getter y setter
- [ ] Setter de `loading` llama `notifyListeners()`
- [ ] Inicializa `GqlConn` y `ErrorService` en constructor
- [ ] Método `delete({required String id})` retorna `Future<bool>`
- [ ] `delete()` crea Mutation con FieldsBuilder
- [ ] `delete()` usa `declarativeArgs: {"_id": "String!"}`
- [ ] `delete()` usa `opArgs: {"_id": GqlVar("_id")}`
- [ ] `delete()` llama `_gqlConn.operation()` con variables
- [ ] ⚠️ **Error handling con try-catch-finally**
- [ ] ⚠️ **catch incluye stackTrace: `catch (e, stackTrace)`**
- [ ] ⚠️ **debugPrint con emoji 💥 para error y 📍 para stackTrace**
- [ ] ⚠️ **ErrorService.showError() para feedback al usuario**
- [ ] ⚠️ **Import `package:flutter/foundation.dart` para debugPrint**
- [ ] ⚠️ **Manejo específico: NotFoundException, dependencias, permisos**
- [ ] finally apaga loading siempre
- [ ] Retorna `true` si éxito, `false` si error
- [ ] Mensaje de éxito con `l10n.thingDeletedSuccessfully()`
- [ ] Mensaje de error con `l10n.errorDeleting()`

### Dominio

**Mutation y UseCase:**
- [ ] `Delete{Feature}Mutation` implementada en `/operation/mutations/delete{Feature}/`
- [ ] `Delete{Feature}Usecase` existe en `/usecases/{Feature}/`
- [ ] Mutation retorna entidad {Feature}
- [ ] UseCase usa `{Feature}FieldsBuilder().defaultValues()`

**FieldsBuilder Extension:**
- [ ] `{Feature}FieldsBuilderExtension` existe en `/extensions/`
- [ ] Extension tiene método `defaultValues()` con campos necesarios

### Invocación desde Listado

- [ ] IconButton o botón de eliminar implementado
- [ ] Usa `showDialog()` para abrir diálogo de confirmación
- [ ] Pasa `id` y datos contextuales (nombre, etc.)
- [ ] Captura resultado del diálogo: `final result = await showDialog<bool>()`
- [ ] Refresca lista si resultado es `true`: `if (result == true) viewModel.get{Features}()`
- [ ] Verifica `context.mounted` antes de refrescar

### Internacionalización

**Keys i18n:**
- [ ] `deleteThing` en app_es.arb y app_en.arb
- [ ] `deleteQuestion` en ambos archivos
- [ ] `delete`, `deleting` en ambos
- [ ] `thingDeletedSuccessfully` en ambos
- [ ] `femeThingDeletedSuccessfully` en ambos (si aplica)
- [ ] `errorDeleting` en ambos
- [ ] `actionIsIrreversible` en ambos
- [ ] `cannotDeleteHasDependencies` en ambos
- [ ] `cannotDeleteInUse` en ambos (si aplica)
- [ ] `recordNotFound`, `permissionDenied` en ambos
- [ ] Feature name (ej: `user`, `product`) en ambos archivos
- [ ] Usa `l10n` para TODOS los textos visibles
- [ ] Sin strings hardcodeados

### General

- [ ] Context se pasa como parámetro, nunca se almacena
- [ ] 🐛 Usar `debugPrint` en lugar de `print` para debugging
- [ ] ✅ Import `package:flutter/foundation.dart` en archivos de dominio que usen debugPrint
- [ ] Confirmación obligatoria antes de eliminar
- [ ] Tipo de eliminación decidido (hard/soft)
- [ ] Manejo de dependencias implementado (si aplica)
- [ ] Feedback visual claro (success/error)
- [ ] Sin errores de compilación
- [ ] Mutation y UseCase en carpetas correctas

### Características Opcionales (si se implementaron)

**Soft Delete:**
- [ ] Usa `UpdateMutation` en lugar de `DeleteMutation`
- [ ] Campo `isActive` actualizado a `false`
- [ ] Campo `deletedAt` actualizado a fecha actual (si existe)
- [ ] Campo `deletedBy` actualizado a usuario actual (si existe)

**Verificación de Dependencias:**
- [ ] Método `_checkDependencies()` implementado
- [ ] Query para verificar dependencias creada
- [ ] Mensaje específico si tiene dependencias
- [ ] Previene eliminación si tiene dependencias

**Cascade Delete:**
- [ ] Advertencia de eliminación en cascada mostrada
- [ ] Lista de registros afectados mostrada
- [ ] Confirmación adicional requerida (checkbox)
- [ ] Keys i18n para mensajes de cascada

## Mejores Prácticas

### Debugging

**🐛 USAR debugPrint EN LUGAR DE print:**
```dart
// MAL ❌
print('Eliminando registro: $id');

// BIEN ✅
debugPrint('🗑️ Eliminando User con ID: $id');
debugPrint('✅ User eliminado exitosamente');
```

**Razones:**
- `debugPrint` no se trunca en consola con textos largos
- Solo imprime en modo debug, no en release
- Mejor rendimiento en producción
- Es la práctica recomendada de Flutter
- Requiere `import 'package:flutter/foundation.dart';` en archivos de dominio

**Emojis para filtrado:**
- 🗑️ para operaciones de eliminación
- ✅ para eliminaciones exitosas
- 💥 para errores
- 📍 para stackTrace
- ⚠️ para advertencias

### Confirmación

**❌ NUNCA eliminar sin confirmación:**
```dart
// MAL ❌
IconButton(
  icon: Icon(Icons.delete),
  onPressed: () async {
    await viewModel.delete(id: user.id);  // Sin confirmación
  },
)
```

**✅ SIEMPRE mostrar diálogo de confirmación:**
```dart
// BIEN ✅
IconButton(
  icon: Icon(Icons.delete),
  onPressed: () async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => UserDeletePage(
        id: user.id,
        userName: user.fullName,
      ),
    );
    
    if (result == true && context.mounted) {
      viewModel.getUsers();
    }
  },
)
```

### Internacionalización

**❌ NUNCA hardcodear textos:**
```dart
// MAL ❌
Text("¿Eliminar Usuario?")
Text("Esta acción es irreversible")
```

**✅ SIEMPRE usar l10n:**
```dart
// BIEN ✅
Text(l10n.deleteQuestion(l10n.user))
Text(l10n.actionIsIrreversible)
```

### Context Management

- Context se pasa como parámetro en constructores
- NUNCA almacenar context en variables de instancia
- Verificar `context.mounted` antes de usar `context.pop()` en callbacks async
- Usar `BuildContext` directamente en métodos síncronos

### Manejo de Errores

**⚠️ SIEMPRE capturar stackTrace en catch:**
```dart
// MAL ❌
catch (e) {
  debugPrint('Error: $e');
}

// BIEN ✅
catch (e, stackTrace) {
  debugPrint('💥 Error al eliminar {Feature}: $e');
  debugPrint('📍 StackTrace: $stackTrace');
  
  String errorMessage;
  
  if (e.toString().contains('not found')) {
    errorMessage = l10n.recordNotFound;
  } else if (e.toString().contains('foreign key')) {
    errorMessage = l10n.cannotDeleteHasDependencies;
  } else if (e.toString().contains('permission')) {
    errorMessage = l10n.permissionDenied;
  } else {
    errorMessage = l10n.errorDeleting(l10n.{feature});
  }
  
  _errorService.showError(
    message: errorMessage,
    type: ErrorType.error,
  );
}
```

**Elementos Requeridos:**
1. **stackTrace parameter** - Segunda variable en catch para debugging completo
2. **debugPrint con emojis** - 💥 para error, 📍 para stackTrace, 🗑️ para operación
3. **ErrorService.showError()** - Feedback visual al usuario con SnackBar
4. **Mensajes específicos** - Diferentes mensajes según tipo de error
5. **Import foundation.dart** - `import 'package:flutter/foundation.dart';`
6. **Manejo específico** - NotFoundException, dependencias, permisos

### Tipo de Eliminación

**Decisión estratégica:**

```dart
// Hard Delete - Cuando:
// - Registros de prueba
// - Sin dependencias
// - GDPR / derecho al olvido
Future<bool> delete({required String id}) async {
  // Usar DeleteMutation
}

// Soft Delete - Cuando:
// - Tiene dependencias
// - Requiere auditoría
// - Posible restauración
// - Reportes históricos
Future<bool> softDelete({required String id}) async {
  // Usar UpdateMutation con isActive: false
}
```

### Información Contextual

**Mejorar UX con contexto:**

```dart
// Mínimo (genérico)
UserDeletePage(id: user.id)
// Mensaje: "¿Está seguro de eliminar Usuario?"

// Recomendado (personalizado)
UserDeletePage(
  id: user.id,
  userName: user.fullName,
)
// Mensaje: "¿Está seguro de eliminar Juan Pérez?"

// Completo (con detalles)
UserDeletePage(
  id: user.id,
  userName: user.fullName,
  userEmail: user.email,
  userRole: user.role,
)
// Muestra todos los detalles en el diálogo
```

## Ventajas del Patrón DELETE

1. **Confirmación obligatoria** - Previene eliminaciones accidentales
2. **Información contextual** - Usuario sabe exactamente qué eliminará
3. **Feedback claro** - Mensajes de éxito/error específicos
4. **Manejo robusto de errores** - Casos específicos bien manejados
5. **Flexibilidad** - Soporta hard delete, soft delete, cascade delete
6. **Reversibilidad** - Soft delete permite restauración
7. **Integridad referencial** - Verifica dependencias antes de eliminar
8. **Auditoría** - Registra quién y cuándo eliminó (soft delete)
9. **UX consistente** - Mismo patrón en todos los módulos
10. **i18n completo** - Multiidioma desde el inicio
11. **Refresh automático** - Listado se actualiza tras eliminación exitosa

## Próximos Chatmodes

- ✅ `create_pattern.chatmode.md` - Patrón para CREATE (formularios)
- ✅ `read_pattern.chatmode.md` - Patrón para READ (listado)
- ✅ `update_pattern.chatmode.md` - Patrón para UPDATE (edición)
- ✅ `delete_pattern.chatmode.md` - Patrón para DELETE (confirmación) ← ESTE

````
