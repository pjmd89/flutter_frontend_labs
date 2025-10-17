// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addchangeloginput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddChangeLogInput _$AddChangeLogInputFromJson(Map<String, dynamic> json) =>
    AddChangeLogInput(
      version: json['version'] as String?,
      date: json['date'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$AddChangeLogInputToJson(AddChangeLogInput instance) =>
    <String, dynamic>{
      'version': instance.version,
      'date': instance.date,
      'description': instance.description,
    };
