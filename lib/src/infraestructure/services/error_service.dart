import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

/// Servicio de infraestructura para manejar la visualización de errores.
///
/// Este servicio maneja TODOS los tipos de errores de la aplicación:
/// - Errores de backend (GraphQL) con códigos específicos
/// - Errores de validación de formularios
/// - Errores genéricos de la aplicación
///
/// NO es un ChangeNotifier porque no tiene estado global que notificar.
/// Es un servicio de infraestructura puro que interactúa con el sistema
/// de notificaciones de Flutter.
class ErrorService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Muestra un error de backend con código específico.
  ///
  /// Busca el mensaje traducido en i18n usando el código.
  /// Si no encuentra traducción, usa el mensaje del servidor.
  ///
  /// Usado por: GQLNotifier cuando detecta errores GraphQL
  void showBackendError({
    required String errorCode,
    required String errorMessage,
  }) {
    String displayMessage = errorMessage;

    // Obtener el context del ScaffoldMessenger
    final context = scaffoldMessengerKey.currentContext;

    if (context != null) {
      try {
        debugPrint('🌍 Intentando obtener AppLocalizations...');
        final l10n = AppLocalizations.of(context)!;
        debugPrint('✅ AppLocalizations obtenido correctamente');
        debugPrint('🔍 Buscando traducción para código: $errorCode');

        final translatedMessage = _getBackendErrorMessage(l10n, errorCode);
        if (translatedMessage != null) {
          debugPrint('✅ Traducción encontrada: $translatedMessage');
          displayMessage = translatedMessage;
        } else {
          debugPrint(
            '⚠️ No hay traducción para código $errorCode, usando mensaje del servidor',
          );
        }
      } catch (e) {
        debugPrint('❌ Error obteniendo traducciones: $e');
        debugPrint('📝 Usando mensaje del servidor: $errorMessage');
      }
    }

    _showSnackBar(
      message: displayMessage,
      type: ErrorType.error,
      duration: const Duration(seconds: 4),
    );
  }

  /// Muestra un error de validación de formulario.
  ///
  /// Usado por: Widgets de formularios cuando fallan validaciones locales
  void showValidationError({required String message, Duration? duration}) {
    _showSnackBar(
      message: message,
      type: ErrorType.warning,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Muestra un error genérico de la aplicación.
  ///
  /// Usado por: Cualquier parte de la app que necesite mostrar errores
  void showError({
    required String message,
    ErrorType type = ErrorType.error,
    Duration? duration,
  }) {
    _showSnackBar(
      message: message,
      type: type,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Muestra el SnackBar usando el GlobalKey
  void _showSnackBar({
    required String message,
    required ErrorType type,
    required Duration duration,
  }) {
    final context = scaffoldMessengerKey.currentContext;
    if (context == null) {
      debugPrint('⚠️ No hay context disponible en ScaffoldMessenger');
      return;
    }

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
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: theme.snackBarTheme.elevation ?? 6,
        // Configuración para animación suave
        width: null, // Permite que use el ancho completo con margin
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

  /// Mapea códigos de error del backend a mensajes i18n
  String? _getBackendErrorMessage(AppLocalizations l10n, String errorCode) {
    final errorMessages = {
      '001': l10n.error001,
      '002': l10n.error002,
      '003': l10n.error003,
      '004': l10n.error004,
      '005': l10n.error005,
      '006': l10n.error006,
      '007': l10n.error007,
      '008': l10n.error008,
      '009': l10n.error009,
      '010': l10n.error010,
      '011': l10n.error011,
      '012': l10n.error012,
      '013': l10n.error013,
      '014': l10n.error014,
      '015': l10n.error015,
      '016': l10n.error016,
      '017': l10n.error017,
      '018': l10n.error018,
      '019': l10n.error019,
      '020': l10n.error020,
      '021': l10n.error021,
      '022': l10n.error022,
      '023': l10n.error023,
      '024': l10n.error024,
      '025': l10n.error025,
      '026': l10n.error026,
      '027': l10n.error027,
      '028': l10n.error028,
      '029': l10n.error029,
      '030': l10n.error030,
      '031': l10n.error031,
      '032': l10n.error032,
      '033': l10n.error033,
      '034': l10n.error034,
      '035': l10n.error035,
      '036': l10n.error036,
      '037': l10n.error037,
      '038': l10n.error038,
      '039': l10n.error039,
      '040': l10n.error040,
      '041': l10n.error041,
      '042': l10n.error042,
      '043': l10n.error043,
      '044': l10n.error044,
      '045': l10n.error045,
      '046': l10n.error046,
      '047': l10n.error047,
      '048': l10n.error048,
      '049': l10n.error049,
      '050': l10n.error050,
      '051': l10n.error051,
      '052': l10n.error052,
      '053': l10n.error053,
    };

    return errorMessages[errorCode];
  }

  /// Obtiene el color de fondo según el tipo de error
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

  /// Obtiene el color del texto según el tipo de error
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

/// Tipos de error para mensajes genéricos
enum ErrorType { error, warning, info, success }
