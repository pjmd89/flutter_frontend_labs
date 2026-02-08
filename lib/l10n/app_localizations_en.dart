// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

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
  String get invoice => 'Invoice';

  @override
  String get invoices => 'Invoices';

  @override
  String get laboratory => 'Laboratory';

  @override
  String get selectExams => 'Select Exams';

  @override
  String get selectedExams => 'Selected Exams';

  @override
  String get noExamsSelected => 'No exams selected';

  @override
  String get searchExams => 'Search exams';

  @override
  String get selectAtLeastOneExam => 'Select at least one exam';

  @override
  String get referred => 'Referred by';

  @override
  String get cancelPayment => 'Cancel Payment';

  @override
  String get cancelPaymentQuestion => 'Cancel payment for this invoice?';

  @override
  String get markAsPaid => 'Mark as Paid';

  @override
  String get markAsPaidQuestion => 'Mark this invoice as paid?';

  @override
  String get updatePaymentStatus => 'Update Payment Status';

  @override
  String get paymentStatus => 'Payment Status';

  @override
  String get paid => 'Paid';

  @override
  String get pending => 'Pending';

  @override
  String get canceled => 'Canceled';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get orderID => 'Order ID';

  @override
  String get invoiceType => 'Invoice Type';

  @override
  String get invoiceTypeInvoice => 'Invoice';

  @override
  String get invoiceTypeCreditNote => 'Credit Note';

  @override
  String get invoiceMarkedAsPaid => 'Invoice marked as paid';

  @override
  String get paymentCanceled => 'Payment canceled successfully';

  @override
  String get billTo => 'Bill To';

  @override
  String get billToInformation => 'Payer Information';

  @override
  String get useExistingBillTo => 'Use existing payer';

  @override
  String get useExistingBillToHint => 'Search by ID number to reuse billing details';

  @override
  String get billToSearchHint => 'Enter the ID number and search to reuse a payer';

  @override
  String get billToNotFound => 'No payer found with that ID';

  @override
  String get billToSelectionRequired => 'Select an existing payer or enter the billing data';

  @override
  String get createNewPerson => 'Create New Person';

  @override
  String get selectExistingPerson => 'Select Existing Person';

  @override
  String get personForBilling => 'Person for Billing';

  @override
  String get noData => 'No data available';

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
  String get exam => 'Exam';

  @override
  String get exams => 'Exams';

  @override
  String get examTemplate => 'Exam Template';

  @override
  String get examTemplates => 'Exam Templates';

  @override
  String get evaluationPackage => 'Evaluation Package';

  @override
  String get evaluationPackages => 'Evaluation Packages';

  @override
  String get approve => 'Approve';

  @override
  String get approveEvaluationPackage => 'Approve Evaluation Package';

  @override
  String get approveEvaluationPackageConfirmation => 'Are you sure you want to approve this evaluation package? This action will register your review as a bioanalyst.';

  @override
  String get evaluationPackageApprovedSuccessfully => 'Evaluation package approved successfully';

  @override
  String get bioanalystSignature => 'Firma del Bioanalista';

  @override
  String get signature => 'Signature';

  @override
  String get changeSignature => 'Change signature';

  @override
  String get signatureUploadedSuccessfully => 'Firma subida exitosamente';

  @override
  String get fileNoExtension => 'El archivo no tiene extensión';

  @override
  String get invalidImageExtension => 'Extensión no válida. Use: jpeg, jpg, png, gif';

  @override
  String get uploadError => 'Error al subir el archivo';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get userNotAuthenticated => 'Usuario no autenticado';

  @override
  String get imageLoadError => 'Error al cargar la imagen';

  @override
  String get viewOnlyMode => 'You can only view this evaluation package. Only owners and technicians can edit the results.';

  @override
  String get bioanalystViewMode => 'As a bioanalyst, you can review the results and approve the evaluation package when it\'s complete.';

  @override
  String get markAsCompletedDescription => 'Mark that all exam results have been completed and are ready for bioanalyst review.';

  @override
  String get markAsReviewed => 'Mark as Reviewed';

  @override
  String get markAsReviewedDescription => 'Mark that you have reviewed all results of the evaluation package.';

  @override
  String get isApproved => 'Approved';

  @override
  String get approved => 'Approved';

  @override
  String get notApproved => 'Not Approved';

  @override
  String get reviewedBy => 'Reviewed by';

  @override
  String get reviewedAt => 'Review date';

  @override
  String get bioanalystReview => 'Bioanalyst Review';

  @override
  String get status => 'Status';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get generalInformation => 'General Information';

  @override
  String get creationDate => 'Creation date';

  @override
  String get viewPdf => 'View PDF';

  @override
  String get noExamsRegistered => 'No exams registered';

  @override
  String get indicatorValues => 'Indicator Values';

  @override
  String get noIndicatorValues => 'No indicator values registered';

  @override
  String get cost => 'Cost';

  @override
  String get examWithoutName => 'Exam without name';

  @override
  String get indicator => 'Indicator';

  @override
  String get observations => 'Observations';

  @override
  String get pdfFilepath => 'PDF Filepath';

  @override
  String get completedAt => 'Completed At';

  @override
  String get template => 'Template';

  @override
  String get baseCost => 'Base Cost';

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
  String get manageExamTemplates => 'Manage exam templates';

  @override
  String get reports => 'Reports';

  @override
  String get viewReports => 'View reports';

  @override
  String get taxID => 'Tax ID';

  @override
  String get logo => 'Logo';

  @override
  String get companyLogoFileName => 'company_logo';

  @override
  String get upload => 'Upload';

  @override
  String get changeLogo => 'Change logo';

  @override
  String get uploading => 'Uploading...';

  @override
  String get logoSelected => 'Logo selected';

  @override
  String get currentLogo => 'Current logo';

  @override
  String get nonEditableInformation => 'Non-editable information';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get owner => 'Owner';

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
  String thingUpdatedSuccessfully(String thing) {
    return '$thing updated successfully';
  }

  @override
  String femeThingUpdatedSuccessfully(String thing) {
    return '$thing updated successfully';
  }

  @override
  String get errorUpdating => 'Error updating';

  @override
  String get created => 'Created';

  @override
  String get updated => 'Updated';

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
  String get indicators => 'Indicators';

  @override
  String get addIndicator => 'Add indicator';

  @override
  String get loading => 'Loading...';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get search => 'Search';

  @override
  String get searchByOrderID => 'Search (filtered by order ID)';

  @override
  String get searchByReferredPackage => 'Search (filtered by package referred)';

  @override
  String get filter => 'Filter';

  @override
  String get edit => 'Edit';

  @override
  String get view => 'View';

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
  String get roleUser => 'User';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleTechnician => 'Technician';

  @override
  String get roleBilling => 'Billing';

  @override
  String get roleBioanalyst => 'Bioanalyst';

  @override
  String get roleUnknown => 'No role';

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
  String get error053 => 'A person with the provided DNI already exists';

  @override
  String get error054 => 'Invoice not found';

  @override
  String get error055 => 'Error when trying to create invoice';

  @override
  String get error056 => 'Error when trying to update invoice';

  @override
  String get error057 => 'Cannot use exams with the same template';

  @override
  String get error058 => 'Error when trying to create evaluation package';

  @override
  String get error059 => 'Evaluation package not found';

  @override
  String get error060 => 'Error when trying to update evaluation package';

  @override
  String get error061 => 'Invoice payment has already been canceled';

  @override
  String get error062 => 'Indicator #%d for input exam #%d has out of range index (%d)';

  @override
  String get error063 => 'Invalid value for indicator #%d in input exam #%d';

  @override
  String get error064 => 'Indicator #%d is duplicated for input exam #%d';

  @override
  String get error065 => 'Input exam #%d is not part of the evaluation package';

  @override
  String get error066 => 'All the exams for this evaluation package have already been completed';

  @override
  String get error067 => 'The payment for this evaluation package has been canceled. Cannot manage exam values';

  @override
  String get error068 => 'Results of exam #%d are still missing';

  @override
  String get error069 => 'Input exam #%d contains more indicator values than the exam allows';

  @override
  String get error070 => 'The number of input exams exceeds the number of exams included in the evaluation package';

  @override
  String get error071 => 'File type can\'t be blank';

  @override
  String get error072 => 'Missing employee role';

  @override
  String get error073 => 'Error when trying to create laboratory membership';

  @override
  String get error074 => 'The user is not a member of the laboratory';

  @override
  String get error075 => 'Laboratory membership not found';

  @override
  String get error076 => 'Type access not found';

  @override
  String get error077 => 'Insufficient laboratory permissions for this operation';

  @override
  String get error078 => 'Missing laboratory assignment for employee user';

  @override
  String get error079 => 'Cannot approve an evaluation package that is not completed';

  @override
  String get error080 => 'Error when trying to create person';

  @override
  String get error081 => 'Person not found';

  @override
  String get error082 => 'The patient already exists';

  @override
  String get error083 => 'Cannot update animal data for a non-animal patient';

  @override
  String get error084 => 'Error when trying to update person';

  @override
  String get error085 => 'Missing bioanalyst signature filepath';

  @override
  String get error086 => 'Generic error 86';

  @override
  String get error087 => 'Generic error 87';

  @override
  String get error088 => 'Generic error 88';

  @override
  String get error089 => 'Generic error 89';

  @override
  String get error090 => 'Generic error 90';

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
  String get searchPatient => 'Search Patient';

  @override
  String get searchByDNI => 'Search by ID Number';

  @override
  String get searchByName => 'Search by Name';

  @override
  String get selectPatient => 'Select Patient';

  @override
  String get selectPatientHint => 'Click the button to select a patient';

  @override
  String get noPatientSelected => 'No patient selected';

  @override
  String get selectFromList => 'Select from List';

  @override
  String get patientFound => 'Patient found';

  @override
  String get patientNotFound => 'Patient not found';

  @override
  String get patientNotFoundCreateFirst => 'Patient not found. Please create it first in the Patients module.';

  @override
  String get patientRequired => 'You must select a patient to create the invoice';

  @override
  String get completePatientData => 'Complete patient data';

  @override
  String get addExam => 'Add Exam';

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
  String get examsCount => 'Number of exams';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get sex => 'Sex';

  @override
  String get sexFemale => 'Female';

  @override
  String get sexMale => 'Male';

  @override
  String get sexIntersex => 'Intersex';

  @override
  String get patientType => 'Patient Type';

  @override
  String get patientTypeHuman => 'Human';

  @override
  String get patientTypeAnimal => 'Animal';

  @override
  String get deleting => 'Deleting...';

  @override
  String thingDeletedSuccessfully(String thing) {
    return '$thing deleted successfully';
  }

  @override
  String femeThingDeletedSuccessfully(String thing) {
    return '$thing deleted successfully';
  }

  @override
  String errorDeleting(String thing) {
    return 'Error deleting $thing';
  }

  @override
  String get actionIsIrreversible => 'This action is irreversible';

  @override
  String get cannotDeleteHasDependencies => 'Cannot delete because it has related records';

  @override
  String get cannotDeleteInUse => 'Cannot delete because it is in use';

  @override
  String get recordNotFound => 'Record not found';

  @override
  String get permissionDenied => 'You do not have permission to perform this action';

  @override
  String get allResultsCompleted => 'All results completed';

  @override
  String get allResultsCompletedDescription => 'Check if all exam results have been completed and verified correctly';

  @override
  String get addObservation => 'Add observation';

  @override
  String get noObservations => 'No observations recorded';

  @override
  String get observation => 'Observation';

  @override
  String get writeObservationsHere => 'Write your observations here...';

  @override
  String get examResultsNote => 'Note: Exam results are edited in their corresponding module';

  @override
  String get examResults => 'Exam results';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get remove => 'Remove';

  @override
  String get error => 'Error';

  @override
  String get close => 'Close';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get mustBePositive => 'Must be a positive number';

  @override
  String get templateDescription => 'Template description';

  @override
  String get atLeastOnePhoneRequired => 'You must add at least one contact phone';

  @override
  String get selectLaboratory => 'Select Laboratory';
}
