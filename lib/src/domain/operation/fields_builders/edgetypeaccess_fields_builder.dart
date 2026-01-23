// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:labs/src/domain/operation/fields_builders/typeaccess_fields_builder.dart';
import 'main.dart';
class EdgeTypeAccessFieldsBuilder {
  final List<String> _fields = [];
  EdgeTypeAccessFieldsBuilder edges({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(TypeAccessFieldsBuilder)? builder}) {
    final child = TypeAccessFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("edges", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  EdgeTypeAccessFieldsBuilder pageInfo({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(PageInfoFieldsBuilder)? builder}) {
    final child = PageInfoFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("pageInfo", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
