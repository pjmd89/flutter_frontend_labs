import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "systeminfo_model.g.dart";
@JsonSerializable(includeIfNull: false)
class SystemInfo {
   String version;
   String name;
   String description;
   List<ChangeLog> changeLog;
   String created;
   String updated;
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
