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
      debugPrint('🔍 Response type: ${response.runtimeType}');

      // Si la respuesta es ErrorReturned, el ErrorManager ya mostró el mensaje
      // Solo lanzar excepción silenciosa para evitar mostrar mensaje duplicado
      if (response.runtimeType.toString() == 'ErrorReturned') {
        debugPrint('❌ Response es ErrorReturned - error controlado del backend');
        throw Exception('Backend error handled');
      }

      // Si la respuesta es null, hubo un error controlado del backend
      if (response == null) {
        debugPrint('❌ Response es null - hubo error controlado del backend');
        throw Exception('Backend error handled');
      }

      // Si la respuesta ya es un EvaluationPackage, devolverla directamente
      if (response is EvaluationPackage) {
        debugPrint('✅ Response ya es EvaluationPackage, retornándola directamente');
        return response;
      }

      // Si es Map, transformarla
      if (response is Map<String, dynamic>) {
        final result = newMutation.result(response);
        debugPrint('✅ Result from mutation.result(): $result (${result.runtimeType})');
        return result;
      }

      debugPrint('❌ Response no es ni EvaluationPackage ni Map<String, dynamic>');
      throw Exception('Error: Tipo de respuesta inesperado: ${response.runtimeType}');
    } catch (e, stackTrace) {
      debugPrint('💥 Error en UpdateEvaluationPackageUsecase.execute: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
