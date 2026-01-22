// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploadfile_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadFileInput _$UploadFileInputFromJson(Map<String, dynamic> json) =>
    UploadFileInput(
      name: json['name'] as String,
      size: (json['size'] as num).toInt(),
      type: json['type'] as String,
      folder: json['folder'] as String,
      file: json['file'] as String,
      sizeUploaded: (json['sizeUploaded'] as num).toInt(),
    );

Map<String, dynamic> _$UploadFileInputToJson(UploadFileInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'type': instance.type,
      'folder': instance.folder,
      'file': instance.file,
      'sizeUploaded': instance.sizeUploaded,
    };
