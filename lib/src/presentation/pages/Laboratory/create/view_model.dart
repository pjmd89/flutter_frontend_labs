import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createLaboratory/createlaboratory_mutation.dart';
import '/src/domain/operation/queries/getCompanies/getcompanies_query.dart';
import '/src/domain/usecases/Laboratory/create_laboratory_usecase.dart';
import '/src/domain/usecases/Company/read_company_usecase.dart';
import '/src/domain/extensions/edgecompany_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';
import '/l10n/app_localizations.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  bool _loadingCompanies = false;
  List<Company> _companies = [];

  final CreateLaboratoryInput input = CreateLaboratoryInput();

  List<Company> get companies => _companies;
  bool get loadingCompanies => _loadingCompanies;

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    _loadingCompanies = true;
    notifyListeners();

    try {
      ReadCompanyUsecase readCompanyUsecase = ReadCompanyUsecase(
        operation: GetCompaniesQuery(
          builder: EdgeCompanyFieldsBuilder().defaultValues(),
        ),
        conn: _gqlConn,
      );

      var response = await readCompanyUsecase.readWithoutPaginate();

      if (response is EdgeCompany) {
        _companies = response.edges;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al cargar empresas: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      _companies = [];
    } finally {
      _loadingCompanies = false;
      notifyListeners();
    }
  }

  Future<bool> create() async {
    bool isError = true;
    loading = true;

    CreateLaboratoryUsecase useCase = CreateLaboratoryUsecase(
      operation: CreateLaboratoryMutation(builder: LaboratoryFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      // Limpiar campos opcionales vacíos antes de enviar
      // companyID es opcional - si no se proporciona, el servidor lo asignará automáticamente
      // o se puede enviar para asociar a una compañía existente
      if (input.companyID == null || input.companyID!.isEmpty) {
        input.companyID = null;
      }

      // Limpiar contactPhoneNumbers si está vacío
      if (input.contactPhoneNumbers == null ||
          input.contactPhoneNumbers!.isEmpty) {
        input.contactPhoneNumbers = null;
      }

      var response = await useCase.execute(input: input);

      if (response is Laboratory) {
        isError = false;

        // Mostrar mensaje de éxito
        final l10n = AppLocalizations.of(_context)!;
        _errorService.showError(
          message: l10n.thingCreatedSuccessfully('Laboratorio'),
          type: ErrorType.success,
        );
      } else {
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en create laboratory: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;

      // Mostrar error al usuario
      _errorService.showError(
        message: 'Error al crear laboratorio: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
