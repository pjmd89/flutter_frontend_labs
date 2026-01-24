import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:flutter/foundation.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/extensions/user_logged_builder/main.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/setCurrentLaboratory/setcurrentlaboratory_mutation.dart';

class SetCurrentLaboratoryUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;

  SetCurrentLaboratoryUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
       _conn = conn;

  @override
  Future<dynamic> build() async {
    return _conn.operation(operation: _operation, callback: callback);
  }

  callback(Object ob) {
    // final thisObject = ob as LoggedUser;
  }

  /// Ejecuta la mutación setCurrentLaboratory con el ID del laboratorio
  Future<LoggedUser?> execute({required String laboratoryId}) async {
    try {
      LoggedUserFieldsBuilder fieldsBuilder = LoggedUserFieldsBuilder().defaultValues();

      SetCurrentLaboratoryMutation mutation = SetCurrentLaboratoryMutation(
        declarativeArgs: {
          "laboratoryID": 'ID!',
        },
        builder: fieldsBuilder,
        opArgs: {
          "laboratoryID": GqlVar("laboratoryID")
        }
      );

      debugPrint('🔧 Ejecutando setCurrentLaboratory con laboratoryID: $laboratoryId');

      var response = await _conn.operation(
        operation: mutation,
        variables: {'laboratoryID': laboratoryId},
      );

      debugPrint('✅ setCurrentLaboratory response: ${response.runtimeType}');

      if (response is LoggedUser) {
        return response;
      }

      return null;
    } catch (e, stackTrace) {
      debugPrint('💥 Error en setCurrentLaboratory: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
