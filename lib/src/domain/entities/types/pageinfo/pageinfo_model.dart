import "package:json_annotation/json_annotation.dart";
part "pageinfo_model.g.dart";
@JsonSerializable(includeIfNull: false)
class PageInfo {
  final num page;
  final num pages;
  final num shown;
  final num total;
  final num overall;
  final num split;
  PageInfo({
    this.page = 0,
    this.pages = 0,
    this.shown = 0,
    this.total = 0,
    this.overall = 0,
    this.split = 0,
  });
  factory PageInfo.fromJson(Map<String, dynamic> json) => _$PageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PageInfoToJson(this);
}
