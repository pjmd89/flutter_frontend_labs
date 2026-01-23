import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/queries/getLoggedUser/getloggeduser_query.dart';
import 'package:labs/src/domain/extensions/user_logged_builder/main.dart';
import 'package:labs/src/domain/usecases/User/read_user_logged_usecase.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = true;
  bool _error = false;
  late GqlConn _gqlConn;
  final BuildContext _context;
  final GetLoggedUserQuery _loggedQuery =  GetLoggedUserQuery(
    builder: LoggedUserFieldsBuilder().defaultValues()
  );
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

  setLoginUser(User user) async{
    final authNotifier = _context.read<AuthNotifier>();
    await authNotifier.signIn(user: user);

  }
  Future<LoggedUser?> loggedUser() async{
    loading = true;
    final response = await ReadUserLoggedUsecase(
      operation: _loggedQuery,
      conn: _gqlConn,
    ).build();

    return response as LoggedUser;
  }

  read(Operation operation) async{
    _gqlConn.operation(operation: operation);
  }


}
