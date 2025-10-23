// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

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
  String noRegisteredMaleThings(String thing) {
    return 'No hay $thing registrados';
  }

  @override
  String noRegisteredFemaleThings(String thing) {
    return 'No hay $thing registradas';
  }

  @override
  String get name => 'Nombre';

  @override
  String get email => 'Correo electrónico';

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
  String get viewLaboratories => 'Ver laboratorios';

  @override
  String get viewBilling => 'Ver facturación';
}
