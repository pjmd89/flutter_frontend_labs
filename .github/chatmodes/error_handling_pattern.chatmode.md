# Patrón de Manejo de Errores GraphQL - Flutter

Este chatmode documenta el patrón completo para implementar manejo de errores GraphQL en Flutter usando agile_front framework.

**Alcance:** Manejo global de errores con mensajes i18n y feedback visual  
**Relacionados:** create_pattern, read_pattern, update_pattern, delete_pattern

## Principios Fundamentales

### 1. Manejo Centralizado
- Todos los errores GraphQL se manejan en **UN SOLO LUGAR**: `GQLNotifier`
- El `ErrorManager` mapea códigos de error a handlers específicos
- Cada handler decide cómo procesar el error (logout, mostrar mensaje, etc.)

### 2. Feedback Visual Consistente
- Los errores se muestran con `SnackBar` flotante
- Los mensajes están internacionalizados (i18n)
- Fallback al mensaje del servidor si no hay traducción
- **Respeta el tema de la aplicación** (colores, tipografía, espaciado)

### 3. Separación de Responsabilidades
- `ErrorService`: Maneja la visualización de errores (UI)
- `GQLNotifier`: Detecta errores GraphQL y delega al ErrorService
- `Template`: Solo orquesta providers (no lógica de errores)
- `ErrorManager`: Ejecuta el handler correcto según el código

### 4. Integración con el Sistema de Temas
- **ColorScheme**: Usa colores del tema (error, tertiary, primary, secondary)
- **TextTheme**: Usa tipografía definida en el tema (bodyMedium)
- **SnackBarTheme**: Respeta configuración global de SnackBars
- **BuildContext requerido**: Todos los métodos necesitan context para acceder al tema

## Estructura de Archivos

```
/src/
  /infraestructure/
    /error/
      └── error_manager.dart           # ErrorManager con Map de handlers
    /services/
      └── error_service.dart           # ErrorService (manejo de errores UI)
  /presentation/
    /providers/
      ├── gql_notifier.dart            # GQLNotifier con handlers registrados
      └── auth_notifier.dart           # AuthNotifier para logout
    /core/
      /templates/
        └── main.dart                  # Template (orquestador)

/l10n/
  ├── app_es.arb                       # Keys i18n en español
  └── app_en.arb                       # Keys i18n en inglés
```

**Separación de Responsabilidades:**
- `ErrorService`: Servicio de infraestructura sin estado para mostrar errores (SnackBar, i18n, scaffoldMessengerKey)
- `GQLNotifier`: Detecta errores GraphQL y delega al ErrorService
- `Template`: Solo orquesta y conecta providers (no lógica de errores)

**Service vs Notifier:**
- `ErrorService` es un **servicio sin estado** (no extiende ChangeNotifier)
- Se registra con `Provider<ErrorService>` (NO ChangeNotifierProvider)
- No tiene estado observable, solo métodos para mostrar errores
- Los `Notifiers` son para **estado observable** (auth, locale, theme)

## Formato de Errores del Backend

Los errores vienen en el siguiente formato GraphQL:

```json
{
  "data": {
    "__typename": "Mutation"
  },
  "errors": [
    {
      "message": "missing owner or company info",
      "extensions": {
        "code": "014",
        "level": "fatal"
      }
    }
  ]
}
```

**Campos importantes:**
- `message`: Mensaje en inglés del servidor
- `extensions.code`: Código único del error (usado para mapear handlers)
- `extensions.level`: Nivel de severidad (fatal, warning, info)

## Códigos de Error del Backend

Lista completa de códigos (al 2025):

