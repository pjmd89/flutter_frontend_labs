import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "systeminfo_model.g.dart";
@JsonSerializable(includeIfNull: false)
class SystemInfo {
  final String version;
  final String name;
  final String description;
  final List<ChangeLog> changeLog;
  final String created;
  final String updated;
  SystemInfo({
    this.version = "",
    this.name = "",
    this.description = "",
    this.changeLog = const [],
    this.created = "",
    this.updated = "",
  });
  factory SystemInfo.fromJson(Map<String, dynamic> json) => _$SystemInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SystemInfoToJson(this);
}
