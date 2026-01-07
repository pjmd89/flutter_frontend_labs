// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laboratory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Laboratory _$LaboratoryFromJson(Map<String, dynamic> json) => Laboratory(
  id: json['_id'] as String? ?? "",
  company:
      json['company'] == null
          ? null
          : Company.fromJson(json['company'] as Map<String, dynamic>),
  employees:
      json['employees'] == null
          ? null
          : EdgeUser.fromJson(json['employees'] as Map<String, dynamic>),
  address: json['address'] as String? ?? "",
  contactPhoneNumbers:
      (json['contactPhoneNumbers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  created: json['created'] as num? ?? 0,
  updated: json['updated'] as num? ?? 0,
);

Map<String, dynamic> _$LaboratoryToJson(Laboratory instance) =>
    <String, dynamic>{
      '_id': instance.id,
      if (instance.company case final value?) 'company': value,
      if (instance.employees case final value?) 'employees': value,
      'address': instance.address,
      'contactPhoneNumbers': instance.contactPhoneNumbers,
      'created': instance.created,
      'updated': instance.updated,
    };
