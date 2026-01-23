// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
  systemInfo:
      json['systemInfo'] == null
          ? null
          : SystemInfo.fromJson(json['systemInfo'] as Map<String, dynamic>),
  getCompanies:
      json['getCompanies'] == null
          ? null
          : EdgeCompany.fromJson(json['getCompanies'] as Map<String, dynamic>),
  getExamResults:
      json['getExamResults'] == null
          ? null
          : EdgeEvaluationPackage.fromJson(
            json['getExamResults'] as Map<String, dynamic>,
          ),
  getExams:
      json['getExams'] == null
          ? null
          : EdgeExam.fromJson(json['getExams'] as Map<String, dynamic>),
  getExamTemplates:
      json['getExamTemplates'] == null
          ? null
          : EdgeExamTemplate.fromJson(
            json['getExamTemplates'] as Map<String, dynamic>,
          ),
  getInvoices:
      json['getInvoices'] == null
          ? null
          : EdgeInvoice.fromJson(json['getInvoices'] as Map<String, dynamic>),
  getLabMemberships:
      json['getLabMemberships'] == null
          ? null
          : EdgeLabMembershipInfo.fromJson(
            json['getLabMemberships'] as Map<String, dynamic>,
          ),
  getLaboratories:
      json['getLaboratories'] == null
          ? null
          : EdgeLaboratory.fromJson(
            json['getLaboratories'] as Map<String, dynamic>,
          ),
  getLoggedUser:
      json['getLoggedUser'] == null
          ? null
          : LoggedUser.fromJson(json['getLoggedUser'] as Map<String, dynamic>),
  getPatients:
      json['getPatients'] == null
          ? null
          : EdgePatient.fromJson(json['getPatients'] as Map<String, dynamic>),
  getAccess:
      json['getAccess'] == null
          ? null
          : EdgeTypeAccess.fromJson(json['getAccess'] as Map<String, dynamic>),
  checkFileSize:
      json['checkFileSize'] == null
          ? null
          : Upload.fromJson(json['checkFileSize'] as Map<String, dynamic>),
  getUsers:
      json['getUsers'] == null
          ? null
          : EdgeUser.fromJson(json['getUsers'] as Map<String, dynamic>),
  logout:
      json['logout'] == null
          ? null
          : User.fromJson(json['logout'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QueryToJson(Query instance) => <String, dynamic>{
  if (instance.systemInfo case final value?) 'systemInfo': value,
  if (instance.getCompanies case final value?) 'getCompanies': value,
  if (instance.getExamResults case final value?) 'getExamResults': value,
  if (instance.getExams case final value?) 'getExams': value,
  if (instance.getExamTemplates case final value?) 'getExamTemplates': value,
  if (instance.getInvoices case final value?) 'getInvoices': value,
  if (instance.getLabMemberships case final value?) 'getLabMemberships': value,
  if (instance.getLaboratories case final value?) 'getLaboratories': value,
  if (instance.getLoggedUser case final value?) 'getLoggedUser': value,
  if (instance.getPatients case final value?) 'getPatients': value,
  if (instance.getAccess case final value?) 'getAccess': value,
  if (instance.checkFileSize case final value?) 'checkFileSize': value,
  if (instance.getUsers case final value?) 'getUsers': value,
  if (instance.logout case final value?) 'logout': value,
};
