import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import '/src/domain/extensions/user_fields_builder_extension.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/logout/logout_query.dart';

class LogoutUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;

  LogoutUsecase({required af.Operation operation, required af.Service conn})
    : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic> build() async {
    _conn.operation(operation: _operation, callback: callback);
  }

  callback(Object ob) {
    // final thisObject = ob as User;
  }

  Future<dynamic> execute() async {
    UserFieldsBuilder fieldsBuilder = UserFieldsBuilder().defaultValues();

    LogoutQuery query = LogoutQuery(builder: fieldsBuilder);

    var response = await _conn.operation(operation: query, variables: {});

    return response;
  }
}
