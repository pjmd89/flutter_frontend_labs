import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:agile_front/agile_front.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/mutations/updateUser/updateuser_mutation.dart';
import '/src/domain/extensions/user_fields_builder_extension.dart';
import '/src/domain/operation/fields_builders/main.dart';

class UpdateUserUsecase {
  final GqlConn _conn;

  UpdateUserUsecase({
    required UpdateUserMutation operation,
    required GqlConn conn,
  }) : _conn = conn;

  Future<dynamic> execute({required UpdateUserInput input}) async {
    try {
      // Crear nueva mutation con declarativeArgs
      final mutation = UpdateUserMutation(
        builder: UserFieldsBuilder().defaultValues(),
        declarativeArgs: {"input": "UpdateUserInput!"},
        opArgs: {"input": GqlVar("input")},
      );

      debugPrint('🔧 Ejecutando UpdateUserMutation con input: ${input.toJson()}');

      // Ejecutar mutation con variables
      final response = await _conn.operation(
        operation: mutation,
        variables: {"input": input.toJson()},
      );

      debugPrint('✅ Response recibido: $response');
      debugPrint('🔍 Tipo de response: ${response.runtimeType}');

      // Si el response ya es un User, retornarlo directamente
      if (response is User) {
        debugPrint('✅ Response es directamente un User');
        return response;
      }

      // Si es un Map, transformar con mutation.result()
      if (response != null && response is Map<String, dynamic>) {
        debugPrint('🔄 Transformando Map a User');
        return mutation.result(response);
      }

      debugPrint('⚠️ Response es null o tipo inesperado');
      return null;
    } catch (e, stackTrace) {
      debugPrint('💥 Error en UpdateUserUsecase.execute: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
