import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:agile_front/agile_front.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:uuid/uuid.dart';
import '/src/domain/entities/types/upload/inputs/uploadfile_input.dart';
import '/src/domain/operation/mutations/upload/upload_mutation.dart';

/// Resultado de la operación de subida de archivo
class UploadFileUseCaseResult {
  final bool success;
  final String code;
  final Map<String, dynamic>? uploadedFile;
  
  UploadFileUseCaseResult({
    required this.success,
    required this.code,
    this.uploadedFile,
  });
}

/// UseCase para subir archivos al servidor
/// Soporta validación de extensiones y carga en fragmentos
class UploadFileUseCase {
  static const String codeOk = 'uploadFileOk';
  static const String codeNoExtension = 'uploadFileNoExtension';
  static const String codeInvalidExtension = 'uploadFileInvalidExtension';
  static const String codeUploadError = 'uploadFileUploadError';
  
  // Tamaño del fragmento para carga (6MB)
  static const int byteInterval = 1024 * 1024 * 6;

  final GqlConn _conn;

  UploadFileUseCase({required GqlConn conn}) : _conn = conn;

  /// Sube un archivo al servidor
  /// 
  /// [fileOriginalName] - Nombre original del archivo con extensión
  /// [fileDestinyName] - Nombre destino sin extensión
  /// [fileBytes] - Bytes del archivo
  /// [destinyDirectory] - Carpeta destino en el servidor
  /// [userId] - ID del usuario que sube el archivo
  /// [onlyXlsx] - Si es true, solo acepta archivos .xlsx
  Future<UploadFileUseCaseResult> uploadFile({
    required String fileOriginalName,
    required String fileDestinyName,
    required Uint8List fileBytes,
    required String destinyDirectory,
    required String userId,
    bool onlyXlsx = false,
  }) async {
    // Validar extensión
    List<String> extensionContainerList = fileOriginalName.split('.');
    if (extensionContainerList.isEmpty) {
      return UploadFileUseCaseResult(success: false, code: codeNoExtension);
    }
    
    String fileExtension = extensionContainerList.last;
    
    // Si solo acepta xlsx, validar
    if (onlyXlsx) {
      if (fileExtension.toLowerCase() != 'xlsx') {
        return UploadFileUseCaseResult(
          success: false,
          code: codeInvalidExtension,
        );
      }
    }
    
    // Validar extensiones permitidas
    bool isValidExtension = RegExp(
      r'(pdf|jpeg|jpg|png|xlsx)$',
      caseSensitive: false,
    ).hasMatch(fileExtension);
    
    if (!isValidExtension) {
      return UploadFileUseCaseResult(
        success: false,
        code: codeInvalidExtension,
      );
    }
    
    // Mapear extensión a MIME type
    final Map<String, String> extensionToMimeType = {
      'pdf': 'application/pdf',
      'jpeg': 'image/jpeg',
      'jpg': 'image/jpeg',
      'png': 'image/png',
      'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    };
    
    String? type = extensionToMimeType[fileExtension.toLowerCase()];
    if (type == null) {
      return UploadFileUseCaseResult(
        success: false,
        code: codeInvalidExtension,
      );
    }
    
    // Generar nombre único para el archivo
    String fileID = const Uuid().v4();
    // Limpiar extensión duplicada si existe
    String cleanDestinyName = fileDestinyName;
    if (cleanDestinyName.endsWith('.$fileExtension')) {
      cleanDestinyName = cleanDestinyName.substring(0, cleanDestinyName.length - fileExtension.length - 1);
    }
    String finalFileName = "${userId}_${fileID}_$cleanDestinyName.$fileExtension";
    
    try {
      // Subir archivo en fragmentos
      final uploadedData = await _uploadInFragments(
        name: finalFileName,
        type: type,
        folder: destinyDirectory,
        fileBytes: fileBytes,
      );
      
      return UploadFileUseCaseResult(
        success: true,
        code: codeOk,
        uploadedFile: uploadedData,
      );
    } catch (e, stackTrace) {
      debugPrint('💥 Error al subir archivo: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      
      return UploadFileUseCaseResult(
        success: false,
        code: codeUploadError,
      );
    }
  }
  
  /// Sube el archivo en fragmentos recursivamente
  Future<Map<String, dynamic>> _uploadInFragments({
    required String name,
    required String type,
    required String folder,
    required Uint8List fileBytes,
    int sizeUploaded = 0,
  }) async {
    final int totalSize = fileBytes.length;
    
    // Calcular límites del fragmento actual
    int end = sizeUploaded + byteInterval;
    int endFile = end > totalSize ? totalSize : end;
    
    // Extraer fragmento y codificar en base64
    final fragment = fileBytes.sublist(sizeUploaded, endFile);
    final base64Fragment = base64Encode(fragment);
    // Backend espera solo el base64 puro, sin prefijo
    final fileData = base64Fragment;
    
    // Crear input para este fragmento
    final input = UploadFileInput(
      name: name,
      size: totalSize,
      type: type,
      folder: folder,
      file: fileData,
    );
    
    // Crear mutation
    final mutation = UploadMutation(
      declarativeArgs: {"input": "uploadInput!"},
      opArgs: {"input": GqlVar("input")},
    );
    
    // Ejecutar mutation
    final response = await _conn.operation(
      operation: mutation,
      variables: {'input': input.toJson()},
    );
    
    if (response is! Map<String, dynamic>) {
      throw Exception('Respuesta inesperada del servidor');
    }
    
    final uploadData = response['upload'] as Map<String, dynamic>;
    final newSizeUploaded = uploadData['sizeUploaded'] as int;
    
    // Si aún falta contenido, continuar recursivamente
    if (newSizeUploaded < totalSize) {
      return await _uploadInFragments(
        name: name,
        type: type,
        folder: folder,
        fileBytes: fileBytes,
        sizeUploaded: endFile,
      );
    }
    
    // Archivo completo subido
    return uploadData;
  }
}
