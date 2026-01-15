import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/extensions/exam_fields_builder_extension.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createExam/createexam_mutation.dart';

class CreateExamUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;
  CreateExamUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic> build() async {
    _conn.operation(operation: _operation, callback: callback);
  }
  
  callback(Object ob) {
    // final thisObject = ob as Exam;
  }

  Future<dynamic> execute({required CreateExamInput input}) async {
    ExamFieldsBuilder fieldsBuilder = ExamFieldsBuilder().defaultValues();
    
    CreateExamMutation mutation = CreateExamMutation(
      declarativeArgs: {
        "name": 'CreateExamInput!',
      },
      builder: fieldsBuilder,
      opArgs: {
        "input": GqlVar("name")
      }
    );
    
    var response = await _conn.operation(
      operation: mutation,
      variables: {'name': input},
    );
    
    return response;
  }
}
