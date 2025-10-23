// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get brightnessTheme => 'Theme';

  @override
  String get brightnessLight => 'Light';

  @override
  String get brightnessDark => 'Dark';

  @override
  String get date => 'Date';

  @override
  String get confirm => 'Confirm';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get connectionError => 'Connection error';

  @override
  String get pleaseTryLater => 'Please try later';

  @override
  String get tryAgain => 'Inténtalo de nuevo';

  @override
  String get undefinedError => 'Undefined error';

  @override
  String get formatEmailError => 'Invalid email format';

  @override
  String get emptyFieldError => 'Empty field';

  @override
  String get user => 'User';

  @override
  String get users => 'Users';

  @override
  String newThing(String thing) {
    return 'New $thing';
  }

  @override
  String newFemeThing(String thing) {
    return 'New $thing';
  }

  @override
  String createThing(String thing) {
    return 'Create $thing';
  }

  @override
  String updateThing(String thing) {
    return 'Update $thing';
  }

  @override
  String editThing(String thing) {
    return 'Edit $thing';
  }

  @override
  String deleteThing(String thing) {
    return 'Delete $thing';
  }

  @override
  String deleteQuestion(String thing) {
    return 'Are you sure you want to delete $thing?';
  }

  @override
  String noRegisteredMaleThings(String thing) {
    return 'No $thing registered';
  }

  @override
  String noRegisteredFemaleThings(String thing) {
    return 'No $thing registered';
  }

  @override
  String get name => 'Name';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get email => 'Email';

  @override
  String get loading => 'Loading...';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get viewLaboratories => 'View laboratories';

  @override
  String get viewBilling => 'View billing';
}
