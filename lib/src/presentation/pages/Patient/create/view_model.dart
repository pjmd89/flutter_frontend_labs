import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createPatient/createpatient_mutation.dart';
import '/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import '/src/domain/usecases/Patient/create_patient_usecase.dart';
import '/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import '/src/domain/extensions/edgelaboratory_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';
import '/l10n/app_localizations.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  bool _loadingLaboratories = false;
  List<Laboratory> _laboratories = [];

  final CreatePatientInput input = CreatePatientInput();

  List<Laboratory> get laboratories => _laboratories;
  bool get loadingLaboratories => _loadingLaboratories;

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    _loadLaboratories();
  }

  Future<void> _loadLaboratories() async {
    _loadingLaboratories = true;
    notifyListeners();

    try {
      debugPrint('🔍 Iniciando carga de laboratorios...');
      
      ReadLaboratoryUsecase readLaboratoryUsecase = ReadLaboratoryUsecase(
        operation: GetLaboratoriesQuery(
          builder: EdgeLaboratoryFieldsBuilder().defaultValues(),
        ),
        conn: _gqlConn,
      );

      debugPrint('🚀 Ejecutando readWithoutPaginate...');
      var response = await readLaboratoryUsecase.readWithoutPaginate();
      debugPrint('✅ readWithoutPaginate completado');
      
      debugPrint('📦 Respuesta recibida: ${response.runtimeType}');
      debugPrint('📦 Respuesta toString: $response');
      
      // Intentar ver el contenido si es un Map
      if (response is Map) {
        debugPrint('📦 Es un Map con keys: ${response.keys}');
      }
      
      // Intentar parsear directamente
      try {
        final edgeLab = response as EdgeLaboratory;
        debugPrint('✅ Cast directo a EdgeLaboratory exitoso');
        _laboratories = edgeLab.edges;
        debugPrint('📊 Número de laboratorios después del cast: ${_laboratories.length}');
      } catch (castError) {
        debugPrint('❌ Error en cast: $castError');
      }

      if (response is EdgeLaboratory) {
        debugPrint('✅ EdgeLaboratory detectado con is');
        debugPrint('📊 Número de laboratorios: ${response.edges.length}');
        _laboratories = response.edges;
        
        // Debug: Mostrar cada laboratorio
        for (var lab in _laboratories) {
          debugPrint('  - Lab ID: ${lab.id}, Address: ${lab.address}, Company: ${lab.company?.name ?? "Sin empresa"}');
        }
      } else {
        debugPrint('❌ Respuesta no es EdgeLaboratory: $response');
        _laboratories = [];
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al cargar laboratorios: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      _laboratories = [];
    } finally {
      _loadingLaboratories = false;
      debugPrint('🏁 Carga de laboratorios finalizada. Total: ${_laboratories.length}');
      notifyListeners();
    }
  }

  Future<bool> create() async {
    bool isError = true;
    loading = true;

    CreatePatientUsecase useCase = CreatePatientUsecase(
      operation: CreatePatientMutation(builder: PatientFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      // Limpiar campos opcionales vacíos antes de enviar
      if (input.lastName == null || input.lastName!.isEmpty) {
        input.lastName = null;
      }

      if (input.birthDate == null || input.birthDate!.isEmpty) {
        input.birthDate = null;
      }

      if (input.species == null || input.species!.isEmpty) {
        input.species = null;
      }

      if (input.dni == null || input.dni!.isEmpty) {
        input.dni = null;
      }

      if (input.phone == null || input.phone!.isEmpty) {
        input.phone = null;
      }

      if (input.email == null || input.email!.isEmpty) {
        input.email = null;
      }

      if (input.address == null || input.address!.isEmpty) {
        input.address = null;
      }

      var response = await useCase.execute(input: input);

      if (response is Patient) {
        isError = false;

        // Mostrar mensaje de éxito
        final l10n = AppLocalizations.of(_context)!;
        _errorService.showError(
          message: l10n.thingCreatedSuccessfully(l10n.patient),
          type: ErrorType.success,
        );
      } else {
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en create patient: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;

      // Mostrar error al usuario
      _errorService.showError(
        message: 'Error al crear paciente: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
