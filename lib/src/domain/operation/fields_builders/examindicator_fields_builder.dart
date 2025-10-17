// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class ExamIndicatorFieldsBuilder {
  final List<String> _fields = [];
  ExamIndicatorFieldsBuilder name({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("name", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamIndicatorFieldsBuilder valueType({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("valueType", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamIndicatorFieldsBuilder unit({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("unit", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ExamIndicatorFieldsBuilder normalRange({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("normalRange", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
