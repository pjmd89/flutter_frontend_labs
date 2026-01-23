// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edgelabmembershipinfo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeLabMembershipInfo _$EdgeLabMembershipInfoFromJson(
  Map<String, dynamic> json,
) => EdgeLabMembershipInfo(
  edges:
      (json['edges'] as List<dynamic>?)
          ?.map((e) => LabMembershipInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pageInfo:
      json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EdgeLabMembershipInfoToJson(
  EdgeLabMembershipInfo instance,
) => <String, dynamic>{
  'edges': instance.edges,
  if (instance.pageInfo case final value?) 'pageInfo': value,
};
