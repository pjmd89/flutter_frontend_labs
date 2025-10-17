// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class ExamResultFieldsBuilder {
  final List<String> _fields = [];
  ExamResultFieldsBuilder exam({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamFieldsBuilder)? builder}) {
    final child = ExamFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("exam", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  ExamResultFieldsBuilder cost({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("cost", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamResultFieldsBuilder indicatorValues({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(IndicatorValueFieldsBuilder)? builder}) {
    final child = IndicatorValueFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("indicatorValues", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
