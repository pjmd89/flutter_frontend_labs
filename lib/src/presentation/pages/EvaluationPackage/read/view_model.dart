import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getEvaluationPackages/getexamresults_query.dart';
import '/src/domain/extensions/edgeevaluationpackage_fields_builder_extension.dart';
import '/src/domain/usecases/EvaluationPackage/read_evaluationpackage_usecase.dart';

class ViewModel extends ChangeNotifier {
  // Estados privados
  bool _loading = false;
  bool _error = false;
  List<EvaluationPackage>? _evaluationPackageList;
  PageInfo? _pageInfo;

  // Dependencias
  late GqlConn _gqlConn;
  late ReadEvaluationPackageUsecase _readUseCase;
  late LaboratoryNotifier _laboratoryNotifier;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetExamResultsQuery _operation = GetExamResultsQuery(
    builder: EdgeEvaluationPackageFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<EvaluationPackage>? get evaluationPackageList => _evaluationPackageList;
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

  set evaluationPackageList(List<EvaluationPackage>? value) {
    _evaluationPackageList = value;
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
    _readUseCase = ReadEvaluationPackageUsecase(
      operation: _operation,
      conn: _gqlConn,
    );
    
    // Escuchar cambios en el laboratorio seleccionado
    _laboratoryNotifier.addListener(_onLaboratoryChanged);
    
    _init();
  }

  /// Se ejecuta cuando cambia el laboratorio seleccionado
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando paquetes de evaluación...');
    getEvaluationPackages();
  }
  
  @override
  void dispose() {
    _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    super.dispose();
  }

  // Inicialización - Carga datos al crear el ViewModel
  Future<void> _init() async {
    await getEvaluationPackages();
  }

  // Obtener todos los paquetes de evaluación (sin filtros)
  Future<void> getEvaluationPackages() async {
    loading = true;
    error = false;

    debugPrint('🔍 getEvaluationPackages - Iniciando carga sin filtros');

    try {
      final response = await _readUseCase.build();

      debugPrint('✅ getEvaluationPackages - Respuesta recibida');

      if (response is EdgeEvaluationPackage) {
        evaluationPackageList = response.edges;
        pageInfo = response.pageInfo;
        debugPrint('📦 getEvaluationPackages - ${response.edges.length} registros cargados');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getEvaluationPackages: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      evaluationPackageList = [];

      // Mostrar error al usuario
      
    } finally {
      loading = false;
    }
  }

  // Buscar paquetes de evaluación con filtros
  Future<void> search(List<SearchInput> searchInputs) async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.search(searchInputs, _pageInfo);

      if (response is EdgeEvaluationPackage) {
        evaluationPackageList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      evaluationPackageList = [];

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
