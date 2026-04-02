// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employeesinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaboratoryEmployeesInput _$LaboratoryEmployeesInputFromJson(
  Map<String, dynamic> json,
) => LaboratoryEmployeesInput(
  id: json['_id'] as String?,
  employees:
      (json['employees'] as List<dynamic>?)
          ?.map((e) => EmployeeInput.fromJson(e as Map<String, dynamic>))
          .toList(),
  remove: json['remove'] as bool?,
);

Map<String, dynamic> _$LaboratoryEmployeesInputToJson(
  LaboratoryEmployeesInput instance,
) => <String, dynamic>{
  if (instance.id case final value?) '_id': value,
  'employees': instance.employees,
  'remove': instance.remove,
};
