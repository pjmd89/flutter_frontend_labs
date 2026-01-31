// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updatepersoninput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePersonInput _$UpdatePersonInputFromJson(Map<String, dynamic> json) =>
    UpdatePersonInput(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      dni: json['dni'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      birthDate: json['birthDate'] as String?,
      sex: $enumDecodeNullable(_$SexEnumMap, json['sex']),
    );

Map<String, dynamic> _$UpdatePersonInputToJson(UpdatePersonInput instance) =>
    <String, dynamic>{
      '_id': instance.id,
      if (instance.firstName case final value?) 'firstName': value,
      if (instance.lastName case final value?) 'lastName': value,
      if (instance.dni case final value?) 'dni': value,
      if (instance.phone case final value?) 'phone': value,
      if (instance.email case final value?) 'email': value,
      if (instance.address case final value?) 'address': value,
      if (instance.birthDate case final value?) 'birthDate': value,
      if (_$SexEnumMap[instance.sex] case final value?) 'sex': value,
    };

const _$SexEnumMap = {
  Sex.fEMALE: 'FEMALE',
  Sex.mALE: 'MALE',
  Sex.iNTERSEX: 'INTERSEX',
};
