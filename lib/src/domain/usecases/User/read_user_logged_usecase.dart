import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;


class ReadUserLoggedUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;
  ReadUserLoggedUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic>build() async {
    return _conn.operation(operation: _operation, callback: callback);
  }
  callback(Object ob) {
    //final thisObject = ob as {YourEntityType};
  }
}