| Código | Mensaje                                                      | Acción        |
|--------|--------------------------------------------------------------|---------------|
| 001    | user not logged in                                           | Logout        |
| 002    | empty or invalid input id                                    | Mostrar       |
| 003    | user not found                                               | Mostrar       |
| 004    | laboratory not found                                         | Mostrar       |
| 005    | error when trying to create laboratory                       | Mostrar       |
| 006    | error when trying to update laboratory                       | Mostrar       |
| 007    | error when trying to delete laboratory                       | Mostrar       |
| 008    | laboratory is required                                       | Mostrar       |
| 009    | an account already exists with the email provided            | Mostrar       |
| 010    | a company already exists with the tax id provided            | Mostrar       |
| 011    | error when trying to create user                             | Mostrar       |
| 012    | error when trying to update user                             | Mostrar       |
| 013    | error when trying to delete user                             | Mostrar       |
| 014    | missing owner or company info                                | Mostrar       |
| 015    | company not found                                            | Mostrar       |
| 016    | error when trying to create company                          | Mostrar       |
| 017    | error when trying to update company                          | Mostrar       |
| 018    | error when trying to delete company                          | Mostrar       |
| 019    | once you log in for the first time, you cannot update email  | Mostrar       |
| 020    | the employee is not part of the laboratory                   | Mostrar       |
| 021    | user already logged in                                       | Mostrar       |
| 022    | invalid oidc state code                                      | Mostrar       |
| 023    | error when trying to create oidc state code                  | Mostrar       |
| 024    | error when trying to log in with oidc                        | Mostrar       |
| 025    | access Denied                                                | Mostrar       |
| 026    | invalid phone number, must be in E.164 format                | Mostrar       |
| 027    | invalid email format                                         | Mostrar       |
| 028    | invalid date time format, must be unix timestamp             | Mostrar       |
| 029    | session not found                                            | Mostrar       |
| 030    | error when trying to create exam template                    | Mostrar       |
| 031    | error when trying to update exam template                    | Mostrar       |
| 032    | error when trying to delete exam template                    | Mostrar       |
| 033    | exam template not found                                      | Mostrar       |
| 034    | exam template is being used in laboratory exams              | Mostrar       |
| 035    | an exam template with the same name already exists           | Mostrar       |
| 036    | company ID is required                                       | Mostrar       |
| 037    | address cannot be empty                                      | Mostrar       |
| 038    | the employee is already part of the laboratory               | Mostrar       |
| 039    | the laboratory has no employees                              | Mostrar       |
| 040    | exam not found                                               | Mostrar       |
| 041    | error when trying to create exam                             | Mostrar       |
| 042    | error when trying to update exam                             | Mostrar       |
| 043    | error when trying to delete exam                             | Mostrar       |
| 044    | exam base cost must be a positive value                      | Mostrar       |
| 045    | exam is being used in evaluation packages, cannot be deleted | Mostrar       |
| 046    | missing human patient fields                                 | Mostrar       |
| 047    | date time cannot be greater than current time                | Mostrar       |
| 048    | error when trying to create patient                          | Mostrar       |
| 049    | error when trying to update patient                          | Mostrar       |
| 050    | patient not found                                            | Mostrar       |
| 051    | an account already exists with the phone number provided     | Mostrar       |
| 052    | error when trying to delete patient                          | Mostrar       |
| 053    | a patient with the provided DNI already exists               | Mostrar       |

## Implementación Detallada

### 1. ErrorManager (Infraestructura)

**Ubicación:** `/src/infraestructure/error/error_manager.dart`

Ya existe en el proyecto, no necesita modificación:

```dart
import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';

typedef ErrorHandler = void Function(List<GraphQLError> errors);

class ErrorManager implements ErrorConnManager {
  final Map<String, ErrorHandler> handlers;
  
  ErrorManager({required this.handlers});
  
  @override
  ErrorReturned handleGraphqlError(List<GraphQLError> errors) {
    for (var err in errors) {
      if (handlers.containsKey(err.extensions?['code'])) {
        handlers[err.extensions?['code']]!(errors);
      } else {
        debugPrint('Unhandled GraphQL error: ${err.message}');
      }
    }
    return ErrorReturned(
      gqlError: errors,
      httpError: null,
    );
  }
  
  @override
  ErrorReturned handleHttpError(QueryResult result) {
    return ErrorReturned(
      gqlError: null,
      httpError: result,
    );
  }
}
```

