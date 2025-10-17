import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = true;
  bool _error = false;
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool get loading => _loading;
  bool get error => _error;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }
  set error(bool value) {
    _error = value;
    notifyListeners();
  }
  ViewModel(
    {required BuildContext context}
  ) : _context = context{
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
  }

  create(Operation operation) async{
    _gqlConn.operation(operation: operation);
  }
}
