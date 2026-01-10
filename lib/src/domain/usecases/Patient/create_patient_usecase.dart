import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:flutter/foundation.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/extensions/patient_fields_builder_extension.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createPatient/createpatient_mutation.dart';

class CreatePatientUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;

  CreatePatientUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
       _conn = conn;

  @override
  Future<dynamic> build() async {
    _conn.operation(operation: _operation, callback: callback);
  }

  callback(Object ob) {
    // final thisObject = ob as Patient;
  }

  Future<dynamic> execute({required CreatePatientInput input}) async {
    PatientFieldsBuilder fieldsBuilder = PatientFieldsBuilder().defaultValues();

    CreatePatientMutation mutation = CreatePatientMutation(
      declarativeArgs: {"name": 'CreatePatientInput!'},
      builder: fieldsBuilder,
      opArgs: {"input": GqlVar("name")},
    );

    // 🐛 DEBUG: Verificar input en UseCase
    debugPrint('🔧 UseCase - Input recibido:');
    debugPrint('   firstName: ${input.firstName}');
    debugPrint('   lastName: ${input.lastName}');
    debugPrint('   sex: ${input.sex}');
    debugPrint('   birthDate: ${input.birthDate}');
    debugPrint('   dni: ${input.dni}');
    debugPrint('   phone: ${input.phone}');
    debugPrint('   email: ${input.email}');
    debugPrint('   address: ${input.address}');
    debugPrint('   laboratory: ${input.laboratory}');
    debugPrint('🔧 UseCase - Input.toJson(): ${input.toJson()}');
    
    var response = await _conn.operation(
      operation: mutation,
      variables: {'name': input},
    );

    debugPrint('🔧 UseCase - Response: $response');
    return response;
  }
}
