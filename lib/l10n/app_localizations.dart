import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  ///
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get languageEnglish;

  ///
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  ///
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get brightnessTheme;

  ///
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get brightnessLight;

  ///
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get brightnessDark;

  ///
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get date;

  ///
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  ///
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal'**
  String get somethingWentWrong;

  ///
  ///
  /// In es, this message translates to:
  /// **'Error de conexión'**
  String get connectionError;

  ///
  ///
  /// In es, this message translates to:
  /// **'Por favor, inténtelo más tarde'**
  String get pleaseTryLater;

  ///
  ///
  /// In es, this message translates to:
  /// **'Inténtalo de nuevo'**
  String get tryAgain;

  ///
  ///
  /// In es, this message translates to:
  /// **'Undefined error'**
  String get undefinedError;

  ///
  ///
  /// In es, this message translates to:
  /// **'Invalid email format'**
  String get formatEmailError;

  ///
  ///
  /// In es, this message translates to:
  /// **'Empty field'**
  String get emptyFieldError;

  /// Término para usuario en singular
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get user;

  /// Término para usuarios en plural
  ///
  /// In es, this message translates to:
  /// **'Usuarios'**
  String get users;

  /// Plantilla para crear entidad masculina/neutra. Ej: Nuevo Usuario
  ///
  /// In es, this message translates to:
  /// **'Nuevo {thing}'**
  String newThing(String thing);

  /// Plantilla para crear entidad femenina. Ej: Nueva Empresa
  ///
  /// In es, this message translates to:
  /// **'Nueva {thing}'**
  String newFemeThing(String thing);

  /// Plantilla para acción de crear. Ej: Crear Usuario
  ///
  /// In es, this message translates to:
  /// **'Crear {thing}'**
  String createThing(String thing);

  /// Plantilla para acción de actualizar. Ej: Actualizar Usuario
  ///
  /// In es, this message translates to:
  /// **'Actualizar {thing}'**
  String updateThing(String thing);

  /// Plantilla para acción de editar. Ej: Editar Usuario
  ///
  /// In es, this message translates to:
  /// **'Editar {thing}'**
  String editThing(String thing);

  /// Plantilla para acción de eliminar. Ej: Eliminar Usuario
  ///
  /// In es, this message translates to:
  /// **'Eliminar {thing}'**
  String deleteThing(String thing);

  /// Pregunta de confirmación para eliminar. Ej: ¿Está seguro de eliminar Usuario?
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de eliminar {thing}?'**
  String deleteQuestion(String thing);

  /// Mensaje cuando no hay registros (masculino/neutro). Ej: No hay Usuarios registrados
  ///
  /// In es, this message translates to:
  /// **'No hay {thing} registrados'**
  String noRegisteredMaleThings(String thing);

  /// Mensaje cuando no hay registros (femenino). Ej: No hay Empresas registradas
  ///
  /// In es, this message translates to:
  /// **'No hay {thing} registradas'**
  String noRegisteredFemaleThings(String thing);

  /// Etiqueta para campo de nombre
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// Etiqueta para campo de nombre (primer nombre)
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get firstName;

  /// Etiqueta para campo de apellido
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get lastName;

  /// Etiqueta para campo de correo electrónico
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get email;

  /// Mensaje mostrado durante carga de datos
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// Mensaje de error cuando falla la carga de datos
  ///
  /// In es, this message translates to:
  /// **'Error al cargar los datos'**
  String get errorLoadingData;

  /// Mensaje cuando no existen datos para mostrar
  ///
  /// In es, this message translates to:
  /// **'No hay datos disponibles'**
  String get noDataAvailable;

  /// Acción o etiqueta para búsqueda
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// Acción o etiqueta para filtrado
  ///
  /// In es, this message translates to:
  /// **'Filtrar'**
  String get filter;

  /// Acción para editar registro
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// Acción para eliminar registro
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// Acción para guardar cambios
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// Acción para cancelar operación
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Acción para ver laboratorios de un usuario
  ///
  /// In es, this message translates to:
  /// **'Ver laboratorios'**
  String get viewLaboratories;

  /// Acción para ver facturación de un usuario
  ///
  /// In es, this message translates to:
  /// **'Ver facturación'**
  String get viewBilling;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
