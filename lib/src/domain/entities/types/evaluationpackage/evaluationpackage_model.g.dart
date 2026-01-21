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
      completedAt: json['completedAt'] as num? ?? 0,
      referred: json['referred'] as String? ?? "",
      observations:
          (json['observations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      created: json['created'] as num?,
      updated: json['updated'] as num?,
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
  if (instance.created case final value?) 'created': value,
  if (instance.updated case final value?) 'updated': value,
};

const _$ResultStatusEnumMap = {
  ResultStatus.pending: 'PENDING',
  ResultStatus.inProgress: 'INPROGRESS',
  ResultStatus.completed: 'COMPLETED',
};
