import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createPatient/createpatient_mutation.dart';
import '/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import '/src/domain/usecases/Patient/create_patient_usecase.dart';
import '/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import '/src/domain/extensions/edgelaboratory_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';


class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  bool _loadingLaboratories = false;
  List<Laboratory> _laboratories = [];

  final CreatePatientInput input = CreatePatientInput();

  List<Laboratory> get laboratories => _laboratories;
  bool get loadingLaboratories => _loadingLaboratories;

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    _loadLaboratories();
  }

  Future<void> _loadLaboratories() async {
    _loadingLaboratories = true;
    notifyListeners();

    try {
      debugPrint('🔍 Iniciando carga de laboratorios...');
      
      ReadLaboratoryUsecase readLaboratoryUsecase = ReadLaboratoryUsecase(
        operation: GetLaboratoriesQuery(
          builder: EdgeLaboratoryFieldsBuilder().defaultValues(),
        ),
        conn: _gqlConn,
      );

      debugPrint('🚀 Ejecutando readWithoutPaginate...');
      var response = await readLaboratoryUsecase.readWithoutPaginate();
      
      debugPrint('📦 Respuesta recibida: ${response.runtimeType}');
      debugPrint('📦 Contenido raw: $response');
      
      if (response is EdgeLaboratory) {
        debugPrint('✅ EdgeLaboratory detectado');
        debugPrint('📊 Número de laboratorios: ${response.edges.length}');
        
        // Intentar asignar uno por uno para ver cuál falla
        _laboratories = [];
        for (var i = 0; i < response.edges.length; i++) {
          try {
            final lab = response.edges[i];
            debugPrint('  ✅ Lab $i parseado: ID=${lab.id}, Address=${lab.address}');
            _laboratories.add(lab);
          } catch (e) {
            debugPrint('  ❌ Error en lab $i: $e');
          }
        }
        
        debugPrint('📊 Total laboratorios válidos: ${_laboratories.length}');
      } else if (response is Map) {
        debugPrint('⚠️ Respuesta es Map, intentando parseo manual...');
        debugPrint('   Keys: ${response.keys}');
        
        // Intentar parseo manual
        try {
          final edgeLab = EdgeLaboratory.fromJson(response as Map<String, dynamic>);
          _laboratories = edgeLab.edges;
          debugPrint('✅ Parseo manual exitoso: ${_laboratories.length} laboratorios');
        } catch (e, st) {
          debugPrint('❌ Error en parseo manual: $e');
          debugPrint('📍 StackTrace: $st');
          _laboratories = [];
        }
      } else {
        debugPrint('❌ Respuesta no es EdgeLaboratory ni Map');
        debugPrint('   Tipo recibido: ${response.runtimeType}');
        _laboratories = [];
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al cargar laboratorios: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      _laboratories = [];
      
      _errorService.showError(
        message: 'Error al cargar laboratorios: ${e.toString()}',
        type: ErrorType.error,
      );
    } finally {
      _loadingLaboratories = false;
      debugPrint('🏁 Carga de laboratorios finalizada. Total: ${_laboratories.length}');
      notifyListeners();
    }
  }

  Future<bool> create() async {
    bool isError = true;
    loading = true;

    CreatePatientUsecase useCase = CreatePatientUsecase(
      operation: CreatePatientMutation(builder: PatientFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      // Limpiar campos opcionales vacíos antes de enviar
      if (input.lastName == null || input.lastName!.isEmpty) {
        input.lastName = null;
      }

      if (input.birthDate == null || input.birthDate!.isEmpty) {
        input.birthDate = null;
      }

      if (input.species == null || input.species!.isEmpty) {
        input.species = null;
      }

      if (input.dni == null || input.dni!.isEmpty) {
        input.dni = null;
      }

      if (input.phone == null || input.phone!.isEmpty) {
        input.phone = null;
      }

      if (input.email == null || input.email!.isEmpty) {
        input.email = null;
      }

      if (input.address == null || input.address!.isEmpty) {
        input.address = null;
      }

      // 🐛 DEBUG: Mostrar valores del input antes de enviar
      debugPrint('📤 Enviando CreatePatientInput:');
      debugPrint('   firstName: ${input.firstName}');
      debugPrint('   lastName: ${input.lastName}');
      debugPrint('   sex: ${input.sex}');
      debugPrint('   birthDate: ${input.birthDate}');
      debugPrint('   species: ${input.species}');
      debugPrint('   dni: ${input.dni}');
      debugPrint('   phone: ${input.phone}');
      debugPrint('   email: ${input.email}');
      debugPrint('   address: ${input.address}');
      debugPrint('   laboratory: ${input.laboratory}');
      debugPrint('📦 Input JSON: ${input.toJson()}');

      var response = await useCase.execute(input: input);

      if (response is Patient) {
        isError = false;

        // Mostrar mensaje de éxito
      
      } else {
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en create patient: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;

      // Mostrar error al usuario
      _errorService.showError(
        message: 'Error al crear paciente: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
