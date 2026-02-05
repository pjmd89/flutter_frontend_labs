import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/invoice_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/edgeexam_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/edgepatient_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/person_fields_builder_extension.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/createInvoice/createinvoice_mutation.dart';
import 'package:labs/src/domain/operation/mutations/createPerson/createperson_mutation.dart';
import 'package:labs/src/domain/operation/queries/getPatients/getpatients_query.dart';
import 'package:labs/src/domain/operation/queries/getExams/getexams_query.dart';
import 'package:labs/src/domain/usecases/Invoice/create_invoice_usecase.dart';
import 'package:labs/src/domain/usecases/Patient/read_patient_usecase.dart';
import 'package:labs/src/domain/usecases/Exam/read_exam_usecase.dart';
import 'package:labs/src/domain/usecases/Person/create_person_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;
  bool _searching = false;

  // Estado del paciente
  Patient? _foundPatient;

  // Estados de factura
  final CreateInvoiceInput invoiceInput = CreateInvoiceInput(
    patient: '',
    examIDs: [],
    referred: '',
    kind: InvoiceKind.iNVOICE,
    billTo: '',
  );

  // Input para crear persona (billTo)
  final CreatePersonInput personInput = CreatePersonInput(
    firstName: '',
    lastName: '',
    dni: '',
  );

  // Exámenes
  List<Exam> _availableExams = [];
  List<Exam> _selectedExams = [];
  
  // Pacientes (para el selector)
  List<Patient> _allPatients = [];

  // Getters
  bool get loading => _loading;
  bool get searching => _searching;
  Patient? get foundPatient => _foundPatient;
  List<Exam> get availableExams => _availableExams;
  List<Exam> get selectedExams => _selectedExams;
  List<Patient> get allPatients => _allPatients;

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
    _loadAllPatients();
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

  // Cargar todos los pacientes (para el selector)
  Future<void> _loadAllPatients() async {
    try {
      final query = GetPatientsQuery(
        builder: EdgePatientFieldsBuilder().defaultValues(),
      );

      final useCase = ReadPatientUsecase(operation: query, conn: _gqlConn);
      final response = await useCase.build();

      if (response is EdgePatient) {
        _allPatients = response.edges;
        notifyListeners();
        debugPrint('✅ ${_allPatients.length} pacientes cargados');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al cargar pacientes: $e');
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
      debugPrint('🔍 Buscando paciente con DNI: $dni');
      
      final query = GetPatientsQuery(
        builder: EdgePatientFieldsBuilder().defaultValues(),
      );

      final useCase = ReadPatientUsecase(operation: query, conn: _gqlConn);

      // Obtener todos los pacientes (sin filtro de búsqueda)
      // Porque el backend no soporta búsquedas en union types
      final response = await useCase.build();
      
      debugPrint('📥 Response type: ${response.runtimeType}');
      
      if (response is EdgePatient) {
        debugPrint('📊 Total pacientes recibidos: ${response.edges.length}');
        
        // Filtrar en el frontend por DNI
        final patients = response.edges.where((patient) {
          if (patient.isPerson && patient.asPerson != null) {
            return patient.asPerson!.dni == dni;
          }
          return false;
        }).toList();
        
        if (patients.isNotEmpty) {
          debugPrint('✅ Paciente encontrado: ${patients.first.id}');
          foundPatient = patients.first;
        } else {
          debugPrint('❌ No se encontró paciente con DNI: $dni');
          foundPatient = null;
        }
      } else {
        debugPrint('❌ Response no es EdgePatient');
        foundPatient = null;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al buscar paciente: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      foundPatient = null;

     
    } finally {
      searching = false;
    }
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

  // Crear factura
  Future<bool> createInvoice() async {
    bool isError = true;
    loading = true;

    try {
      // Validar que exista paciente seleccionado
      if (foundPatient == null) {
        throw Exception('No se ha seleccionado un paciente');
      }

      // 1. Crear Person primero (para billTo)
      debugPrint('🔵 Creando Person para billTo...');
      final createPersonUseCase = CreatePersonUsecase(
        operation: CreatePersonMutation(
          builder: PersonFieldsBuilder().defaultValues(),
        ),
        conn: _gqlConn,
      );

      final personResponse = await createPersonUseCase.execute(
        input: personInput,
      );

      if (personResponse is! Person) {
        throw Exception('Error al crear la persona para facturación');
      }

      debugPrint('✅ Person creada con ID: ${personResponse.id}');

      // 2. Preparar datos de la factura con el billTo
      invoiceInput.patient = foundPatient!.id;
      invoiceInput.examIDs = _selectedExams.map((e) => e.id).toList();
      invoiceInput.billTo = personResponse.id; // Asignar ID de Person creada

      // 3. Crear factura
      debugPrint('🔵 Creando Invoice...');
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
        debugPrint('✅ Invoice creada con ID: ${invoiceResponse.id}');
        isError = false;
      } else {
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al crear factura: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;

     
    } finally {
      loading = false;
    }

    return isError;
  }
}
