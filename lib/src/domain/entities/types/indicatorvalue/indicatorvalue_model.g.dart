// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indicatorvalue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndicatorValue _$IndicatorValueFromJson(Map<String, dynamic> json) =>
    IndicatorValue(
      indicator:
          json['indicator'] == null
              ? null
              : ExamIndicator.fromJson(
                json['indicator'] as Map<String, dynamic>,
              ),
      value: json['value'] as String? ?? "",
    );

Map<String, dynamic> _$IndicatorValueToJson(IndicatorValue instance) =>
    <String, dynamic>{
      if (instance.indicator case final value?) 'indicator': value,
      'value': instance.value,
    };
