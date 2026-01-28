import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
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

  setLoginUser(LoggedUser loggedUser) async{
    final authNotifier = _context.read<AuthNotifier>();
    await authNotifier.signIn(
      user: loggedUser.user!,
      userIsLabOwner: loggedUser.userIsLabOwner,
      labRole: loggedUser.labRole,
    );
  }
  Future<LoggedUser?> loggedUser() async {
    loading = true;
    error = false;

    try {
      final response = await ReadUserLoggedUsecase(
        operation: _loggedQuery,
        conn: _gqlConn,
      ).build();

      debugPrint('🔍 Response type: ${response.runtimeType}');

      // Si la respuesta es ErrorReturned, el ErrorManager ya mostró el mensaje
      if (response.runtimeType.toString() == 'ErrorReturned') {
        debugPrint('❌ Response es ErrorReturned - error controlado del backend');
        error = true;
        return null;
      }

      // Verificar que sea LoggedUser antes de retornar
      if (response is LoggedUser) {
        return response;
      } else {
        debugPrint('💥 Tipo de respuesta inesperado: ${response.runtimeType}');
        error = true;
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en loggedUser: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      return null;
    } finally {
      loading = false;
    }
  }

  read(Operation operation) async{
    _gqlConn.operation(operation: operation);
  }


}
