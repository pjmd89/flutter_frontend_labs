// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class BioanalystReviewFieldsBuilder {
  final List<String> _fields = [];
  BioanalystReviewFieldsBuilder bioanalyst({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(UserFieldsBuilder)? builder}) {
    final child = UserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("bioanalyst", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  BioanalystReviewFieldsBuilder reviewedAt({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("reviewedAt", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
