import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/updatePatient/updatepatient_mutation.dart';
import 'package:labs/src/domain/usecases/Patient/update_patient_usecase.dart';
import 'package:labs/src/domain/usecases/Patient/read_patient_usecase.dart';
import 'package:labs/src/domain/operation/queries/getPatients/getpatients_query.dart';
import 'package:labs/src/domain/extensions/edgepatient_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/patient_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;
  bool _error = false;
  
  final UpdatePatientInput input = UpdatePatientInput();
  Patient? _currentPatient;
  
  Patient? get currentPatient => _currentPatient;
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
  
  ViewModel({
    required BuildContext context,
    required String patientId,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    loadData(patientId);
  }
  
  AppLocalizations get l10n => AppLocalizations.of(_context)!;
  
  Future<void> loadData(String id) async {
    loading = true;
    error = false;
    
    try {
      debugPrint('🔍 Cargando paciente con ID: $id');
      
      // Usar build() para obtener todos los pacientes y filtrar en memoria
      ReadPatientUsecase useCase = ReadPatientUsecase(
        operation: GetPatientsQuery(builder: EdgePatientFieldsBuilder().defaultValues()),
        conn: _gqlConn,
      );
      
      var response = await useCase.build();
      
      debugPrint('🔍 Tipo de response: ${response.runtimeType}');
      
      if (response is EdgePatient && response.edges.isNotEmpty) {
        // Filtrar paciente por ID en memoria
        final patients = response.edges.where((patient) => patient.id == id).toList();
        
        if (patients.isNotEmpty) {
          _currentPatient = patients.first;
          debugPrint('✅ Paciente cargado: ${_currentPatient!.firstName} ${_currentPatient!.lastName}');
          
          // Prellenar input con datos existentes
          input.id = _currentPatient!.id;
          input.firstName = _currentPatient!.firstName;
          input.lastName = _currentPatient!.lastName;
          input.dni = _currentPatient!.dni;
          input.phone = _currentPatient!.phone;
          input.email = _currentPatient!.email;
          input.address = _currentPatient!.address;
          // Convertir birthDate de timestamp (int) a String en formato ISO
          if (_currentPatient!.birthDate != null && _currentPatient!.birthDate! > 0) {
            final date = DateTime.fromMillisecondsSinceEpoch(_currentPatient!.birthDate! * 1000);
            input.birthDate = date.toIso8601String();
          }
        } else {
          debugPrint('⚠️ No se encontró paciente con ID: $id en la lista');
          error = true;
          _context.read<GQLNotifier>().errorService.showError(
            message: 'No se encontró el paciente con ID: $id',
          );
        }
      } else if (response is EdgePatient && response.edges.isEmpty) {
        debugPrint('⚠️ EdgePatient sin datos - edges está vacío');
        error = true;
        _context.read<GQLNotifier>().errorService.showError(
          message: 'No hay pacientes en el sistema',
        );
      } else {
        debugPrint('⚠️ Response no es EdgePatient. Tipo: ${response.runtimeType}');
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
        message: 'Error al cargar paciente: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }
  
  Future<bool> update() async {
    bool isError = true;
    loading = true;

    UpdatePatientUsecase useCase = UpdatePatientUsecase(
      operation: UpdatePatientMutation(builder: PatientFieldsBuilder().defaultValues()),
      conn: _gqlConn,
    );

    try {
      debugPrint('🔄 Actualizando paciente: ${input.toJson()}');
      
      var response = await useCase.execute(input: input);
      
      if (response is Patient) {
        isError = false;
        _currentPatient = response;
        debugPrint('✅ Paciente actualizado exitosamente');
        
        _context.read<GQLNotifier>().errorService.showError(
          message: '${l10n.patient} actualizado exitosamente',
          type: ErrorType.success,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en updatePatient: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al actualizar paciente: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
