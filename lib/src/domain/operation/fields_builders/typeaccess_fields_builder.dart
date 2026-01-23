// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class TypeAccessFieldsBuilder {
  final List<String> _fields = [];
  TypeAccessFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  TypeAccessFieldsBuilder name({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("name", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  TypeAccessFieldsBuilder operations({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("operations", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
