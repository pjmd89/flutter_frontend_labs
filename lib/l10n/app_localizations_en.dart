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
}
