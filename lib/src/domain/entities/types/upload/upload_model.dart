import "package:json_annotation/json_annotation.dart";
part "upload_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Upload {
  final String name;
  final num size;
  final String type;
  final String folder;
  final num sizeUploaded;
  final String display;
  Upload({
    this.name = "",
    this.size = 0,
    this.type = "",
    this.folder = "",
    this.sizeUploaded = 0,
    this.display = "",
  });
  factory Upload.fromJson(Map<String, dynamic> json) => _$UploadFromJson(json);
  Map<String, dynamic> toJson() => _$UploadToJson(this);
}
