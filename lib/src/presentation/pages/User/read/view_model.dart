import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<User>? _userList;

  late GqlConn _gqlConn;
  final BuildContext _context;

  bool get loading => _loading;
  bool get error => _error;
  List<User>? get userList => _userList;

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

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _init();
  }

  Future<void> _init() async {
    // TODO: Implementar getUsers cuando esté lista la query
    // await getUsers();
  }

  Future<void> getUsers() async {
    loading = true;
    error = false;

    try {
      // TODO: Implementar llamada a GraphQL
      // final response = await _gqlConn.operation(operation: getUsersQuery);
      // userList = response.data?.getUsers?.edges ?? [];

      // Datos de prueba temporales
      userList = [];
    } catch (e) {
      error = true;
    } finally {
      loading = false;
    }
  }

  read(Operation operation) async {
    _gqlConn.operation(operation: operation);
  }
}
