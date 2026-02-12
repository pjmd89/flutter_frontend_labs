import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/edgelaboratory_fields_builder_extension.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import 'package:labs/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import 'package:labs/src/presentation/providers/gql_notifier.dart';

class LaboratorySwitcherViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<Laboratory>? _laboratoryList;

  late GqlConn _gqlConn;
  late ReadLaboratoryUsecase _readLaboratoryUseCase;
  final BuildContext _context;
  final String _userId;
  final Role? _userRole;

  final GetLaboratoriesQuery _laboratoryOperation = GetLaboratoriesQuery(
    builder: EdgeLaboratoryFieldsBuilder().defaultValues(),
  );

  bool get loading => _loading;
  bool get error => _error;
  List<Laboratory>? get laboratoryList => _laboratoryList;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set laboratoryList(List<Laboratory>? value) {
    _laboratoryList = value;
    notifyListeners();
  }

  LaboratorySwitcherViewModel({required BuildContext context})
      : _context = context,
        _userId = context.read<AuthNotifier>().id,
        _userRole = context.read<AuthNotifier>().role {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _readLaboratoryUseCase = ReadLaboratoryUsecase(
      operation: _laboratoryOperation,
      conn: _gqlConn,
    );
    _init();
  }

  Future<void> _init() async {
    await getLaboratories();
  }

  /// Método público para recargar la lista de laboratorios
  /// Se puede llamar desde fuera cuando se crea/actualiza/elimina un laboratorio
  Future<void> getLaboratories() async {
    loading = true;
    error = false;

    try {
      debugPrint('🔍 Cargando laboratorios para switcher: $_userId (Role: $_userRole)');

      // Para ROOT y ADMIN: obtener todos los laboratorios
      if (_userRole == Role.rOOT || _userRole == Role.aDMIN) {
        debugPrint('📋 Usuario ROOT/ADMIN - Obteniendo todos los laboratorios');
        final response = await _readLaboratoryUseCase.readWithoutPaginate();

        if (response is EdgeLaboratory) {
          debugPrint('✅ EdgeLaboratory detectado');
          debugPrint('   Total laboratorios: ${response.edges.length}');
          laboratoryList = response.edges;
        }
      } else {
        // Para otros roles: obtener laboratorios donde es miembro
        debugPrint('📋 Usuario regular - Obteniendo laboratorios por membresía');
        // TODO: Implementar query por membresía si es necesario
        // Por ahora usamos la misma query
        final response = await _readLaboratoryUseCase.readWithoutPaginate();

        if (response is EdgeLaboratory) {
          laboratoryList = response.edges;
        }
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getLaboratories (switcher): $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      laboratoryList = [];

      _context.read<GQLNotifier>().errorService.showError(
            message: 'Error al cargar laboratorios: ${e.toString()}',
          );
    } finally {
      loading = false;
    }
  }
}
