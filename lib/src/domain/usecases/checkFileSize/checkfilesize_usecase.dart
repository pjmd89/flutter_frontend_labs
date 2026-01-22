import 'package:flutter/foundation.dart';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/types/checkfilesize/checkfilesize_model.dart';
import '/src/domain/entities/types/checkfilesize/inputs/checkupload_input.dart';
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
  Future<CheckFileSize> checkFileSize({
    required String name,
    required double size,
    required String type,
    required String folder,
  }) async {
    try {
      debugPrint('🔍 Verificando archivo: $name en $folder');
      
      // Crear input
      final input = CheckUploadInput(
        name: name,
        size: size,
        type: type,
        folder: folder,
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

      final checkData = response['checkFileSize'] as Map<String, dynamic>;
      return CheckFileSize.fromJson(checkData);
    } catch (e, stackTrace) {
      debugPrint('💥 Error al verificar archivo: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}
