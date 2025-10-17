import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "searchinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class SearchInput extends ChangeNotifier {
  String? _field;
  String? get field => _field;
  set field(String? value) {
    _field = value;
    notifyListeners();
  }
  List<ValueInput?>? _value;
  List<ValueInput?>? get value => _value;
  set value(List<ValueInput?>? value) {
    _value = value;
    notifyListeners();
  }
  List<SearchInput?>? _and;
  List<SearchInput?>? get and => _and;
  set and(List<SearchInput?>? value) {
    _and = value;
    notifyListeners();
  }
  List<SearchInput?>? _not;
  List<SearchInput?>? get not => _not;
  set not(List<SearchInput?>? value) {
    _not = value;
    notifyListeners();
  }
  List<SearchInput?>? _nor;
  List<SearchInput?>? get nor => _nor;
  set nor(List<SearchInput?>? value) {
    _nor = value;
    notifyListeners();
  }
  List<SearchInput?>? _or;
  List<SearchInput?>? get or => _or;
  set or(List<SearchInput?>? value) {
    _or = value;
    notifyListeners();
  }
  List<ElemMatchInput?>? _elemMatch;
  List<ElemMatchInput?>? get elemMatch => _elemMatch;
  set elemMatch(List<ElemMatchInput?>? value) {
    _elemMatch = value;
    notifyListeners();
  }
  GeoSpatialInput? _geoSpatial;
  GeoSpatialInput? get geoSpatial => _geoSpatial;
  set geoSpatial(GeoSpatialInput? value) {
    _geoSpatial = value;
    notifyListeners();
  }
  SearchInput({
    String? field,
    List<ValueInput>? value,
    List<SearchInput>? and,
    List<SearchInput>? not,
    List<SearchInput>? nor,
    List<SearchInput>? or,
    List<ElemMatchInput>? elemMatch,
    GeoSpatialInput? geoSpatial,
  }) {
    this.field = field ?? "";
    this.value = value;
    this.and = and;
    this.not = not;
    this.nor = nor;
    this.or = or;
    this.elemMatch = elemMatch;
    this.geoSpatial = geoSpatial;
  }
  factory SearchInput.fromJson(Map<String, dynamic> json) => _$SearchInputFromJson(json);
  Map<String, dynamic> toJson() => _$SearchInputToJson(this);
}