**Características:**
- Recibe un `Map<String, ErrorHandler>` en constructor
- Ejecuta el handler correspondiente al código del error
- Si no hay handler, imprime debug pero no crashea

### 2. ErrorService (Infraestructura)

**Ubicación:** `/src/infraestructure/services/error_service.dart`

**Responsabilidad:** Servicio sin estado para manejar visualización de errores

**⚠️ IMPORTANTE - Cambios recientes:**
- ✅ Todos los métodos públicos ahora **requieren BuildContext**
- ✅ Usa colores del **Theme** (ColorScheme) en lugar de hardcoded
- ✅ Usa tipografía del **Theme** (textTheme.bodyMedium)
- ✅ Limpia SnackBars anteriores antes de mostrar nuevos
- ✅ Configuración mejorada de UI (padding, dismissDirection, shape)

```dart
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

enum ErrorType {
  error,
  warning,
  info,
  success,
}

class ErrorService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Muestra un error del backend con código y mensaje
  void showBackendError({
    required BuildContext context,  // ← BuildContext REQUERIDO
    required String errorCode,
    required String errorMessage,
  }) {
    String displayMessage = errorMessage;

    try {
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        final translatedMessage = _getBackendErrorMessage(l10n, errorCode);
        if (translatedMessage != null) {
          displayMessage = translatedMessage;
        }
      }
    } catch (e) {
      // Si falla, usar el mensaje del servidor
    }

    _showSnackBar(
      context: context,
      message: displayMessage,
      type: ErrorType.error,
      duration: const Duration(seconds: 4),
    );
  }

  /// Muestra un error de validación (formularios)
  void showValidationError({
    required BuildContext context,  // ← BuildContext REQUERIDO
    required String message,
    Duration? duration,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      type: ErrorType.warning,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Muestra un error genérico con tipo personalizable
  void showError({
    required BuildContext context,  // ← BuildContext REQUERIDO
    required String message,
    ErrorType type = ErrorType.error,
    Duration? duration,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      type: type,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  void _showSnackBar({
    required BuildContext context,
    required String message,
    required ErrorType type,
    required Duration duration,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Obtener colores del tema según el tipo
    final backgroundColor = _getBackgroundColor(colorScheme, type);
    final textColor = _getTextColor(colorScheme, type);

    // Limpiar cualquier SnackBar anterior para evitar apilamiento
    scaffoldMessengerKey.currentState?.clearSnackBars();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        elevation: theme.snackBarTheme.elevation ?? 6,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        dismissDirection: DismissDirection.down,
        action: SnackBarAction(
          label: 'OK',
          textColor: textColor,
          onPressed: () {
            scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  String? _getBackendErrorMessage(AppLocalizations l10n, String errorCode) {
    final errorMessages = {
      '001': l10n.error001,
      '002': l10n.error002,
      // ... mapear todos los códigos de error del backend
      '053': l10n.error053,
    };
    
    return errorMessages[errorCode];
  }

  Color _getBackgroundColor(ColorScheme colorScheme, ErrorType type) {
    switch (type) {
      case ErrorType.error:
        return colorScheme.error;
      case ErrorType.warning:
        return colorScheme.tertiary;
      case ErrorType.info:
        return colorScheme.primary;
      case ErrorType.success:
        return colorScheme.secondary;
    }
  }

  Color _getTextColor(ColorScheme colorScheme, ErrorType type) {
    switch (type) {
      case ErrorType.error:
        return colorScheme.onError;
      case ErrorType.warning:
        return colorScheme.onTertiary;
      case ErrorType.info:
        return colorScheme.onPrimary;
      case ErrorType.success:
        return colorScheme.onSecondary;
    }
  }
}
```

