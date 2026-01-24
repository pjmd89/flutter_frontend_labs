import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/edgelaboratory_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/edgelabmembershipinfo_fields_builder_extension.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import 'package:labs/src/domain/operation/queries/getLabMemberships/getlabmemberships_query.dart';
import 'package:labs/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import 'package:labs/src/domain/usecases/LabMembership/read_labmembership_usecase.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import 'package:labs/src/presentation/providers/gql_notifier.dart';


class LaboratorySelectorViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<Laboratory>? _laboratoryList;

  late GqlConn _gqlConn;
  late ReadLaboratoryUsecase _readLaboratoryUseCase;
  // ignore: unused_field
  late ReadLabMembershipUsecase _readLabMembershipUseCase;
  final BuildContext _context;
  final String _userId;
  final Role? _userRole;

  final GetLaboratoriesQuery _laboratoryOperation = GetLaboratoriesQuery(
    builder: EdgeLaboratoryFieldsBuilder().defaultValues(),
  );

  final GetLabMembershipsQuery _labMembershipOperation = GetLabMembershipsQuery(
    builder: EdgeLabMembershipInfoFieldsBuilder().defaultValues(),
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
        _userId = context.read<AuthNotifier>().id,
        _userRole = context.read<AuthNotifier>().role {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _readLaboratoryUseCase = ReadLaboratoryUsecase(operation: _laboratoryOperation, conn: _gqlConn);
    _readLabMembershipUseCase = ReadLabMembershipUsecase(operation: _labMembershipOperation, conn: _gqlConn);
    _init();
  }

  Future<void> _init() async {
    await getLaboratories();
  }

  Future<void> getLaboratories() async {
    loading = true;
    error = false;

    try {
      debugPrint('🔍 Cargando laboratorios para usuario: $_userId (Role: $_userRole)');
      
      // Para ROOT y ADMIN: obtener todos los laboratorios que poseen (por company.owner)
      if (_userRole == Role.rOOT || _userRole == Role.aDMIN) {
        debugPrint('👑 Usuario ROOT/ADMIN - Obteniendo laboratorios como propietario');
        final response = await _readLaboratoryUseCase.build();

        if (response is EdgeLaboratory) {
          final allLaboratories = response.edges;
          debugPrint('📦 Total laboratorios encontrados: ${allLaboratories.length}');
          
          // Filtrar laboratorios por company.owner.id = userId
          laboratoryList = allLaboratories.where((lab) {
            final ownerMatches = lab.company?.owner?.id == _userId;
            debugPrint('   Lab: ${lab.company?.name ?? 'Sin nombre'} - Owner: ${lab.company?.owner?.id} - Match: $ownerMatches');
            return ownerMatches;
          }).toList();
          
          debugPrint('✅ Laboratorios filtrados como propietario: ${laboratoryList?.length ?? 0}');
        }
      } 
      // Para USER (BIOANALYST, TECHNICIAN, BILLING, etc.): obtener laboratorios donde es miembro
      else if (_userRole == Role.uSER) {
        debugPrint('👤 Usuario con Role.USER - Obteniendo laboratorios como miembro');
        debugPrint('⚠️ NOTA: getLabMemberships requiere laboratorio seleccionado, no funciona en selector');
        debugPrint('🔄 Intentando obtener TODOS los laboratorios y filtrar localmente...');
        
        // Obtener TODOS los laboratorios sin filtros
        final response = await _readLaboratoryUseCase.build();
        
        if (response is EdgeLaboratory) {
          final allLaboratories = response.edges;
          debugPrint('📦 Total laboratorios encontrados: ${allLaboratories.length}');
          
          // Por ahora, mostrar TODOS los laboratorios como workaround
          // 
          laboratoryList = allLaboratories;
          
          debugPrint('✅ Laboratorios disponibles: ${laboratoryList?.length ?? 0}');
          debugPrint('⚠️ TEMPORAL: Mostrando TODOS los laboratorios. Requiere filtro backend.');
        }
      } else {
        debugPrint('⚠️ Rol no reconocido: $_userRole');
        laboratoryList = [];
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getLaboratories: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      laboratoryList = [];

      //_context.read<GQLNotifier>().errorService.showError(
      //      message: 'Error al cargar laboratorios: ${e.toString()}',
      //    );
    } finally {
      loading = false;
    }
  }
}
