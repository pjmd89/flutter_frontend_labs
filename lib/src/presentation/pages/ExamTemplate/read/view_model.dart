import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getExamTemplates/getexamtemplates_query.dart';
import '/src/domain/extensions/edgeexamtemplate_fields_builder_extension.dart';
import '/src/domain/usecases/ExamTemplate/read_examtemplate_usecase.dart';

class ViewModel extends ChangeNotifier {
  // Estados privados
  bool _loading = false;
  bool _error = false;
  List<ExamTemplate>? _examTemplateList;
  PageInfo? _pageInfo;

  // Dependencias
  late GqlConn _gqlConn;
  late ReadExamTemplateUsecase _readUseCase;
  late LaboratoryNotifier _laboratoryNotifier;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetExamTemplatesQuery _operation = GetExamTemplatesQuery(
    builder: EdgeExamTemplateFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<ExamTemplate>? get examTemplateList => _examTemplateList;
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

  set examTemplateList(List<ExamTemplate>? value) {
    _examTemplateList = value;
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
    _readUseCase = ReadExamTemplateUsecase(
      operation: _operation,
      conn: _gqlConn,
    );
    
    // Escuchar cambios en el laboratorio seleccionado
    _laboratoryNotifier.addListener(_onLaboratoryChanged);
    
    _init();
  }

  /// Se ejecuta cuando cambia el laboratorio seleccionado
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando plantillas de examen...');
    getExamTemplates();
  }
  
  @override
  void dispose() {
    _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    super.dispose();
  }

  // Inicialización - Carga datos al crear el ViewModel
  Future<void> _init() async {
    await getExamTemplates();
  }

  // Obtener todas las plantillas de examen (sin filtros)
  Future<void> getExamTemplates() async {
    loading = true;
    error = false;

    try {
      debugPrint('🔍 Llamando a getExamTemplates...');
      final response = await _readUseCase.build();
      debugPrint('📦 Respuesta recibida: ${response.runtimeType}');

      if (response is EdgeExamTemplate) {
        debugPrint('✅ EdgeExamTemplate detectado');
        debugPrint('📊 Número de plantillas: ${response.edges.length}');
        examTemplateList = response.edges;
        pageInfo = response.pageInfo;
      } else {
        debugPrint('❌ Respuesta no es EdgeExamTemplate: $response');
        error = true;
        examTemplateList = [];
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getExamTemplates: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      examTemplateList = [];

      // Mostrar error al usuario
      
    } finally {
      loading = false;
    }
  }

  // Buscar plantillas de examen con filtros
  Future<void> search(List<SearchInput> searchInputs) async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.search(searchInputs, _pageInfo);

      if (response is EdgeExamTemplate) {
        examTemplateList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      examTemplateList = [];

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
