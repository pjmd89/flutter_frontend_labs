import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'upload_model.g.dart';

/// Modelo para representar un archivo subido al servidor
/// Compatible con el sistema de upload por fragmentos
@JsonSerializable()
class UploadModel {
  final String name;
  final int size;
  final String type;
  final String folder;
  final int sizeUploaded;
  
  String get filePath => "$folder/$name";
  
  UploadModel({
    required this.name,
    required this.size,
    required this.type,
    required this.folder,
    required this.sizeUploaded,
  });

  factory UploadModel.fromJson(Map<String, dynamic> json) =>
      _$UploadModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadModelToJson(this);
}
