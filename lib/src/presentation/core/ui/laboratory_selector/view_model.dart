import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/edgelaboratory_fields_builder_extension.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import 'package:labs/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import 'package:labs/src/presentation/providers/gql_notifier.dart';
import 'package:provider/provider.dart';

class LaboratorySelectorViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<Laboratory>? _laboratoryList;

  late GqlConn _gqlConn;
  late ReadLaboratoryUsecase _readUseCase;
  final BuildContext _context;
  final String _userId;

  final GetLaboratoriesQuery _operation = GetLaboratoriesQuery(
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

  LaboratorySelectorViewModel({required BuildContext context})
      : _context = context,
        _userId = context.read<AuthNotifier>().id {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _readUseCase = ReadLaboratoryUsecase(operation: _operation, conn: _gqlConn);
    _init();
  }

  Future<void> _init() async {
    await getLaboratories();
  }

  Future<void> getLaboratories() async {
    loading = true;
    error = false;

    try {
      debugPrint('🔍 Cargando laboratorios para usuario: $_userId');
      
      final response = await _readUseCase.build();

      if (response is EdgeLaboratory) {
        final allLaboratories = response.edges;
        debugPrint('📦 Total laboratorios encontrados: ${allLaboratories.length}');
        
        // Filtrar laboratorios por company.owner.id = userId
        laboratoryList = allLaboratories.where((lab) {
          final ownerMatches = lab.company?.owner?.id == _userId;
          debugPrint('   Lab: ${lab.company?.name ?? 'Sin nombre'} - Owner: ${lab.company?.owner?.id} - Match: $ownerMatches');
          return ownerMatches;
        }).toList();
        
        debugPrint('✅ Laboratorios filtrados: ${laboratoryList?.length ?? 0}');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getLaboratories: $e');
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
