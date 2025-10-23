// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createuserinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserInput _$CreateUserInputFromJson(Map<String, dynamic> json) =>
    CreateUserInput(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      isAdmin: json['isAdmin'] as bool?,
      laboratoryID: json['laboratoryID'] as String?,
      companyInfo:
          json['companyInfo'] == null
              ? null
              : CreateCompanyInput.fromJson(
                json['companyInfo'] as Map<String, dynamic>,
              ),
      cutOffDate: json['cutOffDate'] as num?,
      fee: json['fee'] as num?,
    );

Map<String, dynamic> _$CreateUserInputToJson(CreateUserInput instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      if (instance.isAdmin case final value?) 'isAdmin': value,
      if (instance.laboratoryID case final value?) 'laboratoryID': value,
      if (instance.companyInfo case final value?) 'companyInfo': value,
      if (instance.cutOffDate case final value?) 'cutOffDate': value,
      if (instance.fee case final value?) 'fee': value,
    };
