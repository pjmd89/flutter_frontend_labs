import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "bioanalystreview_model.g.dart";
@JsonSerializable(includeIfNull: false)
class BioanalystReview {
  final User? bioanalyst;
  final int reviewedAt;
  final String signatureFilepath;
  BioanalystReview({
    this.bioanalyst,
    this.reviewedAt = 0,
    this.signatureFilepath = '',
  });
  factory BioanalystReview.fromJson(Map<String, dynamic> json) => _$BioanalystReviewFromJson(json);
  Map<String, dynamic> toJson() => _$BioanalystReviewToJson(this);
}
