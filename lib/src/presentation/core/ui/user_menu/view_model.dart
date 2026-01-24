import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/queries/logout/logout_query.dart';
import 'package:labs/src/domain/usecases/Auth/logout_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/auth_notifier.dart';

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

        // Limpiar sesión local
        if (_context.mounted) {
          final authNotifier = _context.read<AuthNotifier>();
          await authNotifier.signOut();

          // Redireccionar a login
          if (_context.mounted) {
            _context.go('/login');
          }
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
