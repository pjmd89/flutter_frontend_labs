import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "query_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Query {
  final SystemInfo? systemInfo;
  final EdgeCompany? getCompanies;
  final EdgeEvaluationPackage? getExamResults;
  final EdgeExam? getExams;
  final EdgeExamTemplate? getExamTemplates;
  final EdgeInvoice? getInvoices;
  final EdgeLaboratory? getLaboratories;
  final EdgePatient? getPatients;
  final EdgeUser? getUsers;
  final User? getLoggedUser;
  final User? logout;
  Query({
    this.systemInfo,
    this.getCompanies,
    this.getExamResults,
    this.getExams,
    this.getExamTemplates,
    this.getInvoices,
    this.getLaboratories,
    this.getPatients,
    this.getUsers,
    this.getLoggedUser,
    this.logout,
  });
  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);
  Map<String, dynamic> toJson() => _$QueryToJson(this);
}
