import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/edgelaboratory_fields_builder_extension.dart';
import 'package:labs/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import 'package:labs/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<Laboratory>? _laboratoryList; // Cambiado de User a Laboratory
  List<Laboratory>? _originalLaboratoryList; // Copia original para filtrado
  PageInfo? _pageInfo;

  late GqlConn _gqlConn;
  late ReadLaboratoryUsecase _readUseCase;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetLaboratoriesQuery _operation = GetLaboratoriesQuery(
    builder: EdgeLaboratoryFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<Laboratory>? get laboratoryList => _laboratoryList;
  PageInfo? get pageInfo => _pageInfo;

  // Setters privados
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set laboratoryList(List<Laboratory>? value) {
    _laboratoryList = value;
    // Guardar copia original cuando se actualizan los datos desde el backend
    if (value != null) {
      _originalLaboratoryList = List.from(value);
    }
    notifyListeners();
  }

  set pageInfo(PageInfo? value) {
    _pageInfo = value;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _readUseCase = ReadLaboratoryUsecase(operation: _operation, conn: _gqlConn);
    _init();
  }

  Future<void> _init() async {
    await getLaboratory();
  }

  Future<void> getLaboratory() async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.build();

      if (response is EdgeLaboratory) {
        laboratoryList = response.edges; // Descomenta y usa laboratoryList
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getLaboratorios: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      laboratoryList = [];

      // Mostrar error al usuario
     
    } finally {
      loading = false;
    }
  }

  Future<void> search(List<SearchInput> searchInputs) async {
    // Si no hay filtros de búsqueda, recargar datos normales
    if (searchInputs.isEmpty) {
      await getLaboratory();
      return;
    }
    
    // Si hay laboratorios cargados, filtrar del lado del cliente
    if (_originalLaboratoryList != null && _originalLaboratoryList!.isNotEmpty) {
      debugPrint('🔍 Filtrando ${_originalLaboratoryList!.length} laboratorios del lado del cliente');
      
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
        // Sin texto, mostrar todos
        laboratoryList = _originalLaboratoryList;
        return;
      }
      
      // Filtrar laboratorios por name (desde company) y address
      final filtered = _originalLaboratoryList!.where((laboratory) {
        final companyName = laboratory.company?.name.toLowerCase() ?? '';
        final address = laboratory.address.toLowerCase();
        
        return companyName.contains(searchText) ||
               address.contains(searchText);
      }).toList();
      
      debugPrint('✅ Resultados filtrados: ${filtered.length}');
      
      // Actualizar la lista mostrada (sin guardar en _originalLaboratoryList)
      _laboratoryList = filtered;
      
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

      if (response is EdgeLaboratory) {
        laboratoryList = response.edges; // Cambiado de userList a laboratoryList
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search laboratories: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      laboratoryList = [];

      // Mostrar error al usuario
      
    } finally {
      loading = false;
    }
  }

  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]); // Recargar con la nueva página
  }
}