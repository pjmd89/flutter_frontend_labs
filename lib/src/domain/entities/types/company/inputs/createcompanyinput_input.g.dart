// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createcompanyinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCompanyInput _$CreateCompanyInputFromJson(Map<String, dynamic> json) =>
    CreateCompanyInput(
      name: json['name'] as String?,
      logo: json['logo'] as String?,
      taxID: json['taxID'] as String?,
      laboratoryInfo:
          json['laboratoryInfo'] == null
              ? null
              : CreateLaboratoryInput.fromJson(
                json['laboratoryInfo'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$CreateCompanyInputToJson(CreateCompanyInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (instance.logo case final value?) 'logo': value,
      'taxID': instance.taxID,
      'laboratoryInfo': instance.laboratoryInfo,
    };
