// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class QueryFieldsBuilder {
  final List<String> _fields = [];
  QueryFieldsBuilder systemInfo({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(SystemInfoFieldsBuilder)? builder}) {
    final child = SystemInfoFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("systemInfo", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  QueryFieldsBuilder getCompanies({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EdgeCompanyFieldsBuilder)? builder}) {
    final child = EdgeCompanyFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("getCompanies", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  QueryFieldsBuilder getExamResults({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EdgeEvaluationPackageFieldsBuilder)? builder}) {
    final child = EdgeEvaluationPackageFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("getExamResults", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  QueryFieldsBuilder getExams({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EdgeExamFieldsBuilder)? builder}) {
    final child = EdgeExamFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("getExams", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  QueryFieldsBuilder getExamTemplates({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EdgeExamTemplateFieldsBuilder)? builder}) {
    final child = EdgeExamTemplateFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("getExamTemplates", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  QueryFieldsBuilder getInvoices({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EdgeInvoiceFieldsBuilder)? builder}) {
    final child = EdgeInvoiceFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("getInvoices", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  QueryFieldsBuilder getLaboratories({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EdgeLaboratoryFieldsBuilder)? builder}) {
    final child = EdgeLaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("getLaboratories", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  QueryFieldsBuilder getPatients({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EdgePatientFieldsBuilder)? builder}) {
    final child = EdgePatientFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("getPatients", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  QueryFieldsBuilder getUsers({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EdgeUserFieldsBuilder)? builder}) {
    final child = EdgeUserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("getUsers", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  QueryFieldsBuilder getLoggedUser({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(UserFieldsBuilder)? builder}) {
    final child = UserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("getLoggedUser", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  QueryFieldsBuilder logout({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(UserFieldsBuilder)? builder}) {
    final child = UserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("logout", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
