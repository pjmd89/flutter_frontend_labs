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

  final CreatePatientInput input = CreatePatientInput();

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    _laboratoryNotifier = _context.read<LaboratoryNotifier>();
    _assignLaboratoryFromContext();
  }

  void _assignLaboratoryFromContext() {
    final laboratoryId = _laboratoryNotifier.selectedLaboratory?.id;

    if (laboratoryId != null && laboratoryId.isNotEmpty) {
      input.laboratory = laboratoryId;
      debugPrint('🔗 Laboratory asignado desde contexto: $laboratoryId');
    } else {
      debugPrint('⚠️ No hay laboratorio seleccionado en contexto');
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