**Características:**
- **NO extiende ChangeNotifier** (es un servicio sin estado)
- Registrado con `Provider<ErrorService>` (NO ChangeNotifierProvider)
- Tiene el `GlobalKey<ScaffoldMessengerState>` para SnackBars globales
- **Todos los métodos públicos requieren BuildContext** para acceder al tema
- **Usa colores del ColorScheme del tema** (no hardcoded):
  - `ErrorType.error` → `colorScheme.error / onError`
  - `ErrorType.warning` → `colorScheme.tertiary / onTertiary`
  - `ErrorType.info` → `colorScheme.primary / onPrimary`
  - `ErrorType.success` → `colorScheme.secondary / onSecondary`
- **Usa tipografía del tema**: `theme.textTheme.bodyMedium`
- **Limpia SnackBars anteriores**: `clearSnackBars()` antes de mostrar
- **UI mejorada**:
  - Bordes redondeados (12px)
  - Padding consistente
  - Botón "OK" para cerrar
  - Dismissible hacia abajo
  - Elevation del tema o fallback a 6
- Tres métodos públicos:
  - `showBackendError(context, code, message)`: Para errores GraphQL
  - `showValidationError(context, message)`: Para formularios (warning)
  - `showError(context, message, type)`: Genérico con tipo
- Método privado `_getBackendErrorMessage()` que mapea todos los códigos de error a i18n
- Método privado `_showSnackBar()` para lógica común de SnackBar
- Métodos privados `_getBackgroundColor()` y `_getTextColor()` usan ColorScheme
- Fallback al mensaje del servidor si no hay traducción
- `ErrorType` enum con 4 valores: error, warning, info, success

### 3. GQLNotifier (Provider)

**Ubicación:** `/src/presentation/providers/gql_notifier.dart`

**Responsabilidad:** Detectar errores GraphQL y delegarlos al ErrorService

```dart
import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import '/src/infraestructure/error/error_manager.dart';
import '/src/infraestructure/config/env.dart';
import '/src/presentation/providers/auth_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class GQLNotifier extends ChangeNotifier {
  final AuthNotifier authNotifier;
  final ErrorService errorService;
  late GqlConn gqlConn;

  // Context para poder mostrar errores (se configura desde el Template)
  BuildContext? _context;
  
  void setContext(BuildContext context) {
    _context = context;
  }

  GQLNotifier({
    required this.authNotifier,
    required this.errorService,
  }) {
    Map<String, ErrorHandler> errorHandlers = {
      '001': handleSessionError,
      '002': handleGenericError,
      '003': handleGenericError,
      // ... registrar todos los códigos de error del backend
      '053': handleGenericError,
    };
    
    gqlConn = GqlConn(
      apiURL: Environment.backendApiUrl,
      errorManager: ErrorManager(handlers: errorHandlers),
      wsURL: Environment.backendApiUrlWS,
      insecure: Environment.env == EnvEnum.dev,
    );
  }

  Future<void> handleSessionError(List<GraphQLError> errors) async {
    debugPrint(
      'Session error detected: ${errors.map((e) => e.message).join(', ')}',
    );

    await authNotifier.signOut();
  }
  
  void handleGenericError(List<GraphQLError> errors) {
    for (var error in errors) {
      final code = error.extensions?['code'] as String?;
      final message = error.message;
      
      debugPrint('GraphQL Error [$code]: $message');
      
      // Mostrar error usando ErrorService
      if (_context != null && code != null) {
        errorService.showBackendError(
          context: _context!,
          errorCode: code,
          errorMessage: message,
        );
      }
    }
  }
}
```

**Características:**
- Recibe `AuthNotifier` y `ErrorService` en constructor
- Registra TODOS los códigos de error del backend en el Map
- El error 001 (sesión) tiene handler especial que hace logout
- Los demás errores usan `handleGenericError` que delega al `ErrorService`
- Método `setContext()` para guardar el contexto (llamado desde Template)

**⚠️ IMPORTANTE:**
- Cada código debe estar registrado explícitamente
- Si agregas un nuevo código del backend, debes agregarlo al Map
- El handler especial (001) NO llama al `errorService.showBackendError()` porque hace logout automático
- Necesita `ChangeNotifierProxyProvider2<AuthNotifier, ErrorService, GQLNotifier>` porque depende de un notifier y un service

