import 'package:flutter/foundation.dart';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/domain/operation/queries/checkFileSize/checkfilesize_query.dart';

/// UseCase para verificar el tamaño de un archivo antes de subirlo
/// Permite saber cuánto del archivo ya fue subido al servidor
/// Útil para reanudar uploads interrumpidos
class CheckFileSizeUsecase implements af.UseCase {
  final af.Service _conn;

  CheckFileSizeUsecase({
    required af.Service conn,
  }) : _conn = conn;

  @override
  Future<dynamic> build() async {
    throw UnimplementedError('Use checkFileSize() con parámetros específicos');
  }

  /// Verifica el estado de un archivo en el servidor
  /// 
  /// Retorna información sobre:
  /// - Cuánto del archivo ya fue subido (sizeUploaded)
  /// - Ruta de display del archivo
  /// - Metadata del archivo (nombre, tamaño, tipo, carpeta)
  Future<Map<String, dynamic>> checkFileSize({
    required String name,
    required num size,
    required String type,
  }) async {
    try {
      debugPrint('🔍 Verificando archivo: $name');
      
      // Crear input
      final input = CheckUploadInput(
        name: name,
        size: size,
        type: type,
      );

      // Crear query
      final query = CheckFileSizeQuery(
        declarativeArgs: {"input": "checkUploadInput"},
        opArgs: {"input": GqlVar("input")},
      );

      debugPrint('🔧 Query GraphQL:');
      debugPrint(query.build());

      // Ejecutar query
      final response = await _conn.operation(
        operation: query,
        variables: {'input': input.toJson()},
      );

      debugPrint('📥 Respuesta del servidor: $response');

      if (response is! Map<String, dynamic>) {
        throw Exception('Respuesta inesperada del servidor');
      }

      // Retornar los datos directamente desde la query
      return query.result(response);
    } catch (e, stackTrace) {
      debugPrint('💥 Error al verificar archivo: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
