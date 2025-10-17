// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updatecompanyinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCompanyInput _$UpdateCompanyInputFromJson(Map<String, dynamic> json) =>
    UpdateCompanyInput(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      logo: json['logo'] as String?,
      taxID: json['taxID'] as String?,
    );

Map<String, dynamic> _$UpdateCompanyInputToJson(UpdateCompanyInput instance) =>
    <String, dynamic>{
      '_id': instance.id,
      if (instance.name case final value?) 'name': value,
      if (instance.logo case final value?) 'logo': value,
      if (instance.taxID case final value?) 'taxID': value,
    };
