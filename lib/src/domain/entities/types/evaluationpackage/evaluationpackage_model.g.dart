// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluationpackage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvaluationPackage _$EvaluationPackageFromJson(Map<String, dynamic> json) =>
    EvaluationPackage(
      id: json['_id'] as String? ?? "",
      patient:
          json['patient'] == null
              ? null
              : Patient.fromJson(json['patient'] as Map<String, dynamic>),
      valuesByExam:
          (json['valuesByExam'] as List<dynamic>?)
              ?.map((e) => ExamResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$ResultStatusEnumMap, json['status']),
      pdfFilepath: json['pdfFilepath'] as String? ?? "",
      completedAt: (json['completedAt'] as num?)?.toInt() ?? 0,
      referred: json['referred'] as String? ?? "",
      observations:
          (json['observations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isApproved: json['isApproved'] as bool? ?? false,
      bioanalystReview:
          json['bioanalystReview'] == null
              ? null
              : BioanalystReview.fromJson(
                json['bioanalystReview'] as Map<String, dynamic>,
              ),
      created: (json['created'] as num?)?.toInt() ?? 0,
      updated: (json['updated'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$EvaluationPackageToJson(
  EvaluationPackage instance,
) => <String, dynamic>{
  '_id': instance.id,
  if (instance.patient case final value?) 'patient': value,
  'valuesByExam': instance.valuesByExam,
  if (_$ResultStatusEnumMap[instance.status] case final value?) 'status': value,
  'pdfFilepath': instance.pdfFilepath,
  'completedAt': instance.completedAt,
  'referred': instance.referred,
  'observations': instance.observations,
  'isApproved': instance.isApproved,
  if (instance.bioanalystReview case final value?) 'bioanalystReview': value,
  'created': instance.created,
  'updated': instance.updated,
};

const _$ResultStatusEnumMap = {
  ResultStatus.pENDING: 'PENDING',
  ResultStatus.iNPROGRESS: 'INPROGRESS',
  ResultStatus.cOMPLETED: 'COMPLETED',
};
