import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/presentation/providers/auth_notifier.dart';
import '/src/domain/operation/queries/getLabMemberships/getlabmemberships_query.dart';
import '/src/domain/operation/queries/getUsers/getusers_query.dart';
import '/src/domain/operation/fields_builders/edgelabmembershipinfo_fields_builder.dart';
import '/src/domain/operation/fields_builders/edgeuser_fields_builder.dart';
import '/src/domain/extensions/edgelabmembershipinfo_fields_builder_extension.dart';
import '/src/domain/extensions/edgeuser_fields_builder_extension.dart';
import '/src/domain/usecases/LabMembership/read_labmembership_usecase.dart';
import '/src/domain/usecases/User/read_user_usecase.dart';


class ViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<LabMembershipInfo>? _membershipList;
  List<User>? _userList;
  PageInfo? _pageInfo;

  late GqlConn _gqlConn;
  late ReadLabMembershipUsecase? _readMembershipUseCase;
  late ReadUserUsecase? _readUserUseCase;
  late LaboratoryNotifier _laboratoryNotifier;
  late bool _isRootUser; // true si es ROOT o ADMIN
  final BuildContext _context;

  // Query con FieldsBuilder configurado para memberships
  final GetLabMembershipsQuery _membershipOperation = GetLabMembershipsQuery(
    builder: EdgeLabMembershipInfoFieldsBuilder().defaultValues(),
  );
  
  // Query con FieldsBuilder configurado para users
  final GetUsersQuery _userOperation = GetUsersQuery(
    builder: EdgeUserFieldsBuilder().defaultValues(),
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
    
    // Inicializar el usecase apropiado según el rol
    if (_isRootUser) {
      _readUserUseCase = ReadUserUsecase(operation: _userOperation, conn: _gqlConn);
      _readMembershipUseCase = null;
    } else {
      _readMembershipUseCase = ReadLabMembershipUsecase(operation: _membershipOperation, conn: _gqlConn);
      _readUserUseCase = null;
    }
    
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
        // Usuario ROOT o ADMIN: usar getUsers
        final response = await _readUserUseCase!.build();
        
        if (response is EdgeUser) {
          userList = response.edges;
          pageInfo = response.pageInfo;
          membershipList = null; // Limpiar lista de memberships
        }
      } else {
        // Otros usuarios: usar getLabMemberships
        final response = await _readMembershipUseCase!.build();

        if (response is EdgeLabMembershipInfo) {
          membershipList = response.edges;
          pageInfo = response.pageInfo;
          userList = null; // Limpiar lista de users
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
      if (_isRootUser) {
        // Usuario ROOT o ADMIN: usar getUsers
        final response = await _readUserUseCase!.search(searchInputs, _pageInfo);

        if (response is EdgeUser) {
          userList = response.edges;
          pageInfo = response.pageInfo;
          membershipList = null;
        }
      } else {
        // Otros usuarios: usar getLabMemberships
        final response = await _readMembershipUseCase!.search(searchInputs, _pageInfo);

        if (response is EdgeLabMembershipInfo) {
          membershipList = response.edges;
          pageInfo = response.pageInfo;
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