### 4. Template (UI Root - Orquestador)

**Ubicación:** `/src/presentation/core/templates/main.dart`

**Responsabilidad:** Solo orquestar y conectar providers (NO lógica de errores)

**Código relevante:**

```dart
class _TemplateState extends State<Template> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authNotifier = context.read<AuthNotifier>();
    authNotifier.addListener(_onAuthChanged);

    // Configurar context para GQLNotifier
    final gqlNotifier = context.read<GQLNotifier>();
    gqlNotifier.setContext(context);
  }
  
  void _onAuthChanged() {
    final authNotifier = context.read<AuthNotifier>();

    if (!authNotifier.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/login');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String localeCode = context.watch<AppLocaleNotifier>().locale;
    final authNotifier = context.watch<AuthNotifier>();
    final errorService = context.read<ErrorService>();  // ← read, NO watch
    
    // Seleccionar router según rol...
    
    return MaterialApp.router(
      scaffoldMessengerKey: errorService.scaffoldMessengerKey,  // ← Del ErrorService
      routerConfig: router,
      // ... resto de la configuración
    );
  }
}
```

**Características:**
- NO tiene lógica de manejo de errores
- Solo configura el contexto en `GQLNotifier.setContext(context)`
- Usa el `scaffoldMessengerKey` del `ErrorService`
- Mantiene su responsabilidad de orquestar providers y routers
- Usa `context.read<ErrorService>()` (NO `watch`) porque no hay estado observable

**⚠️ IMPORTANTE:**
- El `scaffoldMessengerKey` viene de `ErrorService`, NO del Template
- El Template solo **conecta** providers, no implementa lógica
- Se usa `read` en lugar de `watch` porque ErrorService no tiene estado observable

### 5. Main App (Registro de Providers)

**Ubicación:** `/lib/main.dart`

**Responsabilidad:** Registrar todos los providers en el orden correcto

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return af.MultiProvider(
      providers: [
        af.ChangeNotifierProvider(create: (_) => AppLocaleNotifier()),
        af.ChangeNotifierProvider(create: (_) => AuthNotifier()),
        af.Provider<ErrorService>(create: (_) => ErrorService()),  // ← Provider, NO ChangeNotifierProvider
        af.ChangeNotifierProxyProvider2<AuthNotifier, ErrorService, GQLNotifier>(
          create: (context) => GQLNotifier(
            authNotifier: context.read<AuthNotifier>(),
            errorService: context.read<ErrorService>(),
          ),
          update: (context, authNotifier, errorService, previous) =>
              previous ?? GQLNotifier(
                authNotifier: authNotifier,
                errorService: errorService,
              ),
        ),
        // ... otros providers
      ],
      child: const Template(),
    );
  }
}
```

**⚠️ IMPORTANTE:**
- `ErrorService` debe registrarse ANTES de `GQLNotifier`
- Se usa `Provider<ErrorService>` (NO ChangeNotifierProvider) porque no tiene estado observable
- Usar `ChangeNotifierProxyProvider2<AuthNotifier, ErrorService, GQLNotifier>` porque `GQLNotifier` depende de un notifier y un service
- El orden es crítico: AuthNotifier → ErrorService → GQLNotifier
- ErrorService es un **servicio de infraestructura sin estado**, no un notifier

### 6. Configuración del Tema

**Ubicación:** `/src/presentation/core/themes/teal.dart` (o purple.dart)

**Responsabilidad:** Definir SnackBarTheme para errores

```dart
class TealTheme {
  ThemeData get materialTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.roboto().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        secondary: Colors.teal,
        brightness: Brightness.dark,
      ),
      brightness: Brightness.dark,
      // Configuración de SnackBar para animaciones suaves
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        actionTextColor: Colors.white,
        contentTextStyle: TextStyle(fontSize: 14),
      ),
    );
  }
}
```

**Mapeo de ErrorType a ColorScheme:**

| ErrorType | backgroundColor | textColor | Uso |
|-----------|-----------------|-----------|-----|
| `error` | `colorScheme.error` | `colorScheme.onError` | Errores de backend/GraphQL |
| `warning` | `colorScheme.tertiary` | `colorScheme.onTertiary` | Validaciones de formularios |
| `info` | `colorScheme.primary` | `colorScheme.onPrimary` | Mensajes informativos |
| `success` | `colorScheme.secondary` | `colorScheme.onSecondary` | Operaciones exitosas |

**⚠️ IMPORTANTE:**
- El `ErrorService` accede al tema mediante `Theme.of(context)`
- Por eso TODOS los métodos públicos requieren `BuildContext`
- Los colores se adaptan automáticamente al tema activo (Teal/Purple)
- Respeta dark/light mode según `brightness` del tema

**Responsabilidad:** Registrar todos los providers en el orden correcto

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return af.MultiProvider(
      providers: [
        af.ChangeNotifierProvider(create: (_) => AppLocaleNotifier()),
        af.ChangeNotifierProvider(create: (_) => AuthNotifier()),
        af.Provider<ErrorService>(create: (_) => ErrorService()),  // ← Provider, NO ChangeNotifierProvider
        af.ChangeNotifierProxyProvider2<AuthNotifier, ErrorService, GQLNotifier>(
          create: (context) => GQLNotifier(
            authNotifier: context.read<AuthNotifier>(),
            errorService: context.read<ErrorService>(),
          ),
          update: (context, authNotifier, errorService, previous) =>
              previous ?? GQLNotifier(
                authNotifier: authNotifier,
                errorService: errorService,
              ),
        ),
        // ... otros providers
      ],
      child: const Template(),
    );
  }
}
```

