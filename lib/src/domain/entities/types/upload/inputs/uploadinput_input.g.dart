// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploadinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

uploadInput _$uploadInputFromJson(Map<String, dynamic> json) => uploadInput(
  name: json['name'] as String?,
  size: json['size'] as num?,
  type: json['type'] as String?,
  folder: json['folder'] as String?,
  file: json['file'] as String?,
  isThumb: json['isThumb'] as bool?,
);

Map<String, dynamic> _$uploadInputToJson(uploadInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'type': instance.type,
      'folder': instance.folder,
      'file': instance.file,
      if (instance.isThumb case final value?) 'isThumb': value,
    };
