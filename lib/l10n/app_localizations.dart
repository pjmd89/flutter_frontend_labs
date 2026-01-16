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
  /// **'Idioma'**
  String get language;

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

  /// Factura singular
  ///
  /// In es, this message translates to:
  /// **'Factura'**
  String get invoice;

  /// Facturas plural
  ///
  /// In es, this message translates to:
  /// **'Facturas'**
  String get invoices;

  /// Campo de laboratorio
  ///
  /// In es, this message translates to:
  /// **'Laboratorio'**
  String get laboratory;

  /// Título del modal de selección
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Exámenes'**
  String get selectExams;

  /// Título de sección de exámenes
  ///
  /// In es, this message translates to:
  /// **'Exámenes Seleccionados'**
  String get selectedExams;

  /// Mensaje cuando no se han seleccionado exámenes
  ///
  /// In es, this message translates to:
  /// **'No hay exámenes seleccionados'**
  String get noExamsSelected;

  /// Placeholder para campo de búsqueda de exámenes
  ///
  /// In es, this message translates to:
  /// **'Buscar exámenes'**
  String get searchExams;

  /// Mensaje de validación para selección de exámenes
  ///
  /// In es, this message translates to:
  /// **'Seleccione al menos un examen'**
  String get selectAtLeastOneExam;

  /// Persona o entidad que refirió al paciente
  ///
  /// In es, this message translates to:
  /// **'Referido por'**
  String get referred;

  /// Acción para cancelar pago
  ///
  /// In es, this message translates to:
  /// **'Cancelar Pago'**
  String get cancelPayment;

  /// Pregunta de confirmación para cancelación de pago
  ///
  /// In es, this message translates to:
  /// **'¿Cancelar el pago de esta factura?'**
  String get cancelPaymentQuestion;

  /// Etiqueta para campo de estado de pago
  ///
  /// In es, this message translates to:
  /// **'Estado de Pago'**
  String get paymentStatus;

  /// Estado de pago: pagado
  ///
  /// In es, this message translates to:
  /// **'Pagado'**
  String get paid;

  /// Estado de pago: cancelado
  ///
  /// In es, this message translates to:
  /// **'Cancelado'**
  String get canceled;

  /// Monto total de la factura
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get totalAmount;

  /// Etiqueta para ID de orden
  ///
  /// In es, this message translates to:
  /// **'ID de Orden'**
  String get orderID;

  /// Mensaje cuando no hay datos para mostrar
  ///
  /// In es, this message translates to:
  /// **'No hay datos disponibles'**
  String get noData;

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

  /// Término para examen en singular
  ///
  /// In es, this message translates to:
  /// **'Examen'**
  String get exam;

  /// Término para exámenes en plural
  ///
  /// In es, this message translates to:
  /// **'Exámenes'**
  String get exams;

  /// Término para plantilla de examen en singular
  ///
  /// In es, this message translates to:
  /// **'Plantilla de Examen'**
  String get examTemplate;

  /// Término para plantillas de examen en plural
  ///
  /// In es, this message translates to:
  /// **'Plantillas de Examen'**
  String get examTemplates;

  /// Término para paquete de evaluación en singular
  ///
  /// In es, this message translates to:
  /// **'Paquete de Evaluación'**
  String get evaluationPackage;

  /// Término para paquetes de evaluación en plural
  ///
  /// In es, this message translates to:
  /// **'Paquetes de Evaluación'**
  String get evaluationPackages;

  /// Campo de estado general
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get status;

  /// Campo de observaciones o notas
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get observations;

  /// Campo de ruta del archivo PDF
  ///
  /// In es, this message translates to:
  /// **'Ruta de PDF'**
  String get pdfFilepath;

  /// Fecha de completado
  ///
  /// In es, this message translates to:
  /// **'Completado el'**
  String get completedAt;

  /// Campo template
  ///
  /// In es, this message translates to:
  /// **'Plantilla'**
  String get template;

  /// Campo baseCost para el costo base de un examen
  ///
  /// In es, this message translates to:
  /// **'Costo Base'**
  String get baseCost;

  /// Título del panel de control principal
  ///
  /// In es, this message translates to:
  /// **'Panel de Control'**
  String get dashboard;

  /// Mensaje de bienvenida en el dashboard
  ///
  /// In es, this message translates to:
  /// **'Bienvenido al Panel de Control'**
  String get welcomeToDashboard;

  /// Descripción del dashboard
  ///
  /// In es, this message translates to:
  /// **'Gestiona tu laboratorio desde aquí'**
  String get dashboardDescription;

  /// Descripción para la tarjeta de usuarios
  ///
  /// In es, this message translates to:
  /// **'Gestionar usuarios'**
  String get manageUsers;

  /// Descripción para la tarjeta de empresas
  ///
  /// In es, this message translates to:
  /// **'Gestionar empresas'**
  String get manageCompanies;

  /// Término para laboratorios en plural
  ///
  /// In es, this message translates to:
  /// **'Laboratorios'**
  String get laboratories;

  /// Descripción para la tarjeta de laboratorios
  ///
  /// In es, this message translates to:
  /// **'Gestionar laboratorios'**
  String get manageLaboratories;

  /// Término para reportes en plural
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get reports;

  /// Descripción para la tarjeta de reportes
  ///
  /// In es, this message translates to:
  /// **'Ver reportes'**
  String get viewReports;

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

  /// Propietario de la empresa
  ///
  /// In es, this message translates to:
  /// **'Propietario'**
  String get owner;

  /// Indica que un campo es opcional
  ///
  /// In es, this message translates to:
  /// **'Opcional'**
  String get optional;

  /// Acción de agregar elemento
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get add;

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

  /// Mensaje de éxito al crear (masculino/neutro). Ej: Usuario creado exitosamente
  ///
  /// In es, this message translates to:
  /// **'{thing} creado exitosamente'**
  String thingCreatedSuccessfully(String thing);

  /// Mensaje de éxito al crear (femenino). Ej: Empresa creada exitosamente
  ///
  /// In es, this message translates to:
  /// **'{thing} creada exitosamente'**
  String femeThingCreatedSuccessfully(String thing);

  /// Mensaje de éxito al actualizar (masculino/neutro). Ej: Usuario actualizado exitosamente
  ///
  /// In es, this message translates to:
  /// **'{thing} actualizado exitosamente'**
  String thingUpdatedSuccessfully(String thing);

  /// Mensaje de éxito al actualizar (femenino). Ej: Empresa actualizada exitosamente
  ///
  /// In es, this message translates to:
  /// **'{thing} actualizada exitosamente'**
  String femeThingUpdatedSuccessfully(String thing);

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

  /// Mensaje cuando no hay registros (genérico). Ej: No hay Indicadores registrados
  ///
  /// In es, this message translates to:
  /// **'No hay {thing} registrados'**
  String noRegisteredThings(String thing);

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

  /// Etiqueta para campo de descripción
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// Etiqueta para campo de tipo de valor
  ///
  /// In es, this message translates to:
  /// **'Tipo de Valor'**
  String get valueType;

  /// Tipo de valor numérico
  ///
  /// In es, this message translates to:
  /// **'Numérico'**
  String get valueTypeNumeric;

  /// Tipo de valor de texto
  ///
  /// In es, this message translates to:
  /// **'Texto'**
  String get valueTypeText;

  /// Tipo de valor booleano
  ///
  /// In es, this message translates to:
  /// **'Booleano'**
  String get valueTypeBoolean;

  /// Etiqueta para campo de unidad de medida
  ///
  /// In es, this message translates to:
  /// **'Unidad'**
  String get unit;

  /// Etiqueta para campo de rango normal
  ///
  /// In es, this message translates to:
  /// **'Rango Normal'**
  String get normalRange;

  /// Término para indicador en singular
  ///
  /// In es, this message translates to:
  /// **'Indicador'**
  String get indicator;

  /// Término para indicadores en plural
  ///
  /// In es, this message translates to:
  /// **'Indicadores'**
  String get indicators;

  /// Botón para agregar nuevo indicador
  ///
  /// In es, this message translates to:
  /// **'Agregar indicador'**
  String get addIndicator;

  /// Mensaje mostrado durante carga de datos
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// Mensaje de error al cargar datos
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

  /// Error cuando la sesión del usuario no es válida o ha expirado
  ///
  /// In es, this message translates to:
  /// **'Usuario no ha iniciado sesión'**
  String get error001;

  /// Error cuando el ID proporcionado está vacío o no es válido
  ///
  /// In es, this message translates to:
  /// **'ID de entrada vacío o inválido'**
  String get error002;

  /// Error cuando no se encuentra un usuario específico en el sistema
  ///
  /// In es, this message translates to:
  /// **'Usuario no encontrado'**
  String get error003;

  /// Error cuando no se encuentra un laboratorio específico en el sistema
  ///
  /// In es, this message translates to:
  /// **'Laboratorio no encontrado'**
  String get error004;

  /// Error que ocurre durante el proceso de creación de un laboratorio
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear el laboratorio'**
  String get error005;

  /// Error que ocurre durante el proceso de actualización de un laboratorio
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar el laboratorio'**
  String get error006;

  /// Error que ocurre durante el proceso de eliminación de un laboratorio
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar el laboratorio'**
  String get error007;

  /// Error de validación cuando el campo laboratorio es obligatorio
  ///
  /// In es, this message translates to:
  /// **'El laboratorio es requerido'**
  String get error008;

  /// Error cuando se intenta crear una cuenta con un correo electrónico ya existente
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con el correo electrónico proporcionado'**
  String get error009;

  /// Error cuando se intenta crear una empresa con un RUC/NIT ya existente
  ///
  /// In es, this message translates to:
  /// **'Ya existe una empresa con el RUC/NIT proporcionado'**
  String get error010;

  /// Error que ocurre durante el proceso de creación de un usuario
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear el usuario'**
  String get error011;

  /// Error que ocurre durante el proceso de actualización de un usuario
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar el usuario'**
  String get error012;

  /// Error que ocurre durante el proceso de eliminación de un usuario
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar el usuario'**
  String get error013;

  /// Error cuando faltan datos obligatorios del propietario o empresa
  ///
  /// In es, this message translates to:
  /// **'Falta información del propietario o de la empresa'**
  String get error014;

  /// Error cuando no se encuentra una empresa específica en el sistema
  ///
  /// In es, this message translates to:
  /// **'Empresa no encontrada'**
  String get error015;

  /// Error que ocurre durante el proceso de creación de una empresa
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear la empresa'**
  String get error016;

  /// Error que ocurre durante el proceso de actualización de una empresa
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar la empresa'**
  String get error017;

  /// Error que ocurre durante el proceso de eliminación de una empresa
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar la empresa'**
  String get error018;

  /// Error cuando se intenta actualizar el correo electrónico después del primer inicio de sesión
  ///
  /// In es, this message translates to:
  /// **'Una vez que inicias sesión por primera vez, no puedes actualizar tu correo electrónico'**
  String get error019;

  /// Error cuando un empleado no está asociado con el laboratorio especificado
  ///
  /// In es, this message translates to:
  /// **'El empleado no forma parte del laboratorio'**
  String get error020;

  /// Error cuando un usuario intenta iniciar sesión pero ya tiene una sesión activa
  ///
  /// In es, this message translates to:
  /// **'El usuario ya ha iniciado sesión'**
  String get error021;

  /// Error cuando el código de estado OIDC proporcionado no es válido
  ///
  /// In es, this message translates to:
  /// **'Código de estado OIDC inválido'**
  String get error022;

  /// Error que ocurre durante la creación del código de estado OIDC
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear el código de estado OIDC'**
  String get error023;

  /// Error que ocurre durante el proceso de autenticación OIDC
  ///
  /// In es, this message translates to:
  /// **'Error al intentar iniciar sesión con OIDC'**
  String get error024;

  /// Error cuando un usuario no tiene permisos para acceder a un recurso
  ///
  /// In es, this message translates to:
  /// **'Acceso denegado'**
  String get error025;

  /// Error de validación cuando el número de teléfono no está en formato E.164
  ///
  /// In es, this message translates to:
  /// **'Número de teléfono inválido, debe estar en formato E.164'**
  String get error026;

  /// Error de validación cuando el formato del correo electrónico es inválido
  ///
  /// In es, this message translates to:
  /// **'Formato de correo electrónico inválido'**
  String get error027;

  /// Error de validación cuando el formato de fecha/hora no es un timestamp unix válido
  ///
  /// In es, this message translates to:
  /// **'Formato de fecha y hora inválido, debe ser timestamp unix'**
  String get error028;

  /// Error cuando no se encuentra una sesión específica en el sistema
  ///
  /// In es, this message translates to:
  /// **'Sesión no encontrada'**
  String get error029;

  /// Error que ocurre durante el proceso de creación de una plantilla de examen
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear la plantilla de examen'**
  String get error030;

  /// Error que ocurre durante el proceso de actualización de una plantilla de examen
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar la plantilla de examen'**
  String get error031;

  /// Error que ocurre durante el proceso de eliminación de una plantilla de examen
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar la plantilla de examen'**
  String get error032;

  /// Error cuando no se encuentra una plantilla de examen específica en el sistema
  ///
  /// In es, this message translates to:
  /// **'Plantilla de examen no encontrada'**
  String get error033;

  /// Error cuando se intenta eliminar una plantilla de examen que está siendo utilizada
  ///
  /// In es, this message translates to:
  /// **'La plantilla de examen está siendo usada en uno o más exámenes de laboratorio'**
  String get error034;

  /// Error cuando se intenta crear una plantilla de examen con un nombre duplicado
  ///
  /// In es, this message translates to:
  /// **'Ya existe una plantilla de examen con el mismo nombre'**
  String get error035;

  /// Error de validación cuando el ID de empresa es un campo obligatorio
  ///
  /// In es, this message translates to:
  /// **'El ID de la empresa es requerido'**
  String get error036;

  /// Error de validación cuando el campo dirección está vacío y es obligatorio
  ///
  /// In es, this message translates to:
  /// **'La dirección no puede estar vacía'**
  String get error037;

  /// Error cuando un empleado ya está asociado con el laboratorio especificado
  ///
  /// In es, this message translates to:
  /// **'El empleado ya forma parte del laboratorio'**
  String get error038;

  /// Error cuando un laboratorio no tiene empleados asociados
  ///
  /// In es, this message translates to:
  /// **'El laboratorio no tiene empleados'**
  String get error039;

  /// Error cuando no se encuentra un examen específico en el sistema
  ///
  /// In es, this message translates to:
  /// **'Examen no encontrado'**
  String get error040;

  /// Error que ocurre durante el proceso de creación de un examen
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear el examen'**
  String get error041;

  /// Error que ocurre durante el proceso de actualización de un examen
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar el examen'**
  String get error042;

  /// Error que ocurre durante el proceso de eliminación de un examen
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar el examen'**
  String get error043;

  /// Error de validación cuando el costo base del examen no es un valor positivo
  ///
  /// In es, this message translates to:
  /// **'El costo base del examen debe ser un valor positivo'**
  String get error044;

  /// Error cuando se intenta eliminar un examen que está siendo utilizado en paquetes
  ///
  /// In es, this message translates to:
  /// **'El examen está siendo usado en uno o más paquetes de evaluación y no puede ser eliminado'**
  String get error045;

  /// Error de validación cuando faltan campos obligatorios del paciente humano
  ///
  /// In es, this message translates to:
  /// **'Faltan campos del paciente humano'**
  String get error046;

  /// Error de validación cuando la fecha/hora proporcionada es mayor que la actual
  ///
  /// In es, this message translates to:
  /// **'La fecha y hora proporcionada no puede ser mayor que la hora actual'**
  String get error047;

  /// Error que ocurre durante el proceso de creación de un paciente
  ///
  /// In es, this message translates to:
  /// **'Error al intentar crear el paciente'**
  String get error048;

  /// Error que ocurre durante el proceso de actualización de un paciente
  ///
  /// In es, this message translates to:
  /// **'Error al intentar actualizar el paciente'**
  String get error049;

  /// Error cuando no se encuentra un paciente específico en el sistema
  ///
  /// In es, this message translates to:
  /// **'Paciente no encontrado'**
  String get error050;

  /// Error cuando se intenta crear una cuenta con un número de teléfono ya existente
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con el número de teléfono proporcionado'**
  String get error051;

  /// Error que ocurre durante el proceso de eliminación de un paciente
  ///
  /// In es, this message translates to:
  /// **'Error al intentar eliminar el paciente'**
  String get error052;

  /// Error cuando se intenta crear un paciente con un DNI ya existente
  ///
  /// In es, this message translates to:
  /// **'Ya existe un paciente con el DNI proporcionado'**
  String get error053;

  /// Paciente singular
  ///
  /// In es, this message translates to:
  /// **'Paciente'**
  String get patient;

  /// Pacientes plural
  ///
  /// In es, this message translates to:
  /// **'Pacientes'**
  String get patients;

  /// Género del paciente
  ///
  /// In es, this message translates to:
  /// **'Género'**
  String get gender;

  /// Género masculino
  ///
  /// In es, this message translates to:
  /// **'Masculino'**
  String get genderMale;

  /// Género femenino
  ///
  /// In es, this message translates to:
  /// **'Femenino'**
  String get genderFemale;

  /// Especie del paciente
  ///
  /// In es, this message translates to:
  /// **'Especie'**
  String get species;

  /// Especie humana
  ///
  /// In es, this message translates to:
  /// **'Humano'**
  String get speciesHuman;

  /// Especie canina
  ///
  /// In es, this message translates to:
  /// **'Canino'**
  String get speciesCanine;

  /// Especie felina
  ///
  /// In es, this message translates to:
  /// **'Felino'**
  String get speciesFeline;

  /// Especie equina
  ///
  /// In es, this message translates to:
  /// **'Equino'**
  String get speciesEquine;

  /// Especie bovina
  ///
  /// In es, this message translates to:
  /// **'Bovino'**
  String get speciesBovine;

  /// Otra especie
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get speciesOther;

  /// Fecha de nacimiento del paciente
  ///
  /// In es, this message translates to:
  /// **'Fecha de Nacimiento'**
  String get birthDate;

  /// Documento de identidad
  ///
  /// In es, this message translates to:
  /// **'Cédula'**
  String get dni;

  /// Número de teléfono
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phone;

  /// Buscar paciente por cédula
  ///
  /// In es, this message translates to:
  /// **'Buscar Paciente'**
  String get searchPatient;

  /// Placeholder para búsqueda por documento
  ///
  /// In es, this message translates to:
  /// **'Buscar por Cédula/DNI'**
  String get searchByDNI;

  /// Mensaje cuando se encuentra un paciente
  ///
  /// In es, this message translates to:
  /// **'Paciente encontrado'**
  String get patientFound;

  /// Mensaje cuando no se encuentra un paciente
  ///
  /// In es, this message translates to:
  /// **'Paciente no encontrado'**
  String get patientNotFound;

  /// Mensaje cuando no se encuentra un paciente y debe crearlo primero
  ///
  /// In es, this message translates to:
  /// **'Paciente no encontrado. Por favor, créelo primero en el módulo de Pacientes.'**
  String get patientNotFoundCreateFirst;

  /// Mensaje de validación cuando no se ha seleccionado un paciente
  ///
  /// In es, this message translates to:
  /// **'Debe seleccionar un paciente para crear la factura'**
  String get patientRequired;

  /// Instrucción para completar formulario de paciente
  ///
  /// In es, this message translates to:
  /// **'Complete los datos del paciente'**
  String get completePatientData;

  /// Botón para agregar examen
  ///
  /// In es, this message translates to:
  /// **'Agregar Examen'**
  String get addExam;

  /// Subtotal de la factura
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Cantidad de años de edad
  ///
  /// In es, this message translates to:
  /// **'{count} años'**
  String years(int count);

  /// Mensaje de validación de cédula
  ///
  /// In es, this message translates to:
  /// **'Cédula obligatoria para mayores de 17 años'**
  String get dniRequiredOver17;

  /// Placeholder de búsqueda de exámenes
  ///
  /// In es, this message translates to:
  /// **'Buscar examen...'**
  String get searchExam;

  /// Label para mostrar cantidad de exámenes
  ///
  /// In es, this message translates to:
  /// **'Cantidad de exámenes'**
  String get examsCount;

  /// Cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// Confirmación de cierre de sesión
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro que desea cerrar sesión?'**
  String get logoutConfirmation;

  /// Mensaje durante logout
  ///
  /// In es, this message translates to:
  /// **'Cerrando sesión...'**
  String get loggingOut;

  /// Campo de sexo
  ///
  /// In es, this message translates to:
  /// **'Sexo'**
  String get sex;

  /// Sexo femenino
  ///
  /// In es, this message translates to:
  /// **'Femenino'**
  String get sexFemale;

  /// Sexo masculino
  ///
  /// In es, this message translates to:
  /// **'Masculino'**
  String get sexMale;

  /// Sexo intersex
  ///
  /// In es, this message translates to:
  /// **'Intersex'**
  String get sexIntersex;

  /// Tipo de paciente
  ///
  /// In es, this message translates to:
  /// **'Tipo de paciente'**
  String get patientType;

  /// Tipo de paciente humano
  ///
  /// In es, this message translates to:
  /// **'Humano'**
  String get patientTypeHuman;

  /// Tipo de paciente animal
  ///
  /// In es, this message translates to:
  /// **'Animal'**
  String get patientTypeAnimal;

  /// Mensaje durante operación de eliminación
  ///
  /// In es, this message translates to:
  /// **'Eliminando...'**
  String get deleting;

  /// Mensaje de éxito al eliminar (masculino/neutro). Ej: Usuario eliminado exitosamente
  ///
  /// In es, this message translates to:
  /// **'{thing} eliminado exitosamente'**
  String thingDeletedSuccessfully(String thing);

  /// Mensaje de éxito al eliminar (femenino). Ej: Empresa eliminada exitosamente
  ///
  /// In es, this message translates to:
  /// **'{thing} eliminada exitosamente'**
  String femeThingDeletedSuccessfully(String thing);

  /// Mensaje de error al eliminar. Ej: Error al eliminar Usuario
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar {thing}'**
  String errorDeleting(String thing);

  /// Advertencia de que la acción no se puede deshacer
  ///
  /// In es, this message translates to:
  /// **'Esta acción es irreversible'**
  String get actionIsIrreversible;

  /// Error cuando se intenta eliminar registro con dependencias
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar porque tiene registros relacionados'**
  String get cannotDeleteHasDependencies;

  /// Error cuando se intenta eliminar registro que está siendo usado
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar porque está en uso'**
  String get cannotDeleteInUse;

  /// Error cuando el registro no existe
  ///
  /// In es, this message translates to:
  /// **'El registro no fue encontrado'**
  String get recordNotFound;

  /// Error cuando el usuario no tiene permisos
  ///
  /// In es, this message translates to:
  /// **'No tiene permisos para realizar esta acción'**
  String get permissionDenied;

  /// Título para sección de campos de solo lectura
  ///
  /// In es, this message translates to:
  /// **'Información no editable'**
  String get nonEditableInformation;

  /// Label para switch de completitud de resultados
  ///
  /// In es, this message translates to:
  /// **'Todos los resultados completados'**
  String get allResultsCompleted;

  /// Descripción para switch de completitud
  ///
  /// In es, this message translates to:
  /// **'Marcar si todos los resultados del examen han sido completados'**
  String get allResultsCompletedDescription;

  /// Botón para agregar nueva observación
  ///
  /// In es, this message translates to:
  /// **'Agregar observación'**
  String get addObservation;

  /// Mensaje cuando no hay observaciones
  ///
  /// In es, this message translates to:
  /// **'No hay observaciones registradas'**
  String get noObservations;

  /// Label para campo de observación
  ///
  /// In es, this message translates to:
  /// **'Observación'**
  String get observation;

  /// Nota informativa sobre resultados de exámenes
  ///
  /// In es, this message translates to:
  /// **'Nota: Los resultados de exámenes se editan en su módulo correspondiente'**
  String get examResultsNote;

  /// Título de sección de resultados
  ///
  /// In es, this message translates to:
  /// **'Resultados de exámenes'**
  String get examResults;

  /// Mensaje de validación de campo requerido
  ///
  /// In es, this message translates to:
  /// **'Este campo es requerido'**
  String get fieldRequired;

  /// Botón para eliminar
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get remove;

  /// Palabra genérica para error
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// Botón para cerrar
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;
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
