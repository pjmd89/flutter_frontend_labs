// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class MemberAccessFieldsBuilder {
  final List<String> _fields = [];
  MemberAccessFieldsBuilder type({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("type", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  MemberAccessFieldsBuilder permissions({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("permissions", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
