// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updatepatientinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePatientInput _$UpdatePatientInputFromJson(Map<String, dynamic> json) =>
    UpdatePatientInput(
      id: json['_id'] as String?,
      metadata:
          (json['metadata'] as List<dynamic>?)
              ?.map((e) => SetKeyValuePair.fromJson(e as Map<String, dynamic>))
              .toList(),
      animalData:
          json['animalData'] == null
              ? null
              : UpdateAnimalPatientInput.fromJson(
                json['animalData'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$UpdatePatientInputToJson(UpdatePatientInput instance) =>
    <String, dynamic>{
      '_id': instance.id,
      if (instance.metadata case final value?) 'metadata': value,
      if (instance.animalData case final value?) 'animalData': value,
    };
