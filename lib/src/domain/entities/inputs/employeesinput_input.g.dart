// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employeesinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeesInput _$EmployeesInputFromJson(Map<String, dynamic> json) =>
    EmployeesInput(
      id: json['_id'] as String?,
      employees:
          (json['employees'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      remove: json['remove'] as bool?,
    );

Map<String, dynamic> _$EmployeesInputToJson(EmployeesInput instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'employees': instance.employees,
      'remove': instance.remove,
    };
