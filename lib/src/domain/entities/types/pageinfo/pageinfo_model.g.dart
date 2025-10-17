// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pageinfo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) => PageInfo(
  page: json['page'] as num? ?? 0,
  pages: json['pages'] as num? ?? 0,
  shown: json['shown'] as num? ?? 0,
  total: json['total'] as num? ?? 0,
  overall: json['overall'] as num? ?? 0,
  split: json['split'] as num? ?? 0,
);

Map<String, dynamic> _$PageInfoToJson(PageInfo instance) => <String, dynamic>{
  'page': instance.page,
  'pages': instance.pages,
  'shown': instance.shown,
  'total': instance.total,
  'overall': instance.overall,
  'split': instance.split,
};
