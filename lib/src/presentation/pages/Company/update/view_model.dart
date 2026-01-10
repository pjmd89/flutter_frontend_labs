import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/updateCompany/updatecompany_mutation.dart';
import 'package:labs/src/domain/usecases/Company/update_company_usecase.dart';
import 'package:labs/src/domain/usecases/Company/read_company_usecase.dart';
import 'package:labs/src/domain/operation/queries/getCompanies/getcompanies_query.dart';
import 'package:labs/src/domain/extensions/edgecompany_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;
  bool _error = false;

  final UpdateCompanyInput input = UpdateCompanyInput();
  Company? _currentCompany;

  Company? get currentCompany => _currentCompany;
  bool get loading => _loading;
  bool get error => _error;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool newError) {
    _error = newError;
    notifyListeners();
  }

  ViewModel({required BuildContext context, required String companyId})
    : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    loadData(companyId);
  }

  AppLocalizations get l10n => AppLocalizations.of(_context)!;

  Future<void> loadData(String id) async {
    loading = true;
    error = false;

    try {
      debugPrint('🔍 Cargando empresa con ID: $id');

      // Usar build() para obtener todas las empresas y filtrar en memoria
      ReadCompanyUsecase useCase = ReadCompanyUsecase(
        operation: GetCompaniesQuery(
          builder: EdgeCompanyFieldsBuilder().defaultValues(),
        ),
        conn: _gqlConn,
      );

      var response = await useCase.build();

      debugPrint('🔍 Tipo de response: ${response.runtimeType}');
      debugPrint('🔍 Response completo: $response');

      if (response is EdgeCompany && response.edges.isNotEmpty) {
        // Filtrar empresa por ID en memoria
        final companies =
            response.edges.where((company) => company.id == id).toList();

        if (companies.isNotEmpty) {
          _currentCompany = companies.first;
          debugPrint('✅ Empresa cargada: ${_currentCompany!.name}');

          // Prellenar input con datos existentes
          input.id = _currentCompany!.id;
          input.name = _currentCompany!.name;
          input.logo = _currentCompany!.logo;
          input.taxID = _currentCompany!.taxID;
        } else {
          debugPrint('⚠️ No se encontró empresa con ID: $id en la lista');
          error = true;
          _context.read<GQLNotifier>().errorService.showError(
            message: 'No se encontró la empresa con ID: $id',
          );
        }
      } else if (response is EdgeCompany && response.edges.isEmpty) {
        debugPrint('⚠️ EdgeCompany sin datos - edges está vacío');
        error = true;
        _context.read<GQLNotifier>().errorService.showError(
          message: 'No hay empresas en el sistema',
        );
      } else {
        debugPrint(
          '⚠️ Response no es EdgeCompany. Tipo: ${response.runtimeType}',
        );
        error = true;
        _context.read<GQLNotifier>().errorService.showError(
          message: 'Error al procesar respuesta del servidor',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en loadData: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;

      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al cargar empresa: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  Future<bool> update() async {
    bool isError = true;
    loading = true;

    UpdateCompanyUsecase useCase = UpdateCompanyUsecase(
      operation: UpdateCompanyMutation(builder: CompanyFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      debugPrint('🔄 Actualizando empresa: ${input.toJson()}');

      var response = await useCase.execute(input: input);

      if (response is Company) {
        isError = false;
        _currentCompany = response;
        debugPrint('✅ Empresa actualizada exitosamente');

        _context.read<GQLNotifier>().errorService.showError(
          message: '${l10n.company} actualizada exitosamente',
          type: ErrorType.success,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en updateCompany: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;

      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al actualizar empresa: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
