import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/updatePatient/updatepatient_mutation.dart';
import 'package:labs/src/domain/operation/mutations/updatePerson/updateperson_mutation.dart';
import 'package:labs/src/domain/usecases/Patient/update_patient_usecase.dart';
import 'package:labs/src/domain/usecases/Person/update_person_usecase.dart';
import 'package:labs/src/domain/usecases/Patient/read_patient_usecase.dart';
import 'package:labs/src/domain/operation/queries/getPatients/getpatients_query.dart';
import 'package:labs/src/domain/extensions/edgepatient_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/patient_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/person_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';


class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;
  bool _error = false;
  
  final UpdatePatientInput inputPatient = UpdatePatientInput();
  final UpdatePersonInput inputPerson = UpdatePersonInput();
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
          
          // Extraer datos del objeto Person o Animal
          String firstName = '';
          String lastName = '';
          String dni = '';
          String phone = '';
          String email = '';
          String address = '';
          
          if (_currentPatient!.isPerson) {
            final person = _currentPatient!.asPerson!;
            firstName = person.firstName;
            lastName = person.lastName;
            dni = person.dni;
            phone = person.phone;
            email = person.email;
            address = person.address;
          } else if (_currentPatient!.isAnimal) {
            final animal = _currentPatient!.asAnimal!;
            firstName = animal.firstName;
            lastName = animal.lastName;
            // Animal no tiene dni, phone, email, address - dejar vacíos
          }
          
          debugPrint('✅ Paciente cargado: $firstName $lastName');
          
          // Prellenar input según el tipo de paciente
          if (_currentPatient!.isPerson) {
            // Prellenar inputPerson para pacientes humanos
            final person = _currentPatient!.asPerson!;
            inputPerson.id = _currentPatient!.id;
            inputPerson.firstName = firstName;
            inputPerson.lastName = lastName;
            inputPerson.dni = dni.isNotEmpty ? dni : null;
            inputPerson.phone = phone.isNotEmpty ? phone : null;
            inputPerson.email = email.isNotEmpty ? email : null;
            inputPerson.address = address.isNotEmpty ? address : null;
            
            // ✅ Prellenar birthDate en formato DD/MM/YYYY HH:MM si existe
            if (person.birthDate != null && person.birthDate! > 0) {
              try {
                final date = DateTime.fromMillisecondsSinceEpoch(person.birthDate! * 1000);
                final day = date.day.toString().padLeft(2, '0');
                final month = date.month.toString().padLeft(2, '0');
                final year = date.year.toString();
                inputPerson.birthDate = '$day/$month/$year 00:00';
                debugPrint('✅ birthDate prellenado: ${inputPerson.birthDate}');
              } catch (e) {
                debugPrint('⚠️ Error formateando birthDate para inputPerson: $e');
              }
            }
          } else if (_currentPatient!.isAnimal) {
            // Prellenar inputPatient para pacientes animales
            final animal = _currentPatient!.asAnimal!;
            inputPatient.id = _currentPatient!.id;
            
            // ✅ Prellenar birthDate en formato DD/MM/YYYY HH:MM si existe
            String? formattedBirthDate;
            if (animal.birthDate != null && animal.birthDate! > 0) {
              try {
                final date = DateTime.fromMillisecondsSinceEpoch(animal.birthDate! * 1000);
                final day = date.day.toString().padLeft(2, '0');
                final month = date.month.toString().padLeft(2, '0');
                final year = date.year.toString();
                formattedBirthDate = '$day/$month/$year 00:00';
                debugPrint('✅ birthDate prellenado: $formattedBirthDate');
              } catch (e) {
                debugPrint('⚠️ Error formateando birthDate para inputPatient: $e');
              }
            }
            
            // Para animals, usamos animalData
            inputPatient.animalData = UpdateAnimalPatientInput(
              firstName: firstName,
              lastName: lastName,
              birthDate: formattedBirthDate,
            );
          }
        } else {
          debugPrint('⚠️ No se encontró paciente con ID: $id en la lista');
          error = true;
         
        }
      } else if (response is EdgePatient && response.edges.isEmpty) {
        debugPrint('⚠️ EdgePatient sin datos - edges está vacío');
        error = true;
        
      } else {
        debugPrint('⚠️ Response no es EdgePatient. Tipo: ${response.runtimeType}');
        error = true;
        
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en loadData: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      
     
    } finally {
      loading = false;
    }
  }
  
  Future<bool> update() async {
    bool isError = true;
    loading = true;

    try {
      // ✅ Lógica condicional: ejecutar mutation según el tipo de paciente
      if (_currentPatient!.isPerson) {
        // 🟢 Paciente humano → usar updatePerson
        debugPrint('🔄 Actualizando persona (humano): ${inputPerson.toJson()}');
        
        UpdatePersonUsecase useCase = UpdatePersonUsecase(
          operation: UpdatePersonMutation(builder: PersonFieldsBuilder().defaultValues()),
          conn: _gqlConn,
        );
        
        var response = await useCase.execute(input: inputPerson);
        
        if (response is Person) {
          isError = false;
          debugPrint('✅ Persona actualizada exitosamente');
          
          // Actualizar _currentPatient con los nuevos datos
          _currentPatient = Patient(
            id: response.id,
            patientType: PatientType.hUMAN,
            patientData: response,
            laboratory: _currentPatient!.laboratory,
            created: _currentPatient!.created,
            updated: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          );
        }
      } else if (_currentPatient!.isAnimal) {
        // 🟡 Paciente animal → usar updatePatient
        debugPrint('🔄 Actualizando paciente (animal): ${inputPatient.toJson()}');
        
        UpdatePatientUsecase useCase = UpdatePatientUsecase(
          operation: UpdatePatientMutation(builder: PatientFieldsBuilder().defaultValues()),
          conn: _gqlConn,
        );
        
        var response = await useCase.execute(input: inputPatient);
        
        if (response is Patient) {
          isError = false;
          _currentPatient = response;
          debugPrint('✅ Paciente (animal) actualizado exitosamente');
        }
      } else {
        debugPrint('⚠️ Tipo de paciente desconocido');
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en update: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
    } finally {
      loading = false;
    }

    return isError;
  }
}
