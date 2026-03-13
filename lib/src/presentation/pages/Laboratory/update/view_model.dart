import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/updateLaboratory/updatelaboratory_mutation.dart';
import '/src/domain/operation/mutations/manageLaboratoryEmployees/managelaboratoryemployees_mutation.dart';
import '/src/domain/usecases/Laboratory/update_laboratory_usecase.dart';
import '/src/domain/usecases/Laboratory/manage_employees_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  
  final UpdateLaboratoryInput input = UpdateLaboratoryInput();
  Laboratory? _currentLaboratory;

  bool get loading => _loading;
  Laboratory? get currentLaboratory => _currentLaboratory;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({
    required BuildContext context,
    required Laboratory laboratory,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    _currentLaboratory = laboratory;
    
    // Prellenar input con datos existentes
    input.id = laboratory.id;
    input.address = laboratory.address;
    input.contactPhoneNumbers = List.from(laboratory.contactPhoneNumbers);
  }

  Future<bool> update() async {
    final l10n = AppLocalizations.of(_context)!;
    bool isError = true;
    loading = true;

    UpdateLaboratoryUsecase useCase = UpdateLaboratoryUsecase(
      operation: UpdateLaboratoryMutation(builder: LaboratoryFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute(input: input);
      
      if (response is Laboratory) {
        isError = false;
        _currentLaboratory = response;
        
        _errorService.showError(
          message: l10n.updateThing(l10n.laboratory),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en updateLaboratory: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: 'Error al actualizar laboratorio: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }

  /// Gestiona los empleados del laboratorio (agregar o remover)
  /// [employeeIds] Lista de IDs de empleados a gestionar
  /// [remove] true para remover, false para agregar
  Future<bool> manageEmployees({
    required List<String> employeeIds,
    required bool remove,
  }) async {
    bool isError = true;
    loading = true;

    // Crear el input
    final employeesInput = EmployeesInput(
      id: _currentLaboratory?.id,
      employees: employeeIds,
      remove: remove,
    );

    ManageEmployeesUsecase useCase = ManageEmployeesUsecase(
      operation: ManageLaboratoryEmployeesMutation(builder: LaboratoryFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute(input: employeesInput);
      
      if (response is Laboratory) {
        isError = false;
        _currentLaboratory = response;
        
        final action = remove ? 'removidos' : 'agregados';
        _errorService.showError(
          message: 'Empleados $action correctamente',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en manageEmployees: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: 'Error al gestionar empleados: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
