// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class UserFieldsBuilder {
  final List<String> _fields = [];
  UserFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UserFieldsBuilder firstName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("firstName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UserFieldsBuilder lastName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("lastName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UserFieldsBuilder role({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("role", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UserFieldsBuilder email({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("email", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UserFieldsBuilder cutOffDate({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("cutOffDate", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UserFieldsBuilder fee({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("fee", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UserFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UserFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
