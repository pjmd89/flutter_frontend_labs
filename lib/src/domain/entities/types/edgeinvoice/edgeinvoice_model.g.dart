// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edgeinvoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeInvoice _$EdgeInvoiceFromJson(Map<String, dynamic> json) => EdgeInvoice(
  edges:
      (json['edges'] as List<dynamic>?)
          ?.map((e) => Invoice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pageInfo:
      json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EdgeInvoiceToJson(EdgeInvoice instance) =>
    <String, dynamic>{
      'edges': instance.edges,
      if (instance.pageInfo case final value?) 'pageInfo': value,
    };
