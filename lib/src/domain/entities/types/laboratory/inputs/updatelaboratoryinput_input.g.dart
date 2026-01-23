// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updatelaboratoryinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateLaboratoryInput _$UpdateLaboratoryInputFromJson(
  Map<String, dynamic> json,
) => UpdateLaboratoryInput(
  id: json['_id'] as String?,
  address: json['address'] as String?,
  contactPhoneNumbers:
      (json['contactPhoneNumbers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$UpdateLaboratoryInputToJson(
  UpdateLaboratoryInput instance,
) => <String, dynamic>{
  if (instance.id case final value?) '_id': value,
  if (instance.address case final value?) 'address': value,
  if (instance.contactPhoneNumbers case final value?)
    'contactPhoneNumbers': value,
};
