// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updateanimalpatientinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAnimalPatientInput _$UpdateAnimalPatientInputFromJson(
  Map<String, dynamic> json,
) => UpdateAnimalPatientInput(
  firstName: json['firstName'] as String?,
  species: json['species'] as String?,
  lastName: json['lastName'] as String?,
  birthDate: json['birthDate'] as String?,
  sex: $enumDecodeNullable(_$SexEnumMap, json['sex']),
);

Map<String, dynamic> _$UpdateAnimalPatientInputToJson(
  UpdateAnimalPatientInput instance,
) => <String, dynamic>{
  if (instance.firstName case final value?) 'firstName': value,
  if (instance.species case final value?) 'species': value,
  if (instance.lastName case final value?) 'lastName': value,
  if (instance.birthDate case final value?) 'birthDate': value,
  if (_$SexEnumMap[instance.sex] case final value?) 'sex': value,
};

const _$SexEnumMap = {
  Sex.fEMALE: 'FEMALE',
  Sex.mALE: 'MALE',
  Sex.iNTERSEX: 'INTERSEX',
};
