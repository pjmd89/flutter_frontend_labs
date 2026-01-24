import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getCompanies/getcompanies_query.dart';
import '/src/domain/extensions/edgecompany_fields_builder_extension.dart';
import '/src/domain/usecases/Company/read_company_usecase.dart';

class ViewModel extends ChangeNotifier {
  // Estados privados
  bool _loading = false;
  bool _error = false;
  List<Company>? _companyList;
  PageInfo? _pageInfo;

  // Dependencias
  late GqlConn _gqlConn;
  late ReadCompanyUsecase _readUseCase;
  late LaboratoryNotifier _laboratoryNotifier;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetCompaniesQuery _operation = GetCompaniesQuery(
    builder: EdgeCompanyFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<Company>? get companyList => _companyList;
  PageInfo? get pageInfo => _pageInfo;

  // Setters con notificación
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set companyList(List<Company>? value) {
    _companyList = value;
    notifyListeners();
  }

  set pageInfo(PageInfo? value) {
    _pageInfo = value;
    notifyListeners();
  }

  // Constructor - Inicializa dependencias
  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _laboratoryNotifier = _context.read<LaboratoryNotifier>();
    _readUseCase = ReadCompanyUsecase(operation: _operation, conn: _gqlConn);
    
    // Escuchar cambios en el laboratorio seleccionado
    _laboratoryNotifier.addListener(_onLaboratoryChanged);
    
    _init();
  }

  /// Se ejecuta cuando cambia el laboratorio seleccionado
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando empresas...');
    getCompanies();
  }
  
  @override
  void dispose() {
    _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    super.dispose();
  }

  // Inicialización - Carga datos al crear el ViewModel
  Future<void> _init() async {
    await getCompanies();
  }

  // Obtener todas las empresas (sin filtros)
  Future<void> getCompanies() async {
    loading = true;
    error = false;

    try {
      debugPrint('🔍 Llamando a getCompanies...');
      final response = await _readUseCase.build();
      debugPrint('📦 Respuesta recibida: ${response.runtimeType}');

      if (response is EdgeCompany) {
        debugPrint('✅ EdgeCompany detectado');
        debugPrint('📊 Número de empresas: ${response.edges.length}');
        companyList = response.edges;
        pageInfo = response.pageInfo;
      } else {
        debugPrint('❌ Respuesta no es EdgeCompany: $response');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getCompanies: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      companyList = [];

      // Mostrar error al usuario
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al cargar empresas: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  // Buscar empresas con filtros
  Future<void> search(List<SearchInput> searchInputs) async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.search(searchInputs, _pageInfo);

      if (response is EdgeCompany) {
        companyList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search companies: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      companyList = [];

      // Mostrar error al usuario
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al buscar empresas: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  // Cambiar de página
  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]); // Recargar con la nueva página
  }
}
