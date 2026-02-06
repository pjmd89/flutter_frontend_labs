import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getPatients/getpatients_query.dart';
import '/src/domain/extensions/edgepatient_fields_builder_extension.dart';
import '/src/domain/usecases/Patient/read_patient_usecase.dart';

class ViewModel extends ChangeNotifier {
  // Estados privados
  bool _loading = false;
  bool _error = false;
  List<Patient>? _patientList;
  List<Patient>? _originalPatientList; // Copia original para filtrado
  PageInfo? _pageInfo;

  // Dependencias
  late GqlConn _gqlConn;
  late ReadPatientUsecase _readUseCase;
  late LaboratoryNotifier _laboratoryNotifier;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetPatientsQuery _operation = GetPatientsQuery(
    builder: EdgePatientFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<Patient>? get patientList => _patientList;
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

  set patientList(List<Patient>? value) {
    _patientList = value;
    // Guardar copia original cuando se actualizan los datos desde el backend
    if (value != null) {
      _originalPatientList = List.from(value);
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
    _readUseCase = ReadPatientUsecase(operation: _operation, conn: _gqlConn);
    
    // Escuchar cambios en el laboratorio seleccionado
    _laboratoryNotifier.addListener(_onLaboratoryChanged);
    
    _init();
  }

  /// Se ejecuta cuando cambia el laboratorio seleccionado
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando pacientes...');
    getPatients();
  }
  
  @override
  void dispose() {
    _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    super.dispose();
  }

  // Inicialización - Carga datos al crear el ViewModel
  Future<void> _init() async {
    await getPatients();
  }

  // Obtener todos los pacientes (sin filtros)
  Future<void> getPatients() async {
    loading = true;
    error = false;

    try {
      debugPrint('🔍 Llamando a getPatients...');
      final response = await _readUseCase.build();
      debugPrint('📦 Respuesta recibida: ${response.runtimeType}');

      if (response is EdgePatient) {
        debugPrint('✅ EdgePatient detectado');
        debugPrint('📊 Número de pacientes: ${response.edges.length}');
        patientList = response.edges;
        pageInfo = response.pageInfo;
      } else {
        debugPrint('❌ Respuesta no es EdgePatient: $response');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getPatients: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      patientList = [];

      // Mostrar error al usuario
      
    } finally {
      loading = false;
    }
  }

  // Buscar pacientes con filtros
  Future<void> search(List<SearchInput> searchInputs) async {
    // Si no hay filtros de búsqueda, recargar datos normales
    if (searchInputs.isEmpty) {
      await getPatients();
      return;
    }
    
    // Si hay pacientes cargados, filtrar del lado del cliente
    if (_originalPatientList != null && _originalPatientList!.isNotEmpty) {
      debugPrint('🔍 Filtrando ${_originalPatientList!.length} pacientes del lado del cliente');
      
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
        patientList = _originalPatientList;
        return;
      }
      
      // Filtrar pacientes por firstName, lastName, dni o email
      final filtered = _originalPatientList!.where((patient) {
        // Patient puede ser Person o Animal, necesitamos acceder a patientData
        if (patient.isPerson) {
          final person = patient.asPerson;
          if (person == null) return false;
          
          final firstName = person.firstName?.toLowerCase() ?? '';
          final lastName = person.lastName?.toLowerCase() ?? '';
          final dni = person.dni?.toLowerCase() ?? '';
          final email = person.email?.toLowerCase() ?? '';
          
          return firstName.contains(searchText) ||
                 lastName.contains(searchText) ||
                 dni.contains(searchText) ||
                 email.contains(searchText);
        } else if (patient.isAnimal) {
          final animal = patient.asAnimal;
          if (animal == null) return false;
          
          final firstName = animal.firstName?.toLowerCase() ?? '';
          final lastName = animal.lastName?.toLowerCase() ?? '';
          final species = animal.species?.toLowerCase() ?? '';
          
          return firstName.contains(searchText) ||
                 lastName.contains(searchText) ||
                 species.contains(searchText);
        }
        
        return false;
      }).toList();
      
      debugPrint('✅ Resultados filtrados: ${filtered.length}');
      
      // Actualizar la lista mostrada (sin guardar en _originalPatientList)
      _patientList = filtered;
      
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

      if (response is EdgePatient) {
        patientList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search patients: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      patientList = [];

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
