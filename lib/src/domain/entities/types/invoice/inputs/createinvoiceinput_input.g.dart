// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createinvoiceinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInvoiceInput _$CreateInvoiceInputFromJson(Map<String, dynamic> json) =>
    CreateInvoiceInput(
      patient: json['patient'] as String?,
      examIDs:
          (json['examIDs'] as List<dynamic>?)?.map((e) => e as String).toList(),
      referred: json['referred'] as String?,
      kind: $enumDecodeNullable(_$InvoiceKindEnumMap, json['kind']),
      billTo: json['billTo'] as String?,
    );

Map<String, dynamic> _$CreateInvoiceInputToJson(CreateInvoiceInput instance) =>
    <String, dynamic>{
      'patient': instance.patient,
      'examIDs': instance.examIDs,
      if (instance.referred case final value?) 'referred': value,
      'kind': _$InvoiceKindEnumMap[instance.kind]!,
      'billTo': instance.billTo,
    };

const _$InvoiceKindEnumMap = {
  InvoiceKind.iNVOICE: 'INVOICE',
  InvoiceKind.cREDIT_NOTE: 'CREDIT_NOTE',
};
