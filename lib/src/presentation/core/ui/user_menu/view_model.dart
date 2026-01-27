import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/queries/logout/logout_query.dart';
import 'package:labs/src/domain/usecases/Auth/logout_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/auth_notifier.dart';
import '/src/presentation/core/navigation/routes/main.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
  }

  Future<bool> logout() async {
    bool isError = true;
    loading = true;

    LogoutUsecase useCase = LogoutUsecase(
      operation: LogoutQuery(builder: UserFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute();

      if (response is User) {
        // Logout exitoso en el backend
        isError = false;

        // Resetear el loginRouter para que comience fresco
        resetLoginRouter();

        // Limpiar sesión local - la redirección se maneja automáticamente
        // por el listener _onAuthChanged en Template (main.dart)
        if (_context.mounted) {
          final authNotifier = _context.read<AuthNotifier>();
          await authNotifier.signOut();
        }
      } else {
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en logout: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;

      
    } finally {
      loading = false;
    }

    return isError;
  }
}
