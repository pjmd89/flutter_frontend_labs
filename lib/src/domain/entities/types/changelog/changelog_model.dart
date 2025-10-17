import "package:json_annotation/json_annotation.dart";
part "changelog_model.g.dart";
@JsonSerializable(includeIfNull: false)
class ChangeLog {
  final String version;
  final String date;
  final String description;
  ChangeLog({
    this.version = "",
    this.date = "",
    this.description = "",
  });
  factory ChangeLog.fromJson(Map<String, dynamic> json) => _$ChangeLogFromJson(json);
  Map<String, dynamic> toJson() => _$ChangeLogToJson(this);
}
