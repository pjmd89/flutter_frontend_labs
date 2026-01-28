// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class PersonFieldsBuilder {
  final List<String> _fields = [];
  PersonFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder firstName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("firstName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder lastName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("lastName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder dni({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("dni", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder phone({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("phone", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder email({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("email", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder address({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("address", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder birthDate({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("birthDate", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder sex({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("sex", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder laboratory({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("laboratory", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PersonFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
