# Patrón de Auto-Refresh al Cambiar de Laboratorio

## Problema Resuelto

Cuando un usuario cambia de laboratorio usando el `LaboratorySelector`, los datos mostrados en la página actual deben refrescarse automáticamente para mostrar los datos del nuevo laboratorio.

## Solución Implementada

### 1. LaboratoryNotifier con Callback Opcional

El `LaboratoryNotifier.selectLaboratory()` ahora acepta un callback opcional:

```dart
Future<void> selectLaboratory(
  Laboratory laboratory, 
  BuildContext context, {
  Future<void> Function()? onLaboratoryChanged,
}) async {
  // ... lógica de cambio de laboratorio ...
  
  if (onLaboratoryChanged != null) {
    await onLaboratoryChanged();
  } else {
    _autoRefreshByRoute(context); // Refresco automático
  }
}
```

### 2. Auto-Detección de Ruta

Si no se proporciona un callback, el `LaboratoryNotifier` detecta automáticamente la ruta actual y dispara `notifyListeners()` para que las páginas puedan refrescarse:

```dart
void _autoRefreshByRoute(BuildContext context) {
  final routerState = GoRouterState.of(context);
  final currentRoute = routerState.matchedLocation;
  
  if (currentRoute.contains('/user')) {
    debugPrint('🔄 Detectada página de usuarios, disparando evento de refresco');
  }
  // ... más rutas ...
  
  notifyListeners();
}
```

### 3. ViewModel Escuchando Cambios

Cada `ViewModel` puede escuchar cambios en el `LaboratoryNotifier` y ejecutar su método de recarga:

```dart
class ViewModel extends ChangeNotifier {
  late LaboratoryNotifier _laboratoryNotifier;
  
  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = context.read<GQLNotifier>().gqlConn;
    _laboratoryNotifier = context.read<LaboratoryNotifier>();
    
    // Escuchar cambios en el laboratorio
    _laboratoryNotifier.addListener(_onLaboratoryChanged);
    
    _init();
  }
  
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando datos...');
    getMemberships(); // o getUsers(), getPatients(), etc.
  }
  
  @override
  void dispose() {
    _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    super.dispose();
  }
}
```

## Uso en Diferentes Escenarios

### Opción 1: Auto-Refresh (Recomendado)

Deja que el ViewModel escuche los cambios automáticamente:

```dart
// En el ViewModel
_laboratoryNotifier.addListener(_onLaboratoryChanged);

void _onLaboratoryChanged() {
  getDataForCurrentPage(); // Método de recarga específico
}
```

**Ventajas:**
- ✅ No requiere cambios en el código que llama a `selectLaboratory`
- ✅ La página se mantiene sincronizada automáticamente
- ✅ Funciona desde cualquier lugar (drawer, dialog, etc.)

### Opción 2: Callback Explícito

Pasa un callback específico al cambiar de laboratorio:

```dart
await laboratoryNotifier.selectLaboratory(
  laboratory, 
  context,
  onLaboratoryChanged: () async {
    // Lógica específica de recarga
    await customViewModel.refreshData();
  },
);
```

**Ventajas:**
- ✅ Control explícito sobre qué se ejecuta
- ✅ Útil para lógica compleja o múltiples ViewModels

## Ejemplo Completo: Página de Membresías

**view_model.dart:**
```dart
import 'package:provider/provider.dart';
import '/src/presentation/providers/laboratory_notifier.dart';

class ViewModel extends ChangeNotifier {
  late LaboratoryNotifier _laboratoryNotifier;
  final BuildContext _context;

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = context.read<GQLNotifier>().gqlConn;
    _laboratoryNotifier = context.read<LaboratoryNotifier>();
    
    // Escuchar cambios de laboratorio
    _laboratoryNotifier.addListener(_onLaboratoryChanged);
    
    _init();
  }
  
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando membresías...');
    getMemberships();
  }
  
  @override
  void dispose() {
    _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    super.dispose();
  }

  Future<void> getMemberships() async {
    loading = true;
    try {
      final response = await _readUseCase.build();
      if (response is EdgeLabMembershipInfo) {
        membershipList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error: $e');
      error = true;
    } finally {
      loading = false;
    }
  }
}
```

## Flujo Completo

1. Usuario abre `LaboratorySelector`
2. Usuario selecciona un laboratorio
3. `LaboratoryNotifier.selectLaboratory()` se ejecuta:
   - Guarda laboratorio en SharedPreferences
   - Ejecuta mutación `setCurrentLaboratory`
   - Actualiza `labRole` en AuthNotifier
   - Llama a `notifyListeners()`
4. El `ViewModel` escucha el cambio vía `_onLaboratoryChanged()`
5. El `ViewModel` ejecuta su método de recarga (`getMemberships()`, `getUsers()`, etc.)
6. La UI se actualiza con los datos del nuevo laboratorio

## Rutas Detectadas Automáticamente

El sistema detecta estas rutas:
- `/user/*` → Páginas de usuarios
- `/patient/*` → Páginas de pacientes
- `/exam/*` → Páginas de exámenes
- `/company/*` → Páginas de empresas

Para agregar más rutas, edita `_autoRefreshByRoute()` en `laboratory_notifier.dart`.

## Debug

Los logs ayudan a rastrear el flujo:
```
🚀 Ejecutando mutación setCurrentLaboratory para laboratoryId: abc123
✅ setCurrentLaboratory ejecutado exitosamente
   CurrentLab: Mi Laboratorio
   LabRole: ADMIN
📍 Ruta actual detectada: /user/read
🔄 Detectada página de usuarios, disparando evento de refresco
🔄 Laboratorio cambiado, recargando membresías...
```

## Mejores Prácticas

1. **Siempre** usar `addListener` y `removeListener` en el `ViewModel`
2. **Siempre** llamar `removeListener` en `dispose()`
3. **No** guardar referencias al `BuildContext` fuera del constructor
4. **Usar** `debugPrint` para logging (no `print`)
5. **Capturar** stackTrace en el catch para debugging
