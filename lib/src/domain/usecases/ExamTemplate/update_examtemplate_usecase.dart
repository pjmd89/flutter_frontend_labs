import 'dart:async';
import 'package:agile_front/agile_front.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:flutter/foundation.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/mutations/updateExamTemplate/updateexamtemplate_mutation.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/extensions/examtemplate_fields_builder_extension.dart';

class UpdateExamTemplateUsecase {
  final GqlConn _conn;
  
  UpdateExamTemplateUsecase({
    required UpdateExamTemplateMutation operation,
    required GqlConn conn,
  }) : _conn = conn;

  Future<dynamic> execute({required UpdateExamTemplateInput input}) async {
    try {
      debugPrint('🚀 UpdateExamTemplateUsecase.execute() - Input: ${input.toJson()}');
      
      // Crear nueva mutation con declarativeArgs
      final mutation = UpdateExamTemplateMutation(
        builder: ExamTemplateFieldsBuilder().defaultValues(),
        declarativeArgs: {"input": "UpdateExamTemplateInput!"},
        opArgs: {"input": GqlVar("input")},
      );
      
      debugPrint('🔧 Mutation build: ${mutation.build()}');
      
      final response = await _conn.operation(
        operation: mutation,
        variables: {"input": input.toJson()},
      );
      
      debugPrint('📦 Response recibida: ${response.runtimeType}');
      
      // Si el response ya es un ExamTemplate, retornarlo directamente
      if (response is ExamTemplate) {
        debugPrint('✅ Response es directamente un ExamTemplate');
        return response;
      }
      
      // Si es un Map, transformar con mutation.result()
      if (response != null && response is Map<String, dynamic>) {
        debugPrint('🔄 Transformando Map a ExamTemplate');
        return mutation.result(response);
      }
      
      debugPrint('⚠️ Response es null o tipo inesperado');
      return null;
    } catch (e, stackTrace) {
      debugPrint('💥 Error en UpdateExamTemplateUsecase.execute(): $e');
      debugPrint('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
