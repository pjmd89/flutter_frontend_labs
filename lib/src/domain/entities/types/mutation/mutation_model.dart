import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "mutation_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Mutation {
  final ChangeLog? addChangeLog;
  final Company? updateCompany;
  final EvaluationPackage? updateEvaluationPackage;
  final EvaluationPackage? approveEvaluationPackage;
  final Exam? createExam;
  final Exam? updateExam;
  final Exam? deleteExam;
  final ExamTemplate? createExamTemplate;
  final ExamTemplate? updateExamTemplate;
  final ExamTemplate? deleteExamTemplate;
  final Invoice? createInvoice;
  final Invoice? cancelInvoicePayment;
  final Invoice? markInvoiceAsPaid;
  final Laboratory? createLaboratory;
  final Laboratory? updateLaboratory;
  final Laboratory? deleteLaboratory;
  final Laboratory? manageLaboratoryEmployees;
  final LoggedUser? setCurrentLaboratory;
  final Patient? createPatient;
  final Patient? updatePatient;
  final Patient? deletePatient;
  final Upload? upload;
  final Upload? cancelUpload;
  final User? createUser;
  final User? updateUser;
  final User? deleteUser;
  Mutation({
    this.addChangeLog,
    this.updateCompany,
    this.updateEvaluationPackage,
    this.approveEvaluationPackage,
    this.createExam,
    this.updateExam,
    this.deleteExam,
    this.createExamTemplate,
    this.updateExamTemplate,
    this.deleteExamTemplate,
    this.createInvoice,
    this.cancelInvoicePayment,
    this.markInvoiceAsPaid,
    this.createLaboratory,
    this.updateLaboratory,
    this.deleteLaboratory,
    this.manageLaboratoryEmployees,
    this.setCurrentLaboratory,
    this.createPatient,
    this.updatePatient,
    this.deletePatient,
    this.upload,
    this.cancelUpload,
    this.createUser,
    this.updateUser,
    this.deleteUser,
  });
  factory Mutation.fromJson(Map<String, dynamic> json) => _$MutationFromJson(json);
  Map<String, dynamic> toJson() => _$MutationToJson(this);
}
