import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "edgepatient_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EdgePatient {
  final List<Patient> edges;
  final PageInfo? pageInfo;
  EdgePatient({
    this.edges = const [],
    this.pageInfo,
  });
  factory EdgePatient.fromJson(Map<String, dynamic> json) => _$EdgePatientFromJson(json);
  Map<String, dynamic> toJson() => _$EdgePatientToJson(this);
}
