// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class SystemInfoFieldsBuilder {
  final List<String> _fields = [];
  SystemInfoFieldsBuilder version({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("version", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  SystemInfoFieldsBuilder name({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("name", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  SystemInfoFieldsBuilder description({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("description", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  SystemInfoFieldsBuilder changeLog({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ChangeLogFieldsBuilder)? builder}) {
    final child = ChangeLogFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("changeLog", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  SystemInfoFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  SystemInfoFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
