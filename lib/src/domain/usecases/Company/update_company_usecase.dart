import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:agile_front/agile_front.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/mutations/updateCompany/updatecompany_mutation.dart';
import '/src/domain/extensions/company_fields_builder_extension.dart';
import '/src/domain/operation/fields_builders/main.dart';

class UpdateCompanyUsecase {
  final GqlConn _conn;

  UpdateCompanyUsecase({
    required UpdateCompanyMutation operation,
    required GqlConn conn,
  }) : _conn = conn;

  Future<dynamic> execute({required UpdateCompanyInput input}) async {
    try {
      // Crear nueva mutation con declarativeArgs
      final mutation = UpdateCompanyMutation(
        builder: CompanyFieldsBuilder().defaultValues(),
        declarativeArgs: {"input": "UpdateCompanyInput!"},
        opArgs: {"input": GqlVar("input")},
      );

      debugPrint(
        '🔧 Ejecutando UpdateCompanyMutation con input: ${input.toJson()}',
      );

      // Ejecutar mutation con variables
      final response = await _conn.operation(
        operation: mutation,
        variables: {"input": input.toJson()},
      );

      debugPrint('✅ Response recibido: $response');
      debugPrint('🔍 Tipo de response: ${response.runtimeType}');

      // Si el response ya es un Company, retornarlo directamente
      if (response is Company) {
        debugPrint('✅ Response es directamente un Company');
        return response;
      }

      // Si es un Map, transformar con mutation.result()
      if (response != null && response is Map<String, dynamic>) {
        debugPrint('🔄 Transformando Map a Company');
        return mutation.result(response);
      }

      debugPrint('⚠️ Response es null o tipo inesperado');
      return null;
    } catch (e, stackTrace) {
      debugPrint('💥 Error en UpdateCompanyUsecase.execute: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
