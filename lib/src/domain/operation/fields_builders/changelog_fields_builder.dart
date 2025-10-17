// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class ChangeLogFieldsBuilder {
  final List<String> _fields = [];
  ChangeLogFieldsBuilder version({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("version", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ChangeLogFieldsBuilder date({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("date", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ChangeLogFieldsBuilder description({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("description", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
