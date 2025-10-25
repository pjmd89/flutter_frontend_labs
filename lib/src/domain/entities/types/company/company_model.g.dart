// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
  id: json['_id'] as String? ?? "",
  name: json['name'] as String? ?? "",
  logo: json['logo'] as String? ?? "",
  taxID: json['taxID'] as String? ?? "",
  owner:
      json['owner'] == null
          ? null
          : User.fromJson(json['owner'] as Map<String, dynamic>),
  created: json['created'] as num? ?? 0,
  updated: json['updated'] as num? ?? 0,
);

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'logo': instance.logo,
  'taxID': instance.taxID,
  if (instance.owner case final value?) 'owner': value,
  'created': instance.created,
  'updated': instance.updated,
};
