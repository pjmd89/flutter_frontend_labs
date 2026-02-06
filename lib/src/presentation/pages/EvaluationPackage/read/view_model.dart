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
  List<EvaluationPackage>? _originalEvaluationPackageList; // Copia original para filtrado
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
    // Guardar copia original cuando se actualizan los datos desde el backend
    if (value != null) {
      _originalEvaluationPackageList = List.from(value);
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
    // Si no hay filtros de búsqueda, recargar datos normales
    if (searchInputs.isEmpty) {
      await getEvaluationPackages();
      return;
    }
    
    // Si hay paquetes cargados, filtrar del lado del cliente
    if (_originalEvaluationPackageList != null && _originalEvaluationPackageList!.isNotEmpty) {
      debugPrint('🔍 Filtrando ${_originalEvaluationPackageList!.length} paquetes del lado del cliente');
      
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
        evaluationPackageList = _originalEvaluationPackageList;
        return;
      }
      
      // Filtrar paquetes por referred, status, o datos del paciente
      final filtered = _originalEvaluationPackageList!.where((pkg) {
        final referred = pkg.referred.toLowerCase();
        final status = pkg.status?.name.toLowerCase() ?? '';
        
        // Buscar en datos del paciente (Person o Animal)
        String patientName = '';
        if (pkg.patient?.isPerson == true) {
          final person = pkg.patient?.asPerson;
          patientName = '${person?.firstName ?? ''} ${person?.lastName ?? ''}'.toLowerCase();
        } else if (pkg.patient?.isAnimal == true) {
          final animal = pkg.patient?.asAnimal;
          patientName = '${animal?.firstName ?? ''} ${animal?.lastName ?? ''}'.toLowerCase();
        }
        
        return referred.contains(searchText) ||
               status.contains(searchText) ||
               patientName.contains(searchText);
      }).toList();
      
      debugPrint('✅ Resultados filtrados: ${filtered.length}');
      
      // Actualizar la lista mostrada (sin guardar en _originalEvaluationPackageList)
      _evaluationPackageList = filtered;
      
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
