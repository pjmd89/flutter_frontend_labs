
import 'package:flutter/material.dart';
import 'package:agile_front/agile_front.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/l10n/app_localizations.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';
import '/src/domain/operation/mutations/deletePatient/deletepatient_mutation.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/extensions/patient_fields_builder_extension.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = false;
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  late AppLocalizations l10n;

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    l10n = AppLocalizations.of(context)!;
  }

  /// Elimina un paciente por ID
  /// Retorna true si fue exitoso, false si hubo error
  Future<bool> delete({required String id}) async {
    loading = true;
    bool success = false;

    try {
      final mutation = DeletePatientMutation(
        builder: PatientFieldsBuilder().defaultValues(),
        declarativeArgs: {"_id": "ID!"},
        opArgs: {"_id": GqlVar("_id")},
      );

      debugPrint('🗑️ Eliminando Patient con ID: $id');

      await _gqlConn.operation(
        operation: mutation,
        variables: {"_id": id},
      );

      success = true;
      
      _errorService.showError(
        message: l10n.thingDeletedSuccessfully(l10n.patient),
        type: ErrorType.success,
      );

      debugPrint('✅ Patient eliminado exitosamente');
    } catch (e, stackTrace) {
      debugPrint('💥 Error al eliminar Patient: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      
      success = false;
      
      String errorMessage = l10n.errorDeleting(l10n.patient);
      
      if (e.toString().contains('not found') || e.toString().contains('NotFoundException')) {
        errorMessage = l10n.recordNotFound;
      } else if (e.toString().contains('foreign key') || e.toString().contains('has dependencies')) {
        errorMessage = l10n.cannotDeleteHasDependencies;
      } else if (e.toString().contains('permission') || e.toString().contains('PermissionException')) {
        errorMessage = l10n.permissionDenied;
      }
      
      _errorService.showError(
        message: errorMessage,
        type: ErrorType.error,
      );
    } finally {
      loading = false;
    }

    return success;
  }
}
