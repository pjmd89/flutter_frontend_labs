// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approveevaluationinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApproveEvaluationInput _$ApproveEvaluationInputFromJson(
  Map<String, dynamic> json,
) => ApproveEvaluationInput(
  id: json['_id'] as String?,
  isApproved: json['isApproved'] as bool?,
  signatureFilepath: json['signatureFilepath'] as String?,
);

Map<String, dynamic> _$ApproveEvaluationInputToJson(
  ApproveEvaluationInput instance,
) => <String, dynamic>{
  '_id': instance.id,
  if (instance.isApproved case final value?) 'isApproved': value,
  if (instance.signatureFilepath case final value?) 'signatureFilepath': value,
};
