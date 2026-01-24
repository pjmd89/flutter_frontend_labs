// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class EvaluationPackageFieldsBuilder {
  final List<String> _fields = [];
  EvaluationPackageFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  EvaluationPackageFieldsBuilder valuesByExam({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(ExamResultFieldsBuilder)? builder}) {
    final child = ExamResultFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("valuesByExam", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  EvaluationPackageFieldsBuilder status({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("status", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  EvaluationPackageFieldsBuilder pdfFilepath({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("pdfFilepath", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  EvaluationPackageFieldsBuilder completedAt({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("completedAt", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  EvaluationPackageFieldsBuilder referred({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("referred", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  EvaluationPackageFieldsBuilder observations({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("observations", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  EvaluationPackageFieldsBuilder isApproved({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("isApproved", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  EvaluationPackageFieldsBuilder bioanalystReview({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(BioanalystReviewFieldsBuilder)? builder}) {
    final child = BioanalystReviewFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("bioanalystReview", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  EvaluationPackageFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  EvaluationPackageFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
