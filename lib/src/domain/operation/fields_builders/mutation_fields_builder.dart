// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class MutationFieldsBuilder {
  final List<String> _fields = [];
  MutationFieldsBuilder addChangeLog({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ChangeLogFieldsBuilder)? builder}) {
    final child = ChangeLogFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("addChangeLog", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder updateCompany({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(CompanyFieldsBuilder)? builder}) {
    final child = CompanyFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("updateCompany", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder updateEvaluationPackage({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(EvaluationPackageFieldsBuilder)? builder}) {
    final child = EvaluationPackageFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("updateEvaluationPackage", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder createExam({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamFieldsBuilder)? builder}) {
    final child = ExamFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("createExam", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder updateExam({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamFieldsBuilder)? builder}) {
    final child = ExamFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("updateExam", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder deleteExam({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamFieldsBuilder)? builder}) {
    final child = ExamFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("deleteExam", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder createExamTemplate({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamTemplateFieldsBuilder)? builder}) {
    final child = ExamTemplateFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("createExamTemplate", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder updateExamTemplate({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamTemplateFieldsBuilder)? builder}) {
    final child = ExamTemplateFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("updateExamTemplate", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder deleteExamTemplate({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamTemplateFieldsBuilder)? builder}) {
    final child = ExamTemplateFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("deleteExamTemplate", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder createInvoice({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(InvoiceFieldsBuilder)? builder}) {
    final child = InvoiceFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("createInvoice", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder createLaboratory({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("createLaboratory", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder updateLaboratory({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("updateLaboratory", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder deleteLaboratory({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("deleteLaboratory", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder manageLaboratoryEmployees({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("manageLaboratoryEmployees", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder createPatient({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(PatientFieldsBuilder)? builder}) {
    final child = PatientFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("createPatient", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder updatePatient({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(PatientFieldsBuilder)? builder}) {
    final child = PatientFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("updatePatient", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder createUser({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(UserFieldsBuilder)? builder}) {
    final child = UserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("createUser", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder updateUser({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(UserFieldsBuilder)? builder}) {
    final child = UserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("updateUser", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  MutationFieldsBuilder deleteUser({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(UserFieldsBuilder)? builder}) {
    final child = UserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("deleteUser", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
