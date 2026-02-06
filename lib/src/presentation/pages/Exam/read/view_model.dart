import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getExams/getexams_query.dart';
import '/src/domain/extensions/edgeexam_fields_builder_extension.dart';
import '/src/domain/usecases/Exam/read_exam_usecase.dart';


class ViewModel extends ChangeNotifier {
  // Estados privados
  bool _loading = false;
  bool _error = false;
  List<Exam>? _examList;
  List<Exam>? _originalExamList; // Copia original para filtrado
  PageInfo? _pageInfo;

  // Dependencias
  late GqlConn _gqlConn;
  late ReadExamUsecase _readUseCase;
  late LaboratoryNotifier _laboratoryNotifier;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetExamsQuery _operation = GetExamsQuery(
    builder: EdgeExamFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<Exam>? get examList => _examList;
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

  set examList(List<Exam>? value) {
    _examList = value;
    // Guardar copia original cuando se actualizan los datos desde el backend
    if (value != null) {
      _originalExamList = List.from(value);
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
    _readUseCase = ReadExamUsecase(operation: _operation, conn: _gqlConn);
    
    // Escuchar cambios en el laboratorio seleccionado
    _laboratoryNotifier.addListener(_onLaboratoryChanged);
    
    _init();
  }

  /// Se ejecuta cuando cambia el laboratorio seleccionado
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando exámenes...');
    getExams();
  }
  
  @override
  void dispose() {
    _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    super.dispose();
  }

  // Inicialización - Carga datos al crear el ViewModel
  Future<void> _init() async {
    await getExams();
  }

  // Obtener todos los exámenes (sin filtros)
  Future<void> getExams() async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.build();

      if (response is EdgeExam) {
        examList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getExams: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      examList = [];
      
     
    } finally {
      loading = false;
    }
  }

  // Buscar exámenes con filtros
  Future<void> search(List<SearchInput> searchInputs) async {
    // Si no hay filtros de búsqueda, recargar datos normales
    if (searchInputs.isEmpty) {
      await getExams();
      return;
    }
    
    // Si hay exámenes cargados, filtrar del lado del cliente
    if (_originalExamList != null && _originalExamList!.isNotEmpty) {
      debugPrint('🔍 Filtrando ${_originalExamList!.length} exámenes del lado del cliente');
      
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
        examList = _originalExamList;
        return;
      }
      
      // Filtrar exámenes por template.name y baseCost
      final filtered = _originalExamList!.where((exam) {
        final templateName = exam.template?.name?.toLowerCase() ?? '';
        final baseCost = exam.baseCost.toString().toLowerCase();
        
        return templateName.contains(searchText) ||
               baseCost.contains(searchText);
      }).toList();
      
      debugPrint('✅ Resultados filtrados: ${filtered.length}');
      
      // Actualizar la lista mostrada (sin guardar en _originalExamList)
      _examList = filtered;
      
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

      if (response is EdgeExam) {
        examList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      examList = [];
      
     
    } finally {
      loading = false;
    }
  }

  // Cambiar de página
  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]);
  }
}
