// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Animal _$AnimalFromJson(Map<String, dynamic> json) => Animal(
  firstName: json['firstName'] as String? ?? "",
  species: json['species'] as String? ?? "",
  lastName: json['lastName'] as String? ?? "",
  birthDate: (json['birthDate'] as num?)?.toInt() ?? 0,
  sex: $enumDecodeNullable(_$SexEnumMap, json['sex']),
);

Map<String, dynamic> _$AnimalToJson(Animal instance) => <String, dynamic>{
  'firstName': instance.firstName,
  'species': instance.species,
  'lastName': instance.lastName,
  'birthDate': instance.birthDate,
  if (_$SexEnumMap[instance.sex] case final value?) 'sex': value,
};

const _$SexEnumMap = {
  Sex.fEMALE: 'FEMALE',
  Sex.mALE: 'MALE',
  Sex.iNTERSEX: 'INTERSEX',
};
