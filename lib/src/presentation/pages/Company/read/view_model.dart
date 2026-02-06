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
  List<Company>? _originalCompanyList; // Copia original para filtrado
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
    // Guardar copia original cuando se actualizan los datos desde el backend
    if (value != null) {
      _originalCompanyList = List.from(value);
    }
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
     
    } finally {
      loading = false;
    }
  }

  // Buscar empresas con filtros
  Future<void> search(List<SearchInput> searchInputs) async {
    // Si no hay filtros de búsqueda, recargar datos normales
    if (searchInputs.isEmpty) {
      await getCompanies();
      return;
    }
    
    // Si hay empresas cargadas, filtrar del lado del cliente
    if (_originalCompanyList != null && _originalCompanyList!.isNotEmpty) {
      debugPrint('🔍 Filtrando ${_originalCompanyList!.length} empresas del lado del cliente');
      
      // Extraer el texto de búsqueda del primer SearchInput
      String searchText = '';
      if (searchInputs.isNotEmpty && 
          searchInputs[0].value != null && 
          searchInputs[0].value!.isNotEmpty &&
          searchInputs[0].value![0]?.value != null) {
        searchText = searchInputs[0].value![0]!.value.toString().toLowerCase();
      }
      
      debugPrint('🔍 Texto de búsqueda: "$searchText"');
      
      if (searchText.isEmpty) {
        // Sin texto, mostrar todas
        companyList = _originalCompanyList;
        return;
      }
      
      // Filtrar empresas por name o taxID
      final filtered = _originalCompanyList!.where((company) {
        final name = company.name.toLowerCase();
        final taxID = company.taxID.toLowerCase();
        
        return name.contains(searchText) ||
               taxID.contains(searchText);
      }).toList();
      
      debugPrint('✅ Resultados filtrados: ${filtered.length}');
      
      // Actualizar la lista mostrada (sin guardar en _originalCompanyList)
      _companyList = filtered;
      
      // Actualizar pageInfo para reflejar los resultados filtrados
      if (_pageInfo != null) {
        _pageInfo = PageInfo(
          total: filtered.length,
          page: 1,
          pages: (filtered.length / (_pageInfo!.split > 0 ? _pageInfo!.split : 10)).ceil(),
          split: _pageInfo!.split,
        );
      }
      
      notifyListeners();
      return;
    }
    
    // Si no hay datos cargados, intentar búsqueda en el backend (fallback)
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
