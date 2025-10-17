// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class CompanyFieldsBuilder {
  final List<String> _fields = [];
  CompanyFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  CompanyFieldsBuilder name({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("name", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  CompanyFieldsBuilder logo({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("logo", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  CompanyFieldsBuilder taxID({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("taxID", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  CompanyFieldsBuilder owner({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(UserFieldsBuilder)? builder}) {
    final child = UserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("owner", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  CompanyFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  CompanyFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
