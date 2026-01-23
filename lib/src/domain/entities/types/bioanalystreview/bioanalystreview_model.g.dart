// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bioanalystreview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BioanalystReview _$BioanalystReviewFromJson(Map<String, dynamic> json) =>
    BioanalystReview(
      bioanalyst:
          json['bioanalyst'] == null
              ? null
              : User.fromJson(json['bioanalyst'] as Map<String, dynamic>),
      reviewedAt: json['reviewedAt'] as String? ?? "",
    );

Map<String, dynamic> _$BioanalystReviewToJson(BioanalystReview instance) =>
    <String, dynamic>{
      if (instance.bioanalyst case final value?) 'bioanalyst': value,
      'reviewedAt': instance.reviewedAt,
    };
