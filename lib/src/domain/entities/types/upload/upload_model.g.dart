// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadModel _$UploadModelFromJson(Map<String, dynamic> json) => UploadModel(
  name: json['name'] as String,
  size: (json['size'] as num).toInt(),
  type: json['type'] as String,
  folder: json['folder'] as String,
  sizeUploaded: (json['sizeUploaded'] as num).toInt(),
);

Map<String, dynamic> _$UploadModelToJson(UploadModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'type': instance.type,
      'folder': instance.folder,
      'sizeUploaded': instance.sizeUploaded,
    };
