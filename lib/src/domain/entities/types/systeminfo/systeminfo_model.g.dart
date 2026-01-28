// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'systeminfo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemInfo _$SystemInfoFromJson(Map<String, dynamic> json) => SystemInfo(
  version: json['version'] as String? ?? "",
  name: json['name'] as String? ?? "",
  description: json['description'] as String? ?? "",
  changeLog:
      (json['changeLog'] as List<dynamic>?)
          ?.map((e) => ChangeLog.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  created: (json['created'] as num?)?.toInt() ?? 0,
  updated: (json['updated'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SystemInfoToJson(SystemInfo instance) =>
    <String, dynamic>{
      'version': instance.version,
      'name': instance.name,
      'description': instance.description,
      'changeLog': instance.changeLog,
      'created': instance.created,
      'updated': instance.updated,
    };
