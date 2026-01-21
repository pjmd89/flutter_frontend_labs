import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:flutter/foundation.dart';
import '/src/domain/entities/types/exam/inputs/updateexaminput_input.dart';
import '/src/domain/operation/mutations/updateExam/updateexam_mutation.dart';


class UpdateExamUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;
  UpdateExamUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic>build() async {
    _conn.operation(operation: _operation, callback: callback);
  }
  
  Future<dynamic> execute({required UpdateExamInput input}) async {
    debugPrint('🔧 UpdateExamUsecase.execute() iniciado con input: ${input.toJson()}');
    
    // Crear nueva instancia de mutation con declarativeArgs
    final mutation = _operation as UpdateExamMutation;
    mutation.declarativeArgs = {
      "input": "UpdateExamInput!",
    };
    mutation.opArgs = {"input": GqlVar("input")};
    
    debugPrint('📤 Ejecutando mutation con variables');
    
    try {
      var result = await _conn.operation(
        operation: mutation,
        variables: {'input': input.toJson()},
      );
      
      debugPrint('✅ Mutation ejecutada exitosamente. Tipo de resultado: ${result.runtimeType}');
      return result;
    } catch (e, stackTrace) {
      debugPrint('💥 Error en execute(): $e');
      debugPrint('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
  
  callback(Object ob) {
    //final thisObject = ob as {YourEntityType};
  }
}
