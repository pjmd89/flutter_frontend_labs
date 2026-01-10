// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language => 'Idioma';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get brightnessTheme => 'Tema';

  @override
  String get brightnessLight => 'Claro';

  @override
  String get brightnessDark => 'Oscuro';

  @override
  String get date => 'Fecha';

  @override
  String get confirm => 'Confirmar';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get connectionError => 'Error de conexión';

  @override
  String get pleaseTryLater => 'Por favor, inténtelo más tarde';

  @override
  String get tryAgain => 'Inténtalo de nuevo';

  @override
  String get undefinedError => 'Undefined error';

  @override
  String get formatEmailError => 'Invalid email format';

  @override
  String get emptyFieldError => 'Empty field';

  @override
  String get user => 'Usuario';

  @override
  String get users => 'Usuarios';

  @override
  String get company => 'Empresa';

  @override
  String get companies => 'Empresas';

  @override
  String get examTemplate => 'Plantilla de Examen';

  @override
  String get examTemplates => 'Plantillas de Examen';

  @override
  String get dashboard => 'Panel de Control';

  @override
  String get welcomeToDashboard => 'Bienvenido al Panel de Control';

  @override
  String get dashboardDescription => 'Gestiona tu laboratorio desde aquí';

  @override
  String get manageUsers => 'Gestionar usuarios';

  @override
  String get manageCompanies => 'Gestionar empresas';

  @override
  String get laboratories => 'Laboratorios';

  @override
  String get manageLaboratories => 'Gestionar laboratorios';

  @override
  String get reports => 'Reportes';

  @override
  String get viewReports => 'Ver reportes';

  @override
  String get taxID => 'RIF';

  @override
  String get logo => 'Logo';

  @override
  String get owner => 'Propietario';

  @override
  String get optional => 'Opcional';

  @override
  String get add => 'Agregar';

  @override
  String get companyInformation => 'Información de la Empresa';

  @override
  String get laboratoryInformation => 'Información del Laboratorio';

  @override
  String get address => 'Dirección';

  @override
  String get phoneNumber => 'Teléfono';

  @override
  String get addPhoneNumber => 'Agregar teléfono';

  @override
  String newThing(String thing) {
    return 'Nuevo $thing';
  }

  @override
  String newFemeThing(String thing) {
    return 'Nueva $thing';
  }

  @override
  String createThing(String thing) {
    return 'Crear $thing';
  }

  @override
  String updateThing(String thing) {
    return 'Actualizar $thing';
  }

  @override
  String editThing(String thing) {
    return 'Editar $thing';
  }

  @override
  String deleteThing(String thing) {
    return 'Eliminar $thing';
  }

  @override
  String deleteQuestion(String thing) {
    return '¿Está seguro de eliminar $thing?';
  }

  @override
  String thingCreatedSuccessfully(String thing) {
    return '$thing creado exitosamente';
  }

  @override
  String femeThingCreatedSuccessfully(String thing) {
    return '$thing creada exitosamente';
  }

  @override
  String thingUpdatedSuccessfully(String thing) {
    return '$thing actualizado exitosamente';
  }

  @override
  String femeThingUpdatedSuccessfully(String thing) {
    return '$thing actualizada exitosamente';
  }

  @override
  String noRegisteredMaleThings(String thing) {
    return 'No hay $thing registrados';
  }

  @override
  String noRegisteredFemaleThings(String thing) {
    return 'No hay $thing registradas';
  }

  @override
  String noRegisteredThings(String thing) {
    return 'No hay $thing registrados';
  }

  @override
  String get name => 'Nombre';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get email => 'Correo electrónico';

  @override
  String get description => 'Descripción';

  @override
  String get valueType => 'Tipo de Valor';

  @override
  String get valueTypeNumeric => 'Numérico';

  @override
  String get valueTypeText => 'Texto';

  @override
  String get valueTypeBoolean => 'Booleano';

  @override
  String get unit => 'Unidad';

  @override
  String get normalRange => 'Rango Normal';

  @override
  String get indicator => 'Indicador';

  @override
  String get indicators => 'Indicadores';

  @override
  String get addIndicator => 'Agregar Indicador';

  @override
  String get loading => 'Cargando...';

  @override
  String get errorLoadingData => 'Error al cargar los datos';

  @override
  String get noDataAvailable => 'No hay datos disponibles';

  @override
  String get search => 'Buscar';

  @override
  String get filter => 'Filtrar';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get role => 'Rol';

  @override
  String get roleRoot => 'Root';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleOwner => 'Propietario';

  @override
  String get roleTechnician => 'Técnico';

  @override
  String get roleBilling => 'Facturación';

  @override
  String get isAdmin => 'Es administrador';

  @override
  String get cutOffDate => 'Fecha de corte';

  @override
  String get fee => 'Tarifa';

  @override
  String get viewLaboratories => 'Ver laboratorios';

  @override
  String get viewBilling => 'Ver facturación';

  @override
  String get error001 => 'Usuario no ha iniciado sesión';

  @override
  String get error002 => 'ID de entrada vacío o inválido';

  @override
  String get error003 => 'Usuario no encontrado';

  @override
  String get error004 => 'Laboratorio no encontrado';

  @override
  String get error005 => 'Error al intentar crear el laboratorio';

  @override
  String get error006 => 'Error al intentar actualizar el laboratorio';

  @override
  String get error007 => 'Error al intentar eliminar el laboratorio';

  @override
  String get error008 => 'El laboratorio es requerido';

  @override
  String get error009 => 'Ya existe una cuenta con el correo electrónico proporcionado';

  @override
  String get error010 => 'Ya existe una empresa con el RUC/NIT proporcionado';

  @override
  String get error011 => 'Error al intentar crear el usuario';

  @override
  String get error012 => 'Error al intentar actualizar el usuario';

  @override
  String get error013 => 'Error al intentar eliminar el usuario';

  @override
  String get error014 => 'Falta información del propietario o de la empresa';

  @override
  String get error015 => 'Empresa no encontrada';

  @override
  String get error016 => 'Error al intentar crear la empresa';

  @override
  String get error017 => 'Error al intentar actualizar la empresa';

  @override
  String get error018 => 'Error al intentar eliminar la empresa';

  @override
  String get error019 => 'Una vez que inicias sesión por primera vez, no puedes actualizar tu correo electrónico';

  @override
  String get error020 => 'El empleado no forma parte del laboratorio';

  @override
  String get error021 => 'El usuario ya ha iniciado sesión';

  @override
  String get error022 => 'Código de estado OIDC inválido';

  @override
  String get error023 => 'Error al intentar crear el código de estado OIDC';

  @override
  String get error024 => 'Error al intentar iniciar sesión con OIDC';

  @override
  String get error025 => 'Acceso denegado';

  @override
  String get error026 => 'Número de teléfono inválido, debe estar en formato E.164';

  @override
  String get error027 => 'Formato de correo electrónico inválido';

  @override
  String get error028 => 'Formato de fecha y hora inválido, debe ser timestamp unix';

  @override
  String get error029 => 'Sesión no encontrada';

  @override
  String get error030 => 'Error al intentar crear la plantilla de examen';

  @override
  String get error031 => 'Error al intentar actualizar la plantilla de examen';

  @override
  String get error032 => 'Error al intentar eliminar la plantilla de examen';

  @override
  String get error033 => 'Plantilla de examen no encontrada';

  @override
  String get error034 => 'La plantilla de examen está siendo usada en uno o más exámenes de laboratorio';

  @override
  String get error035 => 'Ya existe una plantilla de examen con el mismo nombre';

  @override
  String get error036 => 'El ID de la empresa es requerido';

  @override
  String get error037 => 'La dirección no puede estar vacía';

  @override
  String get error038 => 'El empleado ya forma parte del laboratorio';

  @override
  String get error039 => 'El laboratorio no tiene empleados';

  @override
  String get error040 => 'Examen no encontrado';

  @override
  String get error041 => 'Error al intentar crear el examen';

  @override
  String get error042 => 'Error al intentar actualizar el examen';

  @override
  String get error043 => 'Error al intentar eliminar el examen';

  @override
  String get error044 => 'El costo base del examen debe ser un valor positivo';

  @override
  String get error045 => 'El examen está siendo usado en uno o más paquetes de evaluación y no puede ser eliminado';

  @override
  String get error046 => 'Faltan campos del paciente humano';

  @override
  String get error047 => 'La fecha y hora proporcionada no puede ser mayor que la hora actual';

  @override
  String get error048 => 'Error al intentar crear el paciente';

  @override
  String get error049 => 'Error al intentar actualizar el paciente';

  @override
  String get error050 => 'Paciente no encontrado';

  @override
  String get error051 => 'Ya existe una cuenta con el número de teléfono proporcionado';

  @override
  String get error052 => 'Error al intentar eliminar el paciente';

  @override
  String get error053 => 'Ya existe un paciente con el DNI proporcionado';

  @override
  String get invoice => 'Factura';

  @override
  String get invoices => 'Facturas';

  @override
  String get patient => 'Paciente';

  @override
  String get patients => 'Pacientes';

  @override
  String get gender => 'Género';

  @override
  String get genderMale => 'Masculino';

  @override
  String get genderFemale => 'Femenino';

  @override
  String get species => 'Especie';

  @override
  String get speciesHuman => 'Humano';

  @override
  String get speciesCanine => 'Canino';

  @override
  String get speciesFeline => 'Felino';

  @override
  String get speciesEquine => 'Equino';

  @override
  String get speciesBovine => 'Bovino';

  @override
  String get speciesOther => 'Otro';

  @override
  String get birthDate => 'Fecha de Nacimiento';

  @override
  String get dni => 'Cédula';

  @override
  String get phone => 'Teléfono';

  @override
  String get referred => 'Referido por';

  @override
  String get totalAmount => 'Total';

  @override
  String get searchPatient => 'Buscar Paciente';

  @override
  String get searchByDNI => 'Buscar por Cédula/DNI';

  @override
  String get patientFound => 'Paciente encontrado';

  @override
  String get patientNotFound => 'Paciente no encontrado';

  @override
  String get completePatientData => 'Complete los datos del paciente';

  @override
  String get addExam => 'Agregar Examen';

  @override
  String get selectedExams => 'Exámenes Seleccionados';

  @override
  String get selectExams => 'Seleccionar Exámenes';

  @override
  String get subtotal => 'Subtotal';

  @override
  String years(int count) {
    return '$count años';
  }

  @override
  String get dniRequiredOver17 => 'Cédula obligatoria para mayores de 17 años';

  @override
  String get searchExam => 'Buscar examen...';

  @override
  String get noExamsSelected => 'No hay exámenes seleccionados';

  @override
  String examsCount(int count) {
    return '$count exámenes';
  }

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirmation => '¿Está seguro que desea cerrar sesión?';

  @override
  String get loggingOut => 'Cerrando sesión...';

  @override
  String get sex => 'Sexo';

  @override
  String get sexFemale => 'Femenino';

  @override
  String get sexMale => 'Masculino';

  @override
  String get sexIntersex => 'Intersex';

  @override
  String get laboratory => 'Laboratorio';
}
