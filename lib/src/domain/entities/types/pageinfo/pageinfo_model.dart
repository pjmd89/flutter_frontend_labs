import "package:json_annotation/json_annotation.dart";
part "pageinfo_model.g.dart";
@JsonSerializable(includeIfNull: false)
class PageInfo {
   num page;
   num pages;
   num shown;
   num total;
   num overall;
   num split;
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
