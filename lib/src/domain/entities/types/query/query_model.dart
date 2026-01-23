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
  final EdgeLabMembershipInfo? getLabMemberships;
  final EdgeLaboratory? getLaboratories;
  final LoggedUser? getLoggedUser;
  final EdgePatient? getPatients;
  final EdgeTypeAccess? getAccess;
  final Upload? checkFileSize;
  final EdgeUser? getUsers;
  final User? logout;
  Query({
    this.systemInfo,
    this.getCompanies,
    this.getExamResults,
    this.getExams,
    this.getExamTemplates,
    this.getInvoices,
    this.getLabMemberships,
    this.getLaboratories,
    this.getLoggedUser,
    this.getPatients,
    this.getAccess,
    this.checkFileSize,
    this.getUsers,
    this.logout,
  });
  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);
  Map<String, dynamic> toJson() => _$QueryToJson(this);
}
