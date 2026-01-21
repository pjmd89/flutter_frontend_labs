// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class InvoiceFieldsBuilder {
  final List<String> _fields = [];
  InvoiceFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  InvoiceFieldsBuilder patient({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(PatientFieldsBuilder)? builder}) {
    final child = PatientFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("patient", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  InvoiceFieldsBuilder totalAmount({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("totalAmount", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  InvoiceFieldsBuilder orderID({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("orderID", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  InvoiceFieldsBuilder paymentStatus({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("paymentStatus", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  InvoiceFieldsBuilder laboratory({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("laboratory", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  InvoiceFieldsBuilder evaluationPackage({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EvaluationPackageFieldsBuilder)? builder}) {
    final child = EvaluationPackageFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("evaluationPackage", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  InvoiceFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  InvoiceFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
