// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class ResponsiblePartyFieldsBuilder {
  final List<String> _fields = [];
  ResponsiblePartyFieldsBuilder firstName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("firstName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ResponsiblePartyFieldsBuilder lastName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("lastName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ResponsiblePartyFieldsBuilder dni({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("dni", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  ResponsiblePartyFieldsBuilder address({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("address", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
