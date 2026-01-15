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
    );

Map<String, dynamic> _$CreateInvoiceInputToJson(CreateInvoiceInput instance) =>
    <String, dynamic>{
      'patient': instance.patient,
      'examIDs': instance.examIDs,
      if (instance.referred case final value?) 'referred': value,
    };
