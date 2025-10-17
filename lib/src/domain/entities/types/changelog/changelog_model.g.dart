// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changelog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeLog _$ChangeLogFromJson(Map<String, dynamic> json) => ChangeLog(
  version: json['version'] as String? ?? "",
  date: json['date'] as String? ?? "",
  description: json['description'] as String? ?? "",
);

Map<String, dynamic> _$ChangeLogToJson(ChangeLog instance) => <String, dynamic>{
  'version': instance.version,
  'date': instance.date,
  'description': instance.description,
};
