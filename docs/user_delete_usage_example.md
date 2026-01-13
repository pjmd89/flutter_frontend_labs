# Ejemplo de Uso: User Delete Module

## Descripción
Este documento muestra cómo usar el módulo de eliminación de usuarios (`UserDeletePage`) desde un listado u otra página.

## Implementación Completa

### Archivos Creados
- `/lib/src/presentation/pages/User/delete/main.dart` - Diálogo de confirmación
- `/lib/src/presentation/pages/User/delete/view_model.dart` - Lógica de eliminación

### Archivos Domain Existentes (ya estaban)
- `/lib/src/domain/operation/mutations/deleteUser/deleteuser_mutation.dart`
- `/lib/src/domain/usecases/User/delete_user_usecase.dart`
- `/lib/src/domain/extensions/user_fields_builder_extension.dart`

## Formas de Invocar el Delete

### Opción 1: IconButton Inline (Recomendado)

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/l10n/app_localizations.dart';
import '/src/presentation/pages/User/delete/main.dart';

// En el widget de item de lista
ListTile(
  title: Text(user.fullName),
  subtitle: Text(user.email),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          // Navegar a edición
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => UserDeletePage(
              id: user.id,
              userName: '${user.firstName} ${user.lastName}',
            ),
          );
          
          // ✅ Recargar lista si se eliminó exitosamente
          if (result == true && context.mounted) {
            viewModel.getUsers(); // Tu método que refresca el listado
          }
        },
      ),
    ],
  ),
)
```

### Opción 2: Menú Contextual (PopupMenuButton)

```dart
ListTile(
  title: Text(user.fullName),
  subtitle: Text(user.email),
  trailing: PopupMenuButton<String>(
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
          builder: (context) => UserDeletePage(
            id: user.id,
            userName: '${user.firstName} ${user.lastName}',
          ),
        );
        
        if (result == true && context.mounted) {
          viewModel.getUsers();
        }
      }
    },
  ),
)
```

### Opción 3: Dismissible (Swipe to Delete)

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
        userName: '${user.firstName} ${user.lastName}',
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
    title: Text(user.fullName),
    subtitle: Text(user.email),
  ),
  onDismissed: (direction) {
    // Ya se ejecutó el delete, solo actualizar UI
    viewModel.getUsers();
  },
)
```

### Opción 4: Navegación con GoRouter

**1. Configurar la ruta en tu GoRouter:**

```dart
// En tu configuración de rutas
GoRoute(
  path: '/users',
  builder: (context, state) => const UserListPage(),
  routes: [
    GoRoute(
      path: ':id/delete',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final userName = state.uri.queryParameters['name'];
        
        return UserDeletePage(
          id: id,
          userName: userName,
        );
      },
    ),
  ],
),
```

**2. Usar la navegación:**

```dart
IconButton(
  icon: const Icon(Icons.delete),
  onPressed: () async {
    final userName = '${user.firstName} ${user.lastName}';
    final result = await context.push<bool>(
      '/users/${user.id}/delete?name=$userName',
    );
    
    if (result == true && context.mounted) {
      viewModel.getUsers();
    }
  },
)
```

## Parámetros del UserDeletePage

### Obligatorios
- `id` (String): El ID del usuario a eliminar

### Opcionales
- `userName` (String?): Nombre del usuario para mostrar en el mensaje de confirmación
  - Si se proporciona: "¿Está seguro de eliminar Juan Pérez?"
  - Si no: "¿Está seguro de eliminar Usuario?"

## Flujo de Eliminación

1. Usuario hace clic en el botón/ícono de eliminar
2. Se abre el diálogo de confirmación (`AlertDialog`)
3. Muestra información del usuario y advertencia
4. Usuario puede:
   - **Cancelar**: Cierra el diálogo sin hacer nada (retorna `false`)
   - **Eliminar**: Ejecuta la eliminación
     - Muestra loading en el botón
     - Llama a `viewModel.delete(id: id)`
     - Ejecuta `DeleteUserMutation` en GraphQL
     - Muestra SnackBar de éxito o error
     - Cierra el diálogo retornando `true` si fue exitoso
5. Si el resultado fue `true`, la página que invocó recarga el listado

## Mensajes de Error Manejados

El ViewModel maneja automáticamente estos tipos de error:

- **Registro no encontrado**: `l10n.recordNotFound`
- **Tiene dependencias**: `l10n.cannotDeleteHasDependencies`
- **Sin permisos**: `l10n.permissionDenied`
- **Error genérico**: `l10n.errorDeleting(l10n.user)`

## Ejemplo Completo en un ListPage

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/l10n/app_localizations.dart';
import '/src/presentation/pages/User/delete/main.dart';
import './view_model.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late ViewModel viewModel;
  late AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
    l10n = AppLocalizations.of(context)!;
    
    // Cargar usuarios al iniciar
    viewModel.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.users),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.users.isEmpty) {
            return Center(child: Text(l10n.noRecords));
          }

          return ListView.builder(
            itemCount: viewModel.users.length,
            itemBuilder: (context, index) {
              final user = viewModel.users[index];
              
              return ListTile(
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navegar a edición
                        context.push('/users/${user.id}/edit');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => UserDeletePage(
                            id: user.id,
                            userName: '${user.firstName} ${user.lastName}',
                          ),
                        );
                        
                        // Recargar lista si se eliminó exitosamente
                        if (result == true && context.mounted) {
                          viewModel.getUsers();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a crear usuario
          context.push('/users/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Características Implementadas

✅ Diálogo de confirmación con AlertDialog  
✅ Información contextual (nombre del usuario)  
✅ Advertencia de acción irreversible  
✅ Loading state en el botón durante eliminación  
✅ Manejo robusto de errores con stackTrace  
✅ Mensajes específicos según tipo de error  
✅ Feedback visual con SnackBar (ErrorService)  
✅ Retorno de resultado para actualizar lista  
✅ Verificación de context.mounted antes de pop  
✅ Internacionalización completa  
✅ debugPrint con emojis para debugging  
✅ Botón destructivo con color de error  

## Testing Rápido

Para probar que funciona correctamente:

1. Agrega un botón de eliminar en tu listado de usuarios
2. Haz clic en eliminar
3. Verifica que aparece el diálogo con el nombre correcto
4. Cancela y verifica que no pasa nada
5. Elimina y verifica que:
   - Aparece el loading en el botón
   - Se muestra SnackBar de éxito
   - El usuario desaparece de la lista
   - La consola muestra los debugPrint con emojis

## Notas Importantes

- ⚠️ **Siempre espera el resultado del diálogo**: `await showDialog<bool>()`
- ⚠️ **Verifica context.mounted**: Antes de usar `context` después de operaciones async
- ⚠️ **Recarga el listado solo si fue exitoso**: `if (result == true)`
- ✅ El módulo ya está completo y listo para usar
- ✅ No necesitas modificar nada más para que funcione