**⚠️ IMPORTANTE:**
- `ErrorService` debe registrarse ANTES de `GQLNotifier`
- Se usa `Provider<ErrorService>` (NO ChangeNotifierProvider) porque no tiene estado observable
- Usar `ChangeNotifierProxyProvider2<AuthNotifier, ErrorService, GQLNotifier>` porque `GQLNotifier` depende de un notifier y un service
- El orden es crítico: AuthNotifier → ErrorService → GQLNotifier
- ErrorService es un **servicio de infraestructura sin estado**, no un notifier

### 6. Internacionalización (i18n)

**Ubicación:** `/l10n/app_es.arb` y `/l10n/app_en.arb`

Cada código de error necesita una key i18n en ambos archivos:

**app_es.arb:**
```json
{
  "error001": "Usuario no ha iniciado sesión",
  "error002": "ID de entrada vacío o inválido",
  "error003": "Usuario no encontrado",
  // ... 50 más
  "error053": "Ya existe un paciente con el DNI proporcionado"
}
```

**app_en.arb:**
```json
{
  "error001": "User not logged in",
  "error002": "Empty or invalid input ID",
  "error003": "User not found",
  // ... 50 más
  "error053": "A patient with the provided DNI already exists"
}
```

**Convención de nomenclatura:**
- Formato: `error{código}` (ej: `error001`, `error014`, `error053`)
- Código siempre con 3 dígitos (padding con ceros)
- Sin prefijo de módulo (son errores globales)

**Generación:**
Después de agregar las keys, correr:
```bash
flutter gen-l10n
```

## Flujo Completo de Manejo de Errores

```
1. Mutation/Query falla en el backend
   ↓
2. Backend retorna error con código en extensions.code
   ↓
3. GqlConn detecta el error GraphQL
   ↓
4. ErrorManager.handleGraphqlError() ejecuta
   ↓
5. Busca handler para el código en el Map (GQLNotifier)
   ↓
6a. Si es código '001' (sesión):
    - Ejecuta GQLNotifier.handleSessionError()
    - Llama authNotifier.signOut()
    - Template._onAuthChanged() detecta cambio
    - Redirecciona a /login
   ↓
6b. Si es otro código (002-XXX):
    - Ejecuta GQLNotifier.handleGenericError()
    - Llama errorService.showBackendError(context, code, message)
    - ErrorService busca mensaje i18n para el código
    - ErrorService muestra SnackBar con mensaje traducido
    - SnackBar usa scaffoldMessengerKey de ErrorService
   ↓
7. Usuario ve feedback visual (logout o SnackBar)
```

