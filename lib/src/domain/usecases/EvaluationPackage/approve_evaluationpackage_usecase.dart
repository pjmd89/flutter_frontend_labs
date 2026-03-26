import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:flutter/foundation.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/mutations/approveEvaluationPackage/approveevaluationpackage_mutation.dart';

class ApproveEvaluationPackageUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;
  ApproveEvaluationPackageUsecase({
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

  Future<dynamic> execute({required ApproveEvaluationInput input}) async {
    try {
      // Crear nueva mutation con declarativeArgs
      final mutation = _operation as ApproveEvaluationPackageMutation;
      final newMutation = ApproveEvaluationPackageMutation(
        builder: mutation.builder,
        declarativeArgs: {"input": "ApproveEvaluationInput!"},
        opArgs: {"input": GqlVar("input")},
      );

      debugPrint('🔧 Ejecutando ApproveEvaluationPackageMutation con input: ${input.toJson()}');

      // Ejecutar operación con input
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

      // La respuesta ya viene deserializada como EvaluationPackage
      // No es necesario llamar a mutation.result() porque causaría error de tipos
      debugPrint('✅ Response es EvaluationPackage: ${response is EvaluationPackage}');

      return response;
    } catch (e, stackTrace) {
      debugPrint('💥 Error en ApproveEvaluationPackageUsecase.execute: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
