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
  String get company => 'Company';

  @override
  String get companies => 'Companies';

  @override
  String get examTemplate => 'Exam Template';

  @override
  String get examTemplates => 'Exam Templates';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get welcomeToDashboard => 'Welcome to Dashboard';

  @override
  String get dashboardDescription => 'Manage your laboratory from here';

  @override
  String get manageUsers => 'Manage users';

  @override
  String get manageCompanies => 'Manage companies';

  @override
  String get laboratories => 'Laboratories';

  @override
  String get manageLaboratories => 'Manage laboratories';

  @override
  String get reports => 'Reports';

  @override
  String get viewReports => 'View reports';

  @override
  String get taxID => 'Tax ID';

  @override
  String get logo => 'Logo';

  @override
  String get optional => 'Optional';

  @override
  String get add => 'Add';

  @override
  String get companyInformation => 'Company Information';

  @override
  String get laboratoryInformation => 'Laboratory Information';

  @override
  String get address => 'Address';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get addPhoneNumber => 'Add phone number';

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
  String thingCreatedSuccessfully(String thing) {
    return '$thing created successfully';
  }

  @override
  String femeThingCreatedSuccessfully(String thing) {
    return '$thing created successfully';
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
  String noRegisteredThings(String thing) {
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
  String get description => 'Description';

  @override
  String get valueType => 'Value Type';

  @override
  String get valueTypeNumeric => 'Numeric';

  @override
  String get valueTypeText => 'Text';

  @override
  String get valueTypeBoolean => 'Boolean';

  @override
  String get unit => 'Unit';

  @override
  String get normalRange => 'Normal Range';

  @override
  String get indicator => 'Indicator';

  @override
  String get indicators => 'Indicators';

  @override
  String get addIndicator => 'Add Indicator';

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
  String get role => 'Role';

  @override
  String get roleRoot => 'Root';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleTechnician => 'Technician';

  @override
  String get roleBilling => 'Billing';

  @override
  String get isAdmin => 'Is administrator';

  @override
  String get cutOffDate => 'Cut-off date';

  @override
  String get fee => 'Fee';

  @override
  String get viewLaboratories => 'View laboratories';

  @override
  String get viewBilling => 'View billing';

  @override
  String get error001 => 'User not logged in';

  @override
  String get error002 => 'Empty or invalid input ID';

  @override
  String get error003 => 'User not found';

  @override
  String get error004 => 'Laboratory not found';

  @override
  String get error005 => 'Error when trying to create laboratory';

  @override
  String get error006 => 'Error when trying to update laboratory';

  @override
  String get error007 => 'Error when trying to delete laboratory';

  @override
  String get error008 => 'Laboratory is required';

  @override
  String get error009 => 'An account already exists with the email provided';

  @override
  String get error010 => 'A company already exists with the tax ID provided';

  @override
  String get error011 => 'Error when trying to create user';

  @override
  String get error012 => 'Error when trying to update user';

  @override
  String get error013 => 'Error when trying to delete user';

  @override
  String get error014 => 'Missing owner or company info';

  @override
  String get error015 => 'Company not found';

  @override
  String get error016 => 'Error when trying to create company';

  @override
  String get error017 => 'Error when trying to update company';

  @override
  String get error018 => 'Error when trying to delete company';

  @override
  String get error019 => 'Once you log in for the first time, you cannot update your email';

  @override
  String get error020 => 'The employee is not part of the laboratory';

  @override
  String get error021 => 'User already logged in';

  @override
  String get error022 => 'Invalid OIDC state code';

  @override
  String get error023 => 'Error when trying to create OIDC state code';

  @override
  String get error024 => 'Error when trying to log in with OIDC';

  @override
  String get error025 => 'Access denied';

  @override
  String get error026 => 'Invalid phone number, must be in E.164 format';

  @override
  String get error027 => 'Invalid email format';

  @override
  String get error028 => 'Invalid date time format, must be unix timestamp';

  @override
  String get error029 => 'Session not found';

  @override
  String get error030 => 'Error when trying to create exam template';

  @override
  String get error031 => 'Error when trying to update exam template';

  @override
  String get error032 => 'Error when trying to delete exam template';

  @override
  String get error033 => 'Exam template not found';

  @override
  String get error034 => 'The exam template is being used in one or more laboratory exams';

  @override
  String get error035 => 'An exam template with the same name already exists';

  @override
  String get error036 => 'Company ID is required';

  @override
  String get error037 => 'Address cannot be empty';

  @override
  String get error038 => 'The employee is already part of the laboratory';

  @override
  String get error039 => 'The laboratory has no employees';

  @override
  String get error040 => 'Exam not found';

  @override
  String get error041 => 'Error when trying to create exam';

  @override
  String get error042 => 'Error when trying to update exam';

  @override
  String get error043 => 'Error when trying to delete exam';

  @override
  String get error044 => 'Exam base cost must be a positive value';

  @override
  String get error045 => 'The exam is being used in one or more evaluation packages and cannot be deleted';

  @override
  String get error046 => 'Missing human patient fields';

  @override
  String get error047 => 'The date time provided cannot be greater than the current time';

  @override
  String get error048 => 'Error when trying to create patient';

  @override
  String get error049 => 'Error when trying to update patient';

  @override
  String get error050 => 'Patient not found';

  @override
  String get error051 => 'An account already exists with the phone number provided';

  @override
  String get error052 => 'Error when trying to delete patient';

  @override
  String get error053 => 'A patient with the provided DNI already exists';

  @override
  String get invoice => 'Invoice';

  @override
  String get invoices => 'Invoices';

  @override
  String get patient => 'Patient';

  @override
  String get patients => 'Patients';

  @override
  String get gender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get species => 'Species';

  @override
  String get speciesHuman => 'Human';

  @override
  String get speciesCanine => 'Canine';

  @override
  String get speciesFeline => 'Feline';

  @override
  String get speciesEquine => 'Equine';

  @override
  String get speciesBovine => 'Bovine';

  @override
  String get speciesOther => 'Other';

  @override
  String get birthDate => 'Birth Date';

  @override
  String get dni => 'ID Number';

  @override
  String get phone => 'Phone';

  @override
  String get referred => 'Referred by';

  @override
  String get totalAmount => 'Total';

  @override
  String get searchPatient => 'Search Patient';

  @override
  String get searchByDNI => 'Search by ID Number';

  @override
  String get patientFound => 'Patient found';

  @override
  String get patientNotFound => 'Patient not found';

  @override
  String get completePatientData => 'Complete patient data';

  @override
  String get addExam => 'Add Exam';

  @override
  String get selectedExams => 'Selected Exams';

  @override
  String get selectExams => 'Select Exams';

  @override
  String get subtotal => 'Subtotal';

  @override
  String years(int count) {
    return '$count years';
  }

  @override
  String get dniRequiredOver17 => 'ID required for patients over 17 years old';

  @override
  String get searchExam => 'Search exam...';

  @override
  String get noExamsSelected => 'No exams selected';

  @override
  String examsCount(int count) {
    return '$count exams';
  }
}
