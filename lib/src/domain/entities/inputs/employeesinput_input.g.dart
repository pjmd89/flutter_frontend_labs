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
      if (instance.id case final value?) '_id': value,
      'employees': instance.employees,
      'remove': instance.remove,
    };
