// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class LaboratoryFieldsBuilder {
  final List<String> _fields = [];
  LaboratoryFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  LaboratoryFieldsBuilder company({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(CompanyFieldsBuilder)? builder}) {
    final child = CompanyFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("company", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  LaboratoryFieldsBuilder employees({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EdgeUserFieldsBuilder)? builder}) {
    final child = EdgeUserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("employees", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  LaboratoryFieldsBuilder address({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("address", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  LaboratoryFieldsBuilder contactPhoneNumbers({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("contactPhoneNumbers", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  LaboratoryFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  LaboratoryFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
