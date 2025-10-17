// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class ExamFieldsBuilder {
  final List<String> _fields = [];
  ExamFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamFieldsBuilder template({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamTemplateFieldsBuilder)? builder}) {
    final child = ExamTemplateFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("template", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  ExamFieldsBuilder laboratory({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("laboratory", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  ExamFieldsBuilder baseCost({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("baseCost", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
