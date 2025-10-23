import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createUser/createuser_mutation.dart';
import '/src/domain/usecases/User/create_user_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;

  final CreateUserInput input = CreateUserInput();

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
  }

  Future<bool> create() async {
    bool isError = true;
    loading = true;

    CreateUserUsecase useCase = CreateUserUsecase(
      operation: CreateUserMutation(builder: UserFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute(input: input);

      if (response is User) {
        isError = false;
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      loading = false;
    }

    return isError;
  }
}
