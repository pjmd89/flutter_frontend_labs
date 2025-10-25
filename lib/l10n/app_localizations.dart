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

  /// Término para empresa en singular
  ///
  /// In es, this message translates to:
  /// **'Empresa'**
  String get company;

  /// Término para empresas en plural
  ///
  /// In es, this message translates to:
  /// **'Empresas'**
  String get companies;

  /// Registro de Identificación Fiscal
  ///
  /// In es, this message translates to:
  /// **'RIF'**
  String get taxID;

  /// Logotipo de la empresa
  ///
  /// In es, this message translates to:
  /// **'Logo'**
  String get logo;

  /// Indica que un campo es opcional
  ///
  /// In es, this message translates to:
  /// **'Opcional'**
  String get optional;

  /// Título de sección para datos de empresa
  ///
  /// In es, this message translates to:
  /// **'Información de la Empresa'**
  String get companyInformation;

  /// Título de sección para datos de laboratorio
  ///
  /// In es, this message translates to:
  /// **'Información del Laboratorio'**
  String get laboratoryInformation;

  /// Dirección física
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get address;

  /// Número telefónico
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phoneNumber;

  /// Acción para agregar un número de teléfono
  ///
  /// In es, this message translates to:
  /// **'Agregar teléfono'**
  String get addPhoneNumber;

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

  /// Etiqueta para campo de rol
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get role;

  /// Rol root (superadministrador)
  ///
  /// In es, this message translates to:
  /// **'Root'**
  String get roleRoot;

  /// Rol administrador
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get roleAdmin;

  /// Rol propietario
  ///
  /// In es, this message translates to:
  /// **'Propietario'**
  String get roleOwner;

  /// Rol técnico
  ///
  /// In es, this message translates to:
  /// **'Técnico'**
  String get roleTechnician;

  /// Rol de facturación
  ///
  /// In es, this message translates to:
  /// **'Facturación'**
  String get roleBilling;

  /// Etiqueta para campo booleano de administrador
  ///
  /// In es, this message translates to:
  /// **'Es administrador'**
  String get isAdmin;

  /// Etiqueta para fecha de corte
  ///
  /// In es, this message translates to:
  /// **'Fecha de corte'**
  String get cutOffDate;

  /// Etiqueta para tarifa
  ///
  /// In es, this message translates to:
  /// **'Tarifa'**
  String get fee;

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

  /// No description provided for @error001.
  ///
  /// In es, this message translates to:
  /// **'Usuario no ha iniciado sesión'**
  String get error001;

  /// No description provided for @error002.
  ///
  /// In es, this message translates to:
  /// **'ID de entrada vacío o inválido'**
  String get error002;

  /// No description provided for @error003.
  ///
  /// In es, this message translates to:
  /// **'Usuario no encontrado'**
  String get error003;

  /// No description provided for @error004.
  ///
  /// In es, this message translates to:
  /// **'Laboratorio no encontrado'**
  String get error004;

  /// No description provided for @error005.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear el laboratorio'**
  String get error005;

  /// No description provided for @error006.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar el laboratorio'**
  String get error006;

  /// No description provided for @error007.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar el laboratorio'**
  String get error007;

  /// No description provided for @error008.
  ///
  /// In es, this message translates to:
  /// **'El laboratorio es requerido'**
  String get error008;

  /// No description provided for @error009.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con el correo electrónico proporcionado'**
  String get error009;

  /// No description provided for @error010.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una empresa con el RUC/NIT proporcionado'**
  String get error010;

  /// No description provided for @error011.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear el usuario'**
  String get error011;

  /// No description provided for @error012.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar el usuario'**
  String get error012;

  /// No description provided for @error013.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar el usuario'**
  String get error013;

  /// No description provided for @error014.
  ///
  /// In es, this message translates to:
  /// **'Falta información del propietario o de la empresa'**
  String get error014;

  /// No description provided for @error015.
  ///
  /// In es, this message translates to:
  /// **'Empresa no encontrada'**
  String get error015;

  /// No description provided for @error016.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear la empresa'**
  String get error016;

  /// No description provided for @error017.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar la empresa'**
  String get error017;

  /// No description provided for @error018.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar la empresa'**
  String get error018;

  /// No description provided for @error019.
  ///
  /// In es, this message translates to:
  /// **'Una vez que inicias sesión por primera vez, no puedes actualizar tu correo electrónico'**
  String get error019;

  /// No description provided for @error020.
  ///
  /// In es, this message translates to:
  /// **'El empleado no forma parte del laboratorio'**
  String get error020;

  /// No description provided for @error021.
  ///
  /// In es, this message translates to:
  /// **'El usuario ya ha iniciado sesión'**
  String get error021;

  /// No description provided for @error022.
  ///
  /// In es, this message translates to:
  /// **'Código de estado OIDC inválido'**
  String get error022;

  /// No description provided for @error023.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear el código de estado OIDC'**
  String get error023;

  /// No description provided for @error024.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar iniciar sesión con OIDC'**
  String get error024;

  /// No description provided for @error025.
  ///
  /// In es, this message translates to:
  /// **'Acceso denegado'**
  String get error025;

  /// No description provided for @error026.
  ///
  /// In es, this message translates to:
  /// **'Número de teléfono inválido, debe estar en formato E.164'**
  String get error026;

  /// No description provided for @error027.
  ///
  /// In es, this message translates to:
  /// **'Formato de correo electrónico inválido'**
  String get error027;

  /// No description provided for @error028.
  ///
  /// In es, this message translates to:
  /// **'Formato de fecha y hora inválido, debe ser timestamp unix'**
  String get error028;

  /// No description provided for @error029.
  ///
  /// In es, this message translates to:
  /// **'Sesión no encontrada'**
  String get error029;

  /// No description provided for @error030.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear la plantilla de examen'**
  String get error030;

  /// No description provided for @error031.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar la plantilla de examen'**
  String get error031;

  /// No description provided for @error032.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar la plantilla de examen'**
  String get error032;

  /// No description provided for @error033.
  ///
  /// In es, this message translates to:
  /// **'Plantilla de examen no encontrada'**
  String get error033;

  /// No description provided for @error034.
  ///
  /// In es, this message translates to:
  /// **'La plantilla de examen está siendo usada en uno o más exámenes de laboratorio'**
  String get error034;

  /// No description provided for @error035.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una plantilla de examen con el mismo nombre'**
  String get error035;

  /// No description provided for @error036.
  ///
  /// In es, this message translates to:
  /// **'El ID de la empresa es requerido'**
  String get error036;

  /// No description provided for @error037.
  ///
  /// In es, this message translates to:
  /// **'La dirección no puede estar vacía'**
  String get error037;

  /// No description provided for @error038.
  ///
  /// In es, this message translates to:
  /// **'El empleado ya forma parte del laboratorio'**
  String get error038;

  /// No description provided for @error039.
  ///
  /// In es, this message translates to:
  /// **'El laboratorio no tiene empleados'**
  String get error039;

  /// No description provided for @error040.
  ///
  /// In es, this message translates to:
  /// **'Examen no encontrado'**
  String get error040;

  /// No description provided for @error041.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear el examen'**
  String get error041;

  /// No description provided for @error042.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar el examen'**
  String get error042;

  /// No description provided for @error043.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar el examen'**
  String get error043;

  /// No description provided for @error044.
  ///
  /// In es, this message translates to:
  /// **'El costo base del examen debe ser un valor positivo'**
  String get error044;

  /// No description provided for @error045.
  ///
  /// In es, this message translates to:
  /// **'El examen está siendo usado en uno o más paquetes de evaluación y no puede ser eliminado'**
  String get error045;

  /// No description provided for @error046.
  ///
  /// In es, this message translates to:
  /// **'Faltan campos del paciente humano'**
  String get error046;

  /// No description provided for @error047.
  ///
  /// In es, this message translates to:
  /// **'La fecha y hora proporcionada no puede ser mayor que la hora actual'**
  String get error047;

  /// No description provided for @error048.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear el paciente'**
  String get error048;

  /// No description provided for @error049.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar el paciente'**
  String get error049;

  /// No description provided for @error050.
  ///
  /// In es, this message translates to:
  /// **'Paciente no encontrado'**
  String get error050;

  /// No description provided for @error051.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con el número de teléfono proporcionado'**
  String get error051;

  /// No description provided for @error052.
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar el paciente'**
  String get error052;

  /// No description provided for @error053.
  ///
  /// In es, this message translates to:
  /// **'Ya existe un paciente con el DNI proporcionado'**
  String get error053;
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
