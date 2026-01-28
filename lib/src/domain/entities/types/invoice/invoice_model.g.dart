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
  billTo:
      json['billTo'] == null
          ? null
          : ResponsibleParty.fromJson(json['billTo'] as Map<String, dynamic>),
  totalAmount: json['totalAmount'] as num? ?? 0,
  orderID: json['orderID'] as String? ?? "",
  paymentStatus: $enumDecodeNullable(
    _$PaymentStatusEnumMap,
    json['paymentStatus'],
  ),
  kind: $enumDecodeNullable(_$InvoiceKindEnumMap, json['kind']),
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
  created: (json['created'] as num?)?.toInt() ?? 0,
  updated: (json['updated'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
  '_id': instance.id,
  if (instance.patient case final value?) 'patient': value,
  if (instance.billTo case final value?) 'billTo': value,
  'totalAmount': instance.totalAmount,
  'orderID': instance.orderID,
  if (_$PaymentStatusEnumMap[instance.paymentStatus] case final value?)
    'paymentStatus': value,
  if (_$InvoiceKindEnumMap[instance.kind] case final value?) 'kind': value,
  if (instance.laboratory case final value?) 'laboratory': value,
  if (instance.evaluationPackage case final value?) 'evaluationPackage': value,
  'created': instance.created,
  'updated': instance.updated,
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pAID: 'PAID',
  PaymentStatus.pENDING: 'PENDING',
  PaymentStatus.cANCELED: 'CANCELED',
};

const _$InvoiceKindEnumMap = {
  InvoiceKind.iNVOICE: 'INVOICE',
  InvoiceKind.cREDIT_NOTE: 'CREDIT_NOTE',
};
