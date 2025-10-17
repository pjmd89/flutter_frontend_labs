// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class PatientFieldsBuilder {
  final List<String> _fields = [];
  PatientFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder firstName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("firstName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder lastName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("lastName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder sex({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("sex", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder birthDate({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("birthDate", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder species({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("species", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder dni({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("dni", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder phone({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("phone", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder email({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("email", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder address({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("address", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder laboratory({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("laboratory", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  PatientFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
