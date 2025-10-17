// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class PageInfoFieldsBuilder {
  final List<String> _fields = [];
  PageInfoFieldsBuilder page({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("page", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PageInfoFieldsBuilder pages({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("pages", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PageInfoFieldsBuilder shown({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("shown", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PageInfoFieldsBuilder total({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("total", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PageInfoFieldsBuilder overall({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("overall", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PageInfoFieldsBuilder split({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("split", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
