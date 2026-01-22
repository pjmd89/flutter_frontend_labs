// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkfilesize_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckFileSize _$CheckFileSizeFromJson(Map<String, dynamic> json) =>
    CheckFileSize(
      name: json['name'] as String,
      size: (json['size'] as num).toDouble(),
      type: json['type'] as String,
      folder: json['folder'] as String,
      sizeUploaded: (json['sizeUploaded'] as num).toDouble(),
      display: json['display'] as String,
    );

Map<String, dynamic> _$CheckFileSizeToJson(CheckFileSize instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'type': instance.type,
      'folder': instance.folder,
      'sizeUploaded': instance.sizeUploaded,
      'display': instance.display,
    };
