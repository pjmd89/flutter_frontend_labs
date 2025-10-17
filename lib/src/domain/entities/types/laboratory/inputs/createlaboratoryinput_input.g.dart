// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createlaboratoryinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLaboratoryInput _$CreateLaboratoryInputFromJson(
  Map<String, dynamic> json,
) => CreateLaboratoryInput(
  companyID: json['companyID'] as String?,
  address: json['address'] as String?,
  contactPhoneNumbers:
      (json['contactPhoneNumbers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$CreateLaboratoryInputToJson(
  CreateLaboratoryInput instance,
) => <String, dynamic>{
  if (instance.companyID case final value?) 'companyID': value,
  'address': instance.address,
  if (instance.contactPhoneNumbers case final value?)
    'contactPhoneNumbers': value,
};