**Ventajas de la Separación:**
- ✅ ErrorService es **reutilizable** (puede usarse fuera de GQL)
- ✅ ErrorService maneja **todos los tipos** de errores (backend, validación, genéricos)
- ✅ Template **solo orquesta**, no tiene lógica de errores
- ✅ GQLNotifier **solo detecta**, no renderiza UI
- ✅ Cada archivo tiene **una responsabilidad clara**
- ✅ ErrorService es un **servicio sin estado**, no un notifier

## Agregar un Nuevo Código de Error

Cuando el backend agrega un nuevo error (ej: código 054):

### 1. Registrar el handler en GQLNotifier

```dart
Map<String, ErrorHandler> errorHandlers = {
  '001': handleSessionError,
  // ... códigos existentes
  '053': handleGenericError,
  '054': handleGenericError,  // ← NUEVO
};
```

### 2. Agregar keys i18n

**app_es.arb:**
```json
{
  "error053": "Ya existe un paciente con el DNI proporcionado",
  "error054": "Nuevo mensaje de error en español"
}
```

**app_en.arb:**
```json
{
  "error053": "A patient with the provided DNI already exists",
  "error054": "New error message in English"
}
```

### 3. Mapear en ErrorService._getBackendErrorMessage()

```dart
String? _getBackendErrorMessage(AppLocalizations l10n, String errorCode) {
  final errorMessages = {
    '001': l10n.error001,
    // ... códigos existentes
    '053': l10n.error053,
    '054': l10n.error054,  // ← NUEVO
  };
  
  return errorMessages[errorCode];
}
```

### 4. Generar localizaciones

```bash
flutter gen-l10n
```

## Handlers Especiales (No Genéricos)

### handleSessionError (código 001)

Este handler es especial porque:
- NO muestra SnackBar (el usuario será redirigido a login)
- Hace `authNotifier.signOut()` para limpiar sesión
- NO llama `errorService.showBackendError()`

```dart
Future<void> handleSessionError(List<GraphQLError> errors) async {
  debugPrint(
    'Session error detected: ${errors.map((e) => e.message).join(', ')}',
  );

  await authNotifier.signOut();
  // NO llamar onShowError aquí
}
```

### Cuándo crear un handler especial

Crea un handler especial cuando el error requiere:
- Navegación automática
- Limpiar estado global
- Mostrar diálogo en lugar de SnackBar
- Logging especial
- Reintentos automáticos

**Ejemplo (código hipotético 099 - Mantenimiento):**
```dart
void handleMaintenanceError(List<GraphQLError> errors) {
  // Mostrar diálogo modal de mantenimiento
  // NO permitir cerrar el diálogo
  // NO llamar onShowError
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => MaintenanceDialog(),
  );
}
```

## Ventajas del Patrón

1. **Centralizado** - Un solo lugar para todos los errores
2. **i18n** - Mensajes traducidos automáticamente
3. **Fallback** - Usa mensaje del servidor si falta traducción
4. **Extensible** - Fácil agregar nuevos códigos o handlers especiales
5. **Consistente** - Mismo look & feel para todos los errores
6. **Separado** - UI no conoce la lógica de errores, solo muestra
7. **Type-safe** - Map tipado previene errores de código

## Checklist de Verificación

