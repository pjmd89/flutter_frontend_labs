// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edgeevaluationpackage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeEvaluationPackage _$EdgeEvaluationPackageFromJson(
  Map<String, dynamic> json,
) => EdgeEvaluationPackage(
  edges:
      (json['edges'] as List<dynamic>?)
          ?.map((e) => EvaluationPackage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pageInfo:
      json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EdgeEvaluationPackageToJson(
  EdgeEvaluationPackage instance,
) => <String, dynamic>{
  'edges': instance.edges,
  if (instance.pageInfo case final value?) 'pageInfo': value,
};
