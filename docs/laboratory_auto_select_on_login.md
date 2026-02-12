# Auto-selección de Laboratorio después del Login

## Problema Identificado

Cuando un usuario iniciaba sesión, no había un laboratorio seleccionado por defecto, lo que causaba problemas porque:
- Los drawers y otros componentes requieren que haya un laboratorio seleccionado
- El usuario tenía que seleccionar manualmente un laboratorio después del login
- Esto generaba errores y una mala experiencia de usuario

## Solución Implementada

### 1. Flujo Actual del Login

El backend ya retorna un `LoggedUser` con un `currentLaboratory` cuando el usuario inicia sesión:

```dart
class LoggedUser {
  final User? user;
  final Laboratory? currentLaboratory;  // ← Ya viene del backend
  final LabMemberRole? labRole;
  final bool userIsLabOwner;
}
```

### 2. Cambios Realizados

#### A. Nuevo método en `LaboratoryNotifier`

Se agregó el método `initializeDefaultLaboratory()` que:
- Establece el laboratorio seleccionado
- Lo guarda en SharedPreferences
- Actualiza el estado del notifier
- **NO ejecuta** la mutación `setCurrentLaboratory` porque el backend ya lo hizo

**Archivo:** `/lib/src/presentation/providers/laboratory_notifier.dart`

```dart
Future<void> initializeDefaultLaboratory(
  Laboratory laboratory, 
  LoggedUser loggedUser,
) async {
  _selectedLaboratory = laboratory;
  _loggedUser = loggedUser;
  
  // Guardar en SharedPreferences
  try {
    final prefs = await SharedPreferences.getInstance();
    final laboratoryJson = jsonEncode(laboratory.toJson());
    await prefs.setString('selected_laboratory', laboratoryJson);
    debugPrint('💾 Laboratorio guardado en SharedPreferences: ${laboratory.company?.name}');
  } catch (e) {
    if (kDebugMode) {
      debugPrint('💥 Error saving selected laboratory: $e');
    }
  }
  
  notifyListeners();
}
```

#### B. Actualización del `setLoginUser()` en Login ViewModel

Se modificó para que después de hacer signIn, automáticamente inicialice el laboratorio si existe:

**Archivo:** `/lib/src/presentation/pages/Login/read/view_model.dart`

```dart
setLoginUser(LoggedUser loggedUser) async{
  final authNotifier = _context.read<AuthNotifier>();
  await authNotifier.signIn(
    user: loggedUser.user!,
    userIsLabOwner: loggedUser.userIsLabOwner,
    labRole: loggedUser.labRole,
  );
  
  // Si el LoggedUser tiene un currentLaboratory, seleccionarlo automáticamente
  if (loggedUser.currentLaboratory != null) {
    try {
      final laboratoryNotifier = _context.read<LaboratoryNotifier>();
      await laboratoryNotifier.initializeDefaultLaboratory(
        loggedUser.currentLaboratory!,
        loggedUser,
      );
      debugPrint('✅ Laboratorio por defecto inicializado: ${loggedUser.currentLaboratory!.company?.name}');
    } catch (e, stackTrace) {
      debugPrint('💥 Error inicializando laboratorio por defecto: $e');
      debugPrint('📍 StackTrace: $stackTrace');
    }
  } else {
    debugPrint('⚠️ LoggedUser no tiene currentLaboratory - usuario deberá seleccionar uno');
  }
}
```

### 3. Flujo Completo después del Login

```
1. Usuario se loguea (AuthCallbackPage)
   ↓
2. Backend retorna LoggedUser con currentLaboratory
   ↓
3. setLoginUser() se ejecuta:
   - authNotifier.signIn() guarda datos del usuario
   - Si currentLaboratory existe:
     - laboratoryNotifier.initializeDefaultLaboratory()
     - Guarda laboratorio en SharedPreferences
     - Actualiza estado del LaboratoryNotifier
   ↓
4. Usuario es redirigido a /home
   ↓
5. Los drawers y componentes ya tienen laboratorio seleccionado ✅
```

### 4. Diferencia con `selectLaboratory()`

- **`selectLaboratory()`**: 
  - Se usa cuando el usuario CAMBIA de laboratorio manualmente
  - Ejecuta la mutación `setCurrentLaboratory` en el backend
  - Navega a una ruta según el rol del usuario
  
- **`initializeDefaultLaboratory()`**:
  - Se usa solo después del LOGIN
  - NO ejecuta mutación (el backend ya lo hizo)
  - Solo guarda el laboratorio localmente

### 5. Persistencia

El laboratorio seleccionado se guarda en SharedPreferences con la key:
```dart
'selected_laboratory'
```

Esto permite que si el usuario recarga la app, el laboratorio siga seleccionado.

## Beneficios

✅ **Experiencia de usuario mejorada**: El usuario no necesita seleccionar laboratorio después del login  
✅ **Sin errores**: Los componentes que requieren laboratorio funcionan inmediatamente  
✅ **Persistencia**: El laboratorio se mantiene seleccionado entre sesiones  
✅ **Eficiencia**: No se hacen llamadas innecesarias al backend  
✅ **Debugging mejorado**: Mensajes de debug claros con emojis  

## Testing

Para probar la funcionalidad:

1. **Logout** del usuario actual (si está logueado)
2. **Login** nuevamente
3. **Verificar** en la consola:
   ```
   💾 Laboratorio guardado en SharedPreferences: [nombre del laboratorio]
   ✅ Laboratorio por defecto inicializado: [nombre del laboratorio]
   ```
4. **Confirmar** que el switcher de laboratorio en el AppBar muestra el laboratorio
5. **Confirmar** que los drawers y componentes funcionan correctamente

## Casos Edge

### Si el backend NO retorna currentLaboratory

El código maneja este caso:
```dart
if (loggedUser.currentLaboratory != null) {
  // inicializar laboratorio
} else {
  debugPrint('⚠️ LoggedUser no tiene currentLaboratory - usuario deberá seleccionar uno');
}
```

El usuario deberá seleccionar manualmente un laboratorio usando el LaboratorySwitcher.

### Si hay error al guardar

El error se captura y se loguea, pero no bloquea el login:
```dart
catch (e, stackTrace) {
  debugPrint('💥 Error inicializando laboratorio por defecto: $e');
  debugPrint('📍 StackTrace: $stackTrace');
}
```

## Fecha de Implementación

1 de febrero de 2026
