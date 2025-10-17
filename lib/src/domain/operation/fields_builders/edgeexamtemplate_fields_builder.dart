// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class EdgeExamTemplateFieldsBuilder {
  final List<String> _fields = [];
  EdgeExamTemplateFieldsBuilder edges({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamTemplateFieldsBuilder)? builder}) {
    final child = ExamTemplateFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("edges", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  EdgeExamTemplateFieldsBuilder pageInfo({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(PageInfoFieldsBuilder)? builder}) {
    final child = PageInfoFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("pageInfo", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
