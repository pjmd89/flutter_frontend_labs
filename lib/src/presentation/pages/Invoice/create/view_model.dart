import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/patient_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/edgepatient_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/invoice_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/edgeexam_fields_builder_extension.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/createInvoice/createinvoice_mutation.dart';
import 'package:labs/src/domain/operation/mutations/createPatient/createpatient_mutation.dart';
import 'package:labs/src/domain/operation/queries/getPatients/getpatients_query.dart';
import 'package:labs/src/domain/operation/queries/getExams/getexams_query.dart';
import 'package:labs/src/domain/usecases/Invoice/create_invoice_usecase.dart';
import 'package:labs/src/domain/usecases/Patient/create_patient_usecase.dart';
import 'package:labs/src/domain/usecases/Patient/read_patient_usecase.dart';
import 'package:labs/src/domain/usecases/Exam/read_exam_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;
  bool _searching = false;

  // Estados del paciente
  Patient? _foundPatient;
  final CreatePatientInput patientInput = CreatePatientInput(
    firstName: '',
    lastName: '',
    sex: Sex.male,
    birthDate: '',
    species: 'Humano',
    dni: '',
    phone: '',
    email: '',
    address: '',
  );

  // Estados de factura
  final CreateInvoiceInput invoiceInput = CreateInvoiceInput(
    patientID: '',
    examIDs: [],
    referred: '',
  );

  // Exámenes
  List<Exam> _availableExams = [];
  List<Exam> _selectedExams = [];

  // Getters
  bool get loading => _loading;
  bool get searching => _searching;
  Patient? get foundPatient => _foundPatient;
  List<Exam> get availableExams => _availableExams;
  List<Exam> get selectedExams => _selectedExams;

  // Setters
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set searching(bool value) {
    _searching = value;
    notifyListeners();
  }

  set foundPatient(Patient? value) {
    _foundPatient = value;
    notifyListeners();
  }

  set selectedExams(List<Exam> value) {
    _selectedExams = value;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _loadExams();
  }

  // Cargar exámenes disponibles
  Future<void> _loadExams() async {
    try {
      final query = GetExamsQuery(
        builder: EdgeExamFieldsBuilder().defaultValues(),
      );

      final useCase = ReadExamUsecase(operation: query, conn: _gqlConn);
      final response = await useCase.build();

      if (response is EdgeExam) {
        _availableExams = response.edges;
        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al cargar exámenes: $e');
      debugPrint('📍 StackTrace: $stackTrace');
    }
  }

  // Buscar paciente por DNI
  Future<void> searchPatientByDNI(String dni) async {
    if (dni.isEmpty) {
      foundPatient = null;
      return;
    }

    searching = true;

    try {
      final query = GetPatientsQuery(
        builder: EdgePatientFieldsBuilder().defaultValues(),
      );

      final useCase = ReadPatientUsecase(operation: query, conn: _gqlConn);

      // Crear SearchInput para filtrar por DNI
      final searchInputs = [
        SearchInput(
          field: 'dni',
          value: [
            ValueInput(
              value: dni,
              kind: KindEnum.string,
              operator: OperatorEnum.eq,
            ),
          ],
        ),
      ];

      final response = await useCase.search(searchInputs, null);

      if (response is EdgePatient && response.edges.isNotEmpty) {
        foundPatient = response.edges.first;
      } else {
        foundPatient = null;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al buscar paciente: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      foundPatient = null;

      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al buscar paciente: ${e.toString()}',
      );
    } finally {
      searching = false;
    }
  }

  // Calcular edad desde fecha de nacimiento
  int? calculateAge(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) return null;

    try {
      final birth = DateTime.parse(birthDate);
      final now = DateTime.now();
      int age = now.year - birth.year;
      if (now.month < birth.month ||
          (now.month == birth.month && now.day < birth.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return null;
    }
  }

  // Validar si DNI es requerido (> 17 años)
  bool isDNIRequired() {
    final age = calculateAge(patientInput.birthDate);
    return age != null && age > 17;
  }

  // Formatear teléfono: +584120612443 → +58 412-061-2443
  String formatPhoneDisplay(String phone) {
    if (phone.isEmpty) return '';

    // Remover espacios y guiones
    String cleaned = phone.replaceAll(RegExp(r'[\s-]'), '');

    // Si no empieza con +58, agregarlo
    if (!cleaned.startsWith('+58')) {
      // Remover 0 inicial si existe
      if (cleaned.startsWith('0')) {
        cleaned = cleaned.substring(1);
      }
      cleaned = '+58$cleaned';
    }

    // Formato: +58 412-061-2443
    if (cleaned.length >= 13) {
      return '${cleaned.substring(0, 3)} ${cleaned.substring(3, 6)}-${cleaned.substring(6, 9)}-${cleaned.substring(9)}';
    }

    return cleaned;
  }

  // Limpiar teléfono para enviar: +58 412-061-2443 → +584120612443
  String cleanPhoneForSubmit(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[\s-]'), '');

    if (!cleaned.startsWith('+58')) {
      if (cleaned.startsWith('0')) {
        cleaned = cleaned.substring(1);
      }
      cleaned = '+58$cleaned';
    }

    return cleaned;
  }

  // Calcular total
  num get totalAmount {
    return _selectedExams.fold(0, (sum, exam) => sum + exam.baseCost);
  }

  String get formattedTotal {
    return '\$${totalAmount.toStringAsFixed(2)}';
  }

  // Agregar/remover exámenes
  void toggleExam(Exam exam) {
    if (_selectedExams.any((e) => e.id == exam.id)) {
      _selectedExams.removeWhere((e) => e.id == exam.id);
    } else {
      _selectedExams.add(exam);
    }
    notifyListeners();
  }

  void removeExam(String examId) {
    _selectedExams.removeWhere((e) => e.id == examId);
    notifyListeners();
  }

  // Crear factura (y paciente si es necesario)
  Future<bool> createInvoice() async {
    bool isError = true;
    loading = true;

    try {
      String patientID;

      // Si no existe paciente, crearlo primero
      if (foundPatient == null) {
        // Limpiar teléfono antes de enviar
        patientInput.phone = cleanPhoneForSubmit(patientInput.phone ?? '');

        final createPatientUseCase = CreatePatientUsecase(
          operation: CreatePatientMutation(
            builder: PatientFieldsBuilder().defaultValues(),
          ),
          conn: _gqlConn,
        );

        final patientResponse = await createPatientUseCase.execute(
          input: patientInput,
        );

        if (patientResponse is Patient) {
          patientID = patientResponse.id;
        } else {
          throw Exception('Error al crear paciente');
        }
      } else {
        patientID = foundPatient!.id;
      }

      // Crear factura
      invoiceInput.patientID = patientID;
      invoiceInput.examIDs = _selectedExams.map((e) => e.id).toList();

      final createInvoiceUseCase = CreateInvoiceUsecase(
        operation: CreateInvoiceMutation(
          builder: InvoiceFieldsBuilder().defaultValues(),
        ),
        conn: _gqlConn,
      );

      final invoiceResponse = await createInvoiceUseCase.execute(
        input: invoiceInput,
      );

      if (invoiceResponse is Invoice) {
        isError = false;
      } else {
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al crear factura: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;

      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al crear factura: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