### ErrorService
- [ ] NO extiende `ChangeNotifier` (es un servicio sin estado)
- [ ] `GlobalKey<ScaffoldMessengerState>` creada como field público
- [ ] **TODOS los métodos públicos requieren BuildContext**
- [ ] Método `showBackendError(context, code, message)` para errores GraphQL
- [ ] Método `showValidationError(context, message)` para formularios
- [ ] Método `showError(context, message, type)` genérico con ErrorType
- [ ] `ErrorType` enum con 4 valores (error, warning, info, success)
- [ ] `showBackendError()` usa try-catch para i18n
- [ ] `_getBackendErrorMessage()` mapea TODOS los códigos del backend
- [ ] `_showSnackBar()` método privado con context, message, type, duration
- [ ] **Usa colores del tema**: `_getBackgroundColor(colorScheme, type)`
- [ ] **Usa colores de texto del tema**: `_getTextColor(colorScheme, type)`
- [ ] **Usa tipografía del tema**: `theme.textTheme.bodyMedium`
- [ ] **Limpia SnackBars anteriores**: `clearSnackBars()` antes de mostrar
- [ ] SnackBar flotante con `behavior: SnackBarBehavior.floating`
- [ ] Bordes redondeados (12px): `BorderRadius.circular(12)`
- [ ] Padding explícito: `EdgeInsets.symmetric(horizontal: 16, vertical: 14)`
- [ ] Margin: `EdgeInsets.all(16)`
- [ ] Elevation del tema: `theme.snackBarTheme.elevation ?? 6`
- [ ] Dismissible: `dismissDirection: DismissDirection.down`
- [ ] Botón "OK" con `SnackBarAction`
- [ ] Duración configurable (4s backend, 3s otros)
- [ ] Fallback al mensaje del servidor si no hay i18n

### GQLNotifier
- [ ] Recibe `AuthNotifier` y `ErrorService` en constructor
- [ ] Todos los códigos registrados en el Map del ErrorManager
- [ ] Error 001 usa `handleSessionError`
- [ ] Demás errores usan `handleGenericError`
- [ ] `handleGenericError` llama `errorService.showBackendError(context, code, message)`
- [ ] Verifica que `_context` existe antes de llamar
- [ ] Método `setContext()` para guardar contexto

### Template
- [ ] Llama `gqlNotifier.setContext(context)` en `didChangeDependencies`
- [ ] Usa `context.read<ErrorService>()` (NO watch - no hay estado observable)
- [ ] Usa `errorService.scaffoldMessengerKey` en MaterialApp.router
- [ ] NO tiene lógica de manejo de errores
- [ ] Solo orquesta y conecta providers

### Main App
- [ ] `ErrorService` registrado con `Provider<ErrorService>` (NO ChangeNotifierProvider)
- [ ] `ErrorService` registrado ANTES de `GQLNotifier`
- [ ] Usa `ChangeNotifierProxyProvider2<AuthNotifier, ErrorService, GQLNotifier>`
- [ ] GQLNotifier recibe authNotifier y errorService en constructor y update

### Tema (Theme)
- [ ] `SnackBarTheme` definido en ThemeData (opcional pero recomendado)
- [ ] `ColorScheme.error` y `onError` definidos
- [ ] `ColorScheme.tertiary` y `onTertiary` para warnings
- [ ] `ColorScheme.primary` y `onPrimary` para info
- [ ] `ColorScheme.secondary` y `onSecondary` para success
- [ ] `textTheme.bodyMedium` definido (tipografía del SnackBar)

### i18n
- [ ] Todas las keys en `app_es.arb`
- [ ] Todas las keys en `app_en.arb`
- [ ] Formato: `error{código}` con 3 dígitos
- [ ] `flutter gen-l10n` ejecutado sin errores
- [ ] Sin strings hardcodeados

## Próximos Patrones

- ✅ `create_pattern.chatmode.md` - Patrón para CREATE
- ✅ `read_pattern.chatmode.md` - Patrón para READ
- ✅ `error_handling_pattern.chatmode.md` - Patrón para errores ← ESTE
- 🔜 `update_pattern.chatmode.md` - Patrón para UPDATE
- 🔜 `delete_pattern.chatmode.md` - Patrón para DELETE
