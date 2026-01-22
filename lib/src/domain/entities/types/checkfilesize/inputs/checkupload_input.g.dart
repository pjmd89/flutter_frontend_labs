// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkupload_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckUploadInput _$CheckUploadInputFromJson(Map<String, dynamic> json) =>
    CheckUploadInput(
      name: json['name'] as String,
      size: (json['size'] as num).toDouble(),
      type: json['type'] as String,
      folder: json['folder'] as String,
    );

Map<String, dynamic> _$CheckUploadInputToJson(CheckUploadInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'type': instance.type,
      'folder': instance.folder,
    };
