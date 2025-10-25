import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createCompany/createcompany_mutation.dart';
import '/src/domain/usecases/Company/create_company_usecase.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;

  // Input con valores iniciales
  final CreateCompanyInput input = CreateCompanyInput(
    name: '',
    taxID: '',
    logo: '',
    laboratoryInfo: CreateLaboratoryInput(address: '', contactPhoneNumbers: []),
  );

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

    CreateCompanyUsecase useCase = CreateCompanyUsecase(
      operation: CreateCompanyMutation(builder: CompanyFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute(input: input);

      if (response is Company) {
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
