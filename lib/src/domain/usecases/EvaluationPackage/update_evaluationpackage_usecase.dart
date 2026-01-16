import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:flutter/foundation.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/mutations/updateEvaluationPackage/updateevaluationpackage_mutation.dart';

class UpdateEvaluationPackageUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;
  UpdateEvaluationPackageUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic> build() async {
    _conn.operation(operation: _operation, callback: callback);
  }
  
  callback(Object ob) {
    //final thisObject = ob as EvaluationPackage;
  }

  Future<dynamic> execute({required UpdateEvaluationInput input}) async {
    try {
      // Crear nueva mutation con declarativeArgs
      final mutation = _operation as UpdateEvaluationPackageMutation;
      final newMutation = UpdateEvaluationPackageMutation(
        builder: mutation.builder,
        declarativeArgs: {"input": "UpdateEvaluationInput!"},
        opArgs: {"input": GqlVar("input")},
      );

      debugPrint('🔧 Ejecutando UpdateEvaluationPackageMutation con input: ${input.toJson()}');

      // Ejecutar operación con input serializado
      final response = await _conn.operation(
        operation: newMutation,
        variables: {"input": input.toJson()},
      );

      debugPrint('✅ Response recibido: $response');

      // Transformar respuesta a entidad
      if (response != null && response is Map<String, dynamic>) {
        return newMutation.result(response);
      }

      return null;
    } catch (e, stackTrace) {
      debugPrint('💥 Error en UpdateEvaluationPackageUsecase.execute: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
