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
  String get invoice => 'Factura';

  @override
  String get invoices => 'Facturas';

  @override
  String get laboratory => 'Laboratorio';

  @override
  String get selectExams => 'Seleccionar Exámenes';

  @override
  String get selectedExams => 'Exámenes Seleccionados';

  @override
  String get noExamsSelected => 'No hay exámenes seleccionados';

  @override
  String get searchExams => 'Buscar exámenes';

  @override
  String get selectAtLeastOneExam => 'Seleccione al menos un examen';

  @override
  String get referred => 'Referido por';

  @override
  String get cancelPayment => 'Cancelar Pago';

  @override
  String get cancelPaymentQuestion => '¿Cancelar el pago de esta factura?';

  @override
  String get markAsPaid => 'Marcar como Pagado';

  @override
  String get markAsPaidQuestion => '¿Marcar esta factura como pagada?';

  @override
  String get updatePaymentStatus => 'Actualizar Estado de Pago';

  @override
  String get paymentStatus => 'Estado de Pago';

  @override
  String get paid => 'Pagado';

  @override
  String get pending => 'Pendiente';

  @override
  String get canceled => 'Cancelado';

  @override
  String get totalAmount => 'Total';

  @override
  String get orderID => 'ID de Orden';

  @override
  String get invoiceType => 'Tipo de Factura';

  @override
  String get invoiceTypeInvoice => 'Factura';

  @override
  String get invoiceTypeCreditNote => 'Nota de Crédito';

  @override
  String get invoiceMarkedAsPaid => 'Factura marcada como pagada';

  @override
  String get paymentCanceled => 'Pago cancelado exitosamente';

  @override
  String get billTo => 'Facturar a';

  @override
  String get billToInformation => 'Información del Pagador';

  @override
  String get createNewPerson => 'Crear Nueva Persona';

  @override
  String get selectExistingPerson => 'Seleccionar Persona Existente';

  @override
  String get personForBilling => 'Persona para Facturación';

  @override
  String get noData => 'No hay datos disponibles';

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
  String get exam => 'Examen';

  @override
  String get exams => 'Exámenes';

  @override
  String get examTemplate => 'Plantilla de Examen';

  @override
  String get examTemplates => 'Plantillas de Examen';

  @override
  String get evaluationPackage => 'Paquete de Evaluación';

  @override
  String get evaluationPackages => 'Paquetes de Evaluación';

  @override
  String get approve => 'Aprobar';

  @override
  String get approveEvaluationPackage => 'Aprobar Paquete de Evaluación';

  @override
  String get approveEvaluationPackageConfirmation => '¿Está seguro de que desea aprobar este paquete de evaluación? Esta acción registrará su revisión como bioanalista.';

  @override
  String get evaluationPackageApprovedSuccessfully => 'Paquete de evaluación aprobado exitosamente';

  @override
  String get viewOnlyMode => 'Solo puedes ver este paquete de evaluación. Solo los propietarios y técnicos pueden editar los resultados.';

  @override
  String get bioanalystViewMode => 'Como bioanalista, puedes revisar los resultados y aprobar el paquete de evaluación cuando esté completo.';

  @override
  String get markAsCompletedDescription => 'Marca que todos los resultados de los exámenes han sido completados y están listos para revisión del bioanalista.';

  @override
  String get isApproved => 'Aprobado';

  @override
  String get approved => 'Aprobado';

  @override
  String get notApproved => 'No Aprobado';

  @override
  String get reviewedBy => 'Revisado por';

  @override
  String get reviewedAt => 'Fecha de revisión';

  @override
  String get bioanalystReview => 'Revisión del Bioanalista';

  @override
  String get status => 'Estado';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get statusInProgress => 'En Progreso';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusUnknown => 'Desconocido';

  @override
  String get generalInformation => 'Información General';

  @override
  String get creationDate => 'Fecha de creación';

  @override
  String get viewPdf => 'Ver PDF';

  @override
  String get noExamsRegistered => 'No hay exámenes registrados';

  @override
  String get indicatorValues => 'Valores de Indicadores';

  @override
  String get noIndicatorValues => 'No hay valores de indicadores registrados';

  @override
  String get cost => 'Costo';

  @override
  String get examWithoutName => 'Examen sin nombre';

  @override
  String get indicator => 'Indicador';

  @override
  String get observations => 'Observaciones';

  @override
  String get pdfFilepath => 'Ruta de PDF';

  @override
  String get completedAt => 'Completado el';

  @override
  String get template => 'Plantilla';

  @override
  String get baseCost => 'Costo Base';

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
  String get manageExamTemplates => 'Gestionar plantillas de examen';

  @override
  String get reports => 'Reportes';

  @override
  String get viewReports => 'Ver reportes';

  @override
  String get taxID => 'RIF';

  @override
  String get logo => 'Logo';

  @override
  String get companyLogoFileName => 'logo_empresa';

  @override
  String get upload => 'Subir';

  @override
  String get changeLogo => 'Cambiar logo';

  @override
  String get uploading => 'Subiendo...';

  @override
  String get logoSelected => 'Logo seleccionado';

  @override
  String get currentLogo => 'Logo actual';

  @override
  String get nonEditableInformation => 'Información no editable';

  @override
  String get january => 'enero';

  @override
  String get february => 'febrero';

  @override
  String get march => 'marzo';

  @override
  String get april => 'abril';

  @override
  String get may => 'mayo';

  @override
  String get june => 'junio';

  @override
  String get july => 'julio';

  @override
  String get august => 'agosto';

  @override
  String get september => 'septiembre';

  @override
  String get october => 'octubre';

  @override
  String get november => 'noviembre';

  @override
  String get december => 'diciembre';

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
  String get errorUpdating => 'Error al actualizar';

  @override
  String get created => 'Creado';

  @override
  String get updated => 'Actualizado';

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
  String get indicators => 'Indicadores';

  @override
  String get addIndicator => 'Agregar indicador';

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
  String get view => 'Ver';

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
  String get roleUser => 'Usuario';

  @override
  String get roleOwner => 'Propietario';

  @override
  String get roleTechnician => 'Técnico';

  @override
  String get roleBilling => 'Facturación';

  @override
  String get roleBioanalyst => 'Bioanalista';

  @override
  String get roleUnknown => 'Sin rol';

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
  String get error054 => 'Error genérico 54';

  @override
  String get error055 => 'Error genérico 55';

  @override
  String get error056 => 'Error genérico 56';

  @override
  String get error057 => 'Error genérico 57';

  @override
  String get error058 => 'Error genérico 58';

  @override
  String get error059 => 'Error genérico 59';

  @override
  String get error060 => 'Error genérico 60';

  @override
  String get error061 => 'Error genérico 61';

  @override
  String get error062 => 'Error genérico 62';

  @override
  String get error063 => 'Error genérico 63';

  @override
  String get error064 => 'Error genérico 64';

  @override
  String get error065 => 'Error genérico 65';

  @override
  String get error066 => 'Todos los exámenes de este paquete de evaluación ya han sido completados';

  @override
  String get error067 => 'Error genérico 67';

  @override
  String get error068 => 'Error genérico 68';

  @override
  String get error069 => 'Error genérico 69';

  @override
  String get error070 => 'Error genérico 70';

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
  String get searchPatient => 'Buscar Paciente';

  @override
  String get searchByDNI => 'Buscar por Cédula/DNI';

  @override
  String get patientFound => 'Paciente encontrado';

  @override
  String get patientNotFound => 'Paciente no encontrado';

  @override
  String get patientNotFoundCreateFirst => 'Paciente no encontrado. Por favor, créelo primero en el módulo de Pacientes.';

  @override
  String get patientRequired => 'Debe seleccionar un paciente para crear la factura';

  @override
  String get completePatientData => 'Complete los datos del paciente';

  @override
  String get addExam => 'Agregar Examen';

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
  String get examsCount => 'Cantidad de exámenes';

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
  String get patientType => 'Tipo de paciente';

  @override
  String get patientTypeHuman => 'Humano';

  @override
  String get patientTypeAnimal => 'Animal';

  @override
  String get deleting => 'Eliminando...';

  @override
  String thingDeletedSuccessfully(String thing) {
    return '$thing eliminado exitosamente';
  }

  @override
  String femeThingDeletedSuccessfully(String thing) {
    return '$thing eliminada exitosamente';
  }

  @override
  String errorDeleting(String thing) {
    return 'Error al eliminar $thing';
  }

  @override
  String get actionIsIrreversible => 'Esta acción es irreversible';

  @override
  String get cannotDeleteHasDependencies => 'No se puede eliminar porque tiene registros relacionados';

  @override
  String get cannotDeleteInUse => 'No se puede eliminar porque está en uso';

  @override
  String get recordNotFound => 'El registro no fue encontrado';

  @override
  String get permissionDenied => 'No tiene permisos para realizar esta acción';

  @override
  String get allResultsCompleted => 'Todos los resultados completados';

  @override
  String get allResultsCompletedDescription => 'Marcar si todos los resultados del examen han sido completados y verificados correctamente';

  @override
  String get addObservation => 'Agregar observación';

  @override
  String get noObservations => 'No hay observaciones registradas';

  @override
  String get observation => 'Observación';

  @override
  String get examResultsNote => 'Nota: Los resultados de exámenes se editan en su módulo correspondiente';

  @override
  String get examResults => 'Resultados de exámenes';

  @override
  String get fieldRequired => 'Este campo es requerido';

  @override
  String get remove => 'Eliminar';

  @override
  String get error => 'Error';

  @override
  String get close => 'Cerrar';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get mustBePositive => 'Debe ser un número positivo';

  @override
  String get templateDescription => 'Descripción de la plantilla';

  @override
  String get atLeastOnePhoneRequired => 'Debe agregar al menos un teléfono de contacto';

  @override
  String get selectLaboratory => 'Seleccionar Laboratorio';
}
