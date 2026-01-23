// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Upload _$UploadFromJson(Map<String, dynamic> json) => Upload(
  name: json['name'] as String? ?? "",
  size: json['size'] as num? ?? 0,
  type: json['type'] as String? ?? "",
  folder: json['folder'] as String? ?? "",
  sizeUploaded: json['sizeUploaded'] as num? ?? 0,
  display: json['display'] as String? ?? "",
);

Map<String, dynamic> _$UploadToJson(Upload instance) => <String, dynamic>{
  'name': instance.name,
  'size': instance.size,
  'type': instance.type,
  'folder': instance.folder,
  'sizeUploaded': instance.sizeUploaded,
  'display': instance.display,
};
