// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:labs/src/domain/operation/fields_builders/person_fields_builder.dart';
class AnimalFieldsBuilder {
  final List<String> _fields = [];
  AnimalFieldsBuilder firstName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("firstName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  AnimalFieldsBuilder species({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("species", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  AnimalFieldsBuilder lastName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("lastName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  AnimalFieldsBuilder birthDate({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("birthDate", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  AnimalFieldsBuilder sex({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("sex", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  AnimalFieldsBuilder owner({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(PersonFieldsBuilder)? builder}) {
    final child = PersonFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("owner", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
