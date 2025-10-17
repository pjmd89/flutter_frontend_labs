// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class IndicatorValueFieldsBuilder {
  final List<String> _fields = [];
  IndicatorValueFieldsBuilder indicator({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamIndicatorFieldsBuilder)? builder}) {
    final child = ExamIndicatorFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("indicator", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  IndicatorValueFieldsBuilder value({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("value", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
