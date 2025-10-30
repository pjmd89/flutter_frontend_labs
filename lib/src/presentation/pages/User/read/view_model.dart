import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getUsers/getusers_query.dart';
import '/src/domain/extensions/edgeuser_fields_builder_extension.dart';
import '/src/domain/usecases/User/read_user_usecase.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<User>? _userList;
  PageInfo? _pageInfo;

  late GqlConn _gqlConn;
  late ReadUserUsecase _readUseCase;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetUsersQuery _operation = GetUsersQuery(
    builder: EdgeUserFieldsBuilder().defaultValues(),
  );

  bool get loading => _loading;
  bool get error => _error;
  List<User>? get userList => _userList;
  PageInfo? get pageInfo => _pageInfo;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
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
    _readUseCase = ReadUserUsecase(operation: _operation, conn: _gqlConn);
    _init();
  }

  Future<void> _init() async {
    await getUsers();
  }

  Future<void> getUsers() async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.build();

      if (response is EdgeUser) {
        userList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getUsers: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      userList = [];

      // Mostrar error al usuario
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al cargar usuarios: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  Future<void> search(List<SearchInput> searchInputs) async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.search(searchInputs, _pageInfo);

      if (response is EdgeUser) {
        userList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search users: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      userList = [];

      // Mostrar error al usuario
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al buscar usuarios: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]); // Recargar con la nueva página
  }
}
