// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkuploadinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

checkUploadInput _$checkUploadInputFromJson(Map<String, dynamic> json) =>
    checkUploadInput(
      name: json['name'] as String?,
      size: json['size'] as num?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$checkUploadInputToJson(checkUploadInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'type': instance.type,
    };
