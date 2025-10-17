// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edgepatient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgePatient _$EdgePatientFromJson(Map<String, dynamic> json) => EdgePatient(
  edges:
      (json['edges'] as List<dynamic>?)
          ?.map((e) => Patient.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pageInfo:
      json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EdgePatientToJson(EdgePatient instance) =>
    <String, dynamic>{
      'edges': instance.edges,
      if (instance.pageInfo case final value?) 'pageInfo': value,
    };
