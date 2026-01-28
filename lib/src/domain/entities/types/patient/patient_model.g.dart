// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
  id: json['_id'] as String? ?? "",
  patientType: $enumDecodeNullable(_$PatientTypeEnumMap, json['patientType']),
  patientData: const PatientEntityConverter().fromJson(
    json['patientData'] as Map<String, dynamic>?,
  ),
  metadata:
      (json['metadata'] as List<dynamic>?)
          ?.map((e) => KeyValuePair.fromJson(e as Map<String, dynamic>))
          .toList(),
  laboratory:
      json['laboratory'] == null
          ? null
          : Laboratory.fromJson(json['laboratory'] as Map<String, dynamic>),
  created: (json['created'] as num?)?.toInt() ?? 0,
  updated: (json['updated'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  '_id': instance.id,
  if (_$PatientTypeEnumMap[instance.patientType] case final value?)
    'patientType': value,
  if (const PatientEntityConverter().toJson(instance.patientData)
      case final value?)
    'patientData': value,
  if (instance.metadata case final value?) 'metadata': value,
  if (instance.laboratory case final value?) 'laboratory': value,
  'created': instance.created,
  'updated': instance.updated,
};

const _$PatientTypeEnumMap = {
  PatientType.hUMAN: 'HUMAN',
  PatientType.aNIMAL: 'ANIMAL',
};
