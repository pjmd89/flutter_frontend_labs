// GENERATED-LIKE. Manual because original generator missing.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';

class EdgePersonFieldsBuilder {
  final List<String> _fields = [];

  EdgePersonFieldsBuilder edges({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(PersonFieldsBuilder)? builder}) {
    final child = PersonFieldsBuilder();
    builder?.call(child);
    final fieldStr = formatField("edges", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }

  EdgePersonFieldsBuilder pageInfo({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(PageInfoFieldsBuilder)? builder}) {
    final child = PageInfoFieldsBuilder();
    builder?.call(child);
    final fieldStr = formatField("pageInfo", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }

  String build() => _fields.join(" ");
}
