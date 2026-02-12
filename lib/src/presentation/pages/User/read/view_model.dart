import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/presentation/providers/auth_notifier.dart';
import '/src/domain/operation/queries/getLabMemberships/getlabmemberships_query.dart';
import '/src/domain/operation/fields_builders/edgelabmembershipinfo_fields_builder.dart';
import '/src/domain/extensions/edgelabmembershipinfo_fields_builder_extension.dart';
import '/src/domain/usecases/LabMembership/read_labmembership_usecase.dart';


class ViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<LabMembershipInfo>? _membershipList;
  List<User>? _userList;
  PageInfo? _pageInfo;

  late GqlConn _gqlConn;
  late ReadLabMembershipUsecase _readMembershipUseCase;
  late LaboratoryNotifier _laboratoryNotifier;
  late bool _isRootUser; // true si es ROOT o ADMIN
  final BuildContext _context;

  // Query con FieldsBuilder configurado para memberships
  final GetLabMembershipsQuery _membershipOperation = GetLabMembershipsQuery(
    builder: EdgeLabMembershipInfoFieldsBuilder().defaultValues(),
  );

  bool get loading => _loading;
  bool get error => _error;
  List<LabMembershipInfo>? get membershipList => _membershipList;
  List<User>? get userList => _userList;
  PageInfo? get pageInfo => _pageInfo;
  bool get isRootUser => _isRootUser; // true si es ROOT o ADMIN

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set membershipList(List<LabMembershipInfo>? value) {
    _membershipList = value;
    notifyListeners();
  }
  
  set userList(List<User>? value) {
    _userList = value;
    notifyListeners();
  }

  set pageInfo(PageInfo? value) {
    _pageInfo = value;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _laboratoryNotifier = _context.read<LaboratoryNotifier>();
    
    // Detectar si es usuario ROOT o ADMIN
    final authNotifier = _context.read<AuthNotifier>();
    _isRootUser = authNotifier.role == Role.rOOT || authNotifier.role == Role.aDMIN;
    
    debugPrint('🔍 User ViewModel - Es ROOT o ADMIN? $_isRootUser, Rol: ${authNotifier.role}');
    
    // Inicializar usecase de memberships para todos los roles
    _readMembershipUseCase = ReadLabMembershipUsecase(operation: _membershipOperation, conn: _gqlConn);
    
    // Escuchar cambios en el laboratorio seleccionado solo si NO es root
    if (!_isRootUser) {
      _laboratoryNotifier.addListener(_onLaboratoryChanged);
    }
    
    _init();
  }
  
  /// Se ejecuta cuando cambia el laboratorio seleccionado
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando membresías...');
    getMemberships();
  }
  
  @override
  void dispose() {
    if (!_isRootUser) {
      _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    }
    super.dispose();
  }

  Future<void> _init() async {
    await getMemberships();
  }

  Future<void> getMemberships() async {
    loading = true;
    error = false;

    try {
      if (_isRootUser) {
        // ROOT/ADMIN: Usar build() sin filtros para obtener TODAS las membresías
        debugPrint('🔍 ROOT/ADMIN: Obteniendo todas las membresías del sistema (sin filtros)');
        
        final response = await _readMembershipUseCase.build();

        if (response is EdgeLabMembershipInfo) {
          membershipList = response.edges;
          pageInfo = response.pageInfo;
          userList = null; // Limpiar userList, ahora usamos membershipList
          
          debugPrint('✅ Total membresías obtenidas: ${response.edges.length}');
        }
      } else {
        // Otros usuarios: filtrar por laboratorio seleccionado
        final selectedLaboratory = _laboratoryNotifier.selectedLaboratory;
        
        if (selectedLaboratory == null) {
          debugPrint('⚠️ No hay laboratorio seleccionado');
          membershipList = [];
          userList = [];
          loading = false;
          return;
        }

        final searchInputs = [
          SearchInput(
            field: 'laboratory',
            value: [
              ValueInput(
                value: selectedLaboratory.id,
                operator: OperatorEnum.eq,
                kind: KindEnum.iD,
              )
            ]
          )
        ];
        
        debugPrint('🔍 Buscando membresías del laboratorio: ${selectedLaboratory.id}');

        final response = await _readMembershipUseCase.search(searchInputs, null);

        if (response is EdgeLabMembershipInfo) {
          membershipList = response.edges;
          pageInfo = response.pageInfo;
          userList = null;
          
          debugPrint('✅ Membresías obtenidas: ${response.edges.length}');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getMemberships: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      membershipList = [];
      userList = [];

      // Mostrar error al usuario
     
    } finally {
      loading = false;
    }
  }

  Future<void> search(List<SearchInput> searchInputs) async {
    loading = true;
    error = false;

    try {
      // Usar getLabMemberships para todos los roles
      final response = await _readMembershipUseCase.search(searchInputs, _pageInfo);

      if (response is EdgeLabMembershipInfo) {
        membershipList = response.edges;
        pageInfo = response.pageInfo;
        
        // Para usuarios ROOT/ADMIN, extraer los usuarios de las memberships
        if (_isRootUser) {
          userList = response.edges.map((membership) => membership.member).whereType<User>().toList();
        } else {
          userList = null;
        }
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      membershipList = [];
      userList = [];

      // Mostrar error al usuario
      
    } finally {
      loading = false;
    }
  }

  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]); // Recargar con la nueva página
  }
}
