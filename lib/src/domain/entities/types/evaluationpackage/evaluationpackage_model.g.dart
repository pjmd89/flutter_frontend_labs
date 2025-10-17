// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluationpackage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvaluationPackage _$EvaluationPackageFromJson(Map<String, dynamic> json) =>
    EvaluationPackage(
      id: json['_id'] as String? ?? "",
      valuesByExam:
          (json['valuesByExam'] as List<dynamic>?)
              ?.map((e) => ExamResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$ResultStatusEnumMap, json['status']),
      pdfFilepath: json['pdfFilepath'] as String? ?? "",
      completedAt: json['completedAt'] as String? ?? "",
      referred: json['referred'] as String? ?? "",
      observations:
          (json['observations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      created: json['created'] as String? ?? "",
      updated: json['updated'] as String? ?? "",
    );

Map<String, dynamic> _$EvaluationPackageToJson(
  EvaluationPackage instance,
) => <String, dynamic>{
  '_id': instance.id,
  'valuesByExam': instance.valuesByExam,
  if (_$ResultStatusEnumMap[instance.status] case final value?) 'status': value,
  'pdfFilepath': instance.pdfFilepath,
  'completedAt': instance.completedAt,
  'referred': instance.referred,
  'observations': instance.observations,
  'created': instance.created,
  'updated': instance.updated,
};

const _$ResultStatusEnumMap = {
  ResultStatus.pending: 'pending',
  ResultStatus.inProgress: 'inProgress',
  ResultStatus.completed: 'completed',
};
