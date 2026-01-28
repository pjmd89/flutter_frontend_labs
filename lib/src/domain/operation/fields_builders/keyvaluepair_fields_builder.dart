// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class KeyValuePairFieldsBuilder {
  final List<String> _fields = [];
  KeyValuePairFieldsBuilder key({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("key", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  KeyValuePairFieldsBuilder value({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("value", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
