// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class ExamTemplateFieldsBuilder {
  final List<String> _fields = [];
  ExamTemplateFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamTemplateFieldsBuilder name({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("name", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamTemplateFieldsBuilder description({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("description", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamTemplateFieldsBuilder indicators({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamIndicatorFieldsBuilder)? builder}) {
    final child = ExamIndicatorFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("indicators", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  ExamTemplateFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamTemplateFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
