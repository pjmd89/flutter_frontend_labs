// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
  id: json['_id'] as String? ?? "",
  patient:
      json['patient'] == null
          ? null
          : Patient.fromJson(json['patient'] as Map<String, dynamic>),
  totalAmount: json['totalAmount'] as num? ?? 0,
  orderID: json['orderID'] as String? ?? "",
  paymentStatus:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
      PaymentStatus.paid,
  laboratory:
      json['laboratory'] == null
          ? null
          : Laboratory.fromJson(json['laboratory'] as Map<String, dynamic>),
  evaluationPackage:
      json['evaluationPackage'] == null
          ? null
          : EvaluationPackage.fromJson(
            json['evaluationPackage'] as Map<String, dynamic>,
          ),
  created: json['created'] as num?,
  updated: json['updated'] as num?,
);

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
  '_id': instance.id,
  if (instance.patient case final value?) 'patient': value,
  'totalAmount': instance.totalAmount,
  'orderID': instance.orderID,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  if (instance.laboratory case final value?) 'laboratory': value,
  if (instance.evaluationPackage case final value?) 'evaluationPackage': value,
  if (instance.created case final value?) 'created': value,
  if (instance.updated case final value?) 'updated': value,
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.paid: 'PAID',
  PaymentStatus.canceled: 'CANCELED',
};
