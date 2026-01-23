// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class LoggedUserFieldsBuilder {
  final List<String> _fields = [];
  LoggedUserFieldsBuilder user({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(UserFieldsBuilder)? builder}) {
    final child = UserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("user", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  LoggedUserFieldsBuilder currentLaboratory({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("currentLaboratory", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  LoggedUserFieldsBuilder labRole({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("labRole", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  LoggedUserFieldsBuilder userIsLabOwner({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("userIsLabOwner", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
