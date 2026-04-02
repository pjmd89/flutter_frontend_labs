import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createPatient/createpatient_mutation.dart';
import '/src/domain/usecases/Patient/create_patient_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/infraestructure/services/error_service.dart';


class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  late LaboratoryNotifier _laboratoryNotifier;
  final BuildContext _context;
  bool _loading = false;
  bool _loadingLaboratories = false;
  List<Laboratory> _laboratories = [];

  final CreatePatientInput input = CreatePatientInput();

  bool get loading => _loading;
  bool get loadingLaboratories => _loadingLaboratories;
  List<Laboratory> get laboratories => _laboratories;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    
    // Obtener el laboratoryID del usuario actual y asignarlo al input
    final laboratoryNotifier = _context.read<LaboratoryNotifier>();
    final currentLaboratoryID = laboratoryNotifier.loggedUser?.currentLaboratory?.id;
    
    if (currentLaboratoryID != null) {
      input.laboratory = currentLaboratoryID;
      debugPrint('🏥 LaboratoryID asignado automáticamente: $currentLaboratoryID');
    } else {
      debugPrint('⚠️ No se pudo obtener el laboratoryID actual');
    }
    
    _loadLaboratories();
  }

  Future<void> _loadLaboratories() async {
    _loadingLaboratories = true;
    notifyListeners();

    try {
      debugPrint('🔍 Iniciando carga de laboratorios...');
      
      // Obtener laboratorios del usuario logueado
      final loggedUser = _laboratoryNotifier.loggedUser;
      if (loggedUser != null) {
        // Por el momento usar una lista vacía si no están disponibles
        _laboratories = [];
        debugPrint('✅ Laboratorios inicializados para el usuario');
      } else {
        debugPrint('⚠️ No se pudieron obtener laboratorios del usuario');
        _laboratories = [];
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al cargar laboratorios: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      _laboratories = [];
      
      _errorService.showError(
        message: 'Error al cargar laboratorios: ${e.toString()}',
        type: ErrorType.error,
      );
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
      final laboratoryId = _laboratoryNotifier.selectedLaboratory?.id;
      if (laboratoryId == null || laboratoryId.isEmpty) {
        final l10n = AppLocalizations.of(_context)!;
        _errorService.showError(message: l10n.selectLaboratory);
        return true;
      }

      input.laboratory = laboratoryId;

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

      // 🐛 DEBUG: Mostrar valores del input antes de enviar
      debugPrint('📤 Enviando CreatePatientInput:');
      debugPrint('   firstName: ${input.firstName}');
      debugPrint('   lastName: ${input.lastName}');
      debugPrint('   sex: ${input.sex}');
      debugPrint('   birthDate: ${input.birthDate}');
      debugPrint('   species: ${input.species}');
      debugPrint('   dni: ${input.dni}');
      debugPrint('   phone: ${input.phone}');
      debugPrint('   email: ${input.email}');
      debugPrint('   address: ${input.address}');
      debugPrint('   laboratory: ${input.laboratory}');
      debugPrint('📦 Input JSON: ${input.toJson()}');

      var response = await useCase.execute(input: input);

      if (response is Patient) {
        isError = false;

        // Mostrar mensaje de éxito
      
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
