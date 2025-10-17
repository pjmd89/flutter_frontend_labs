// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mutation _$MutationFromJson(Map<String, dynamic> json) => Mutation(
  addChangeLog:
      json['addChangeLog'] == null
          ? null
          : ChangeLog.fromJson(json['addChangeLog'] as Map<String, dynamic>),
  updateCompany:
      json['updateCompany'] == null
          ? null
          : Company.fromJson(json['updateCompany'] as Map<String, dynamic>),
  updateEvaluationPackage:
      json['updateEvaluationPackage'] == null
          ? null
          : EvaluationPackage.fromJson(
            json['updateEvaluationPackage'] as Map<String, dynamic>,
          ),
  createExam:
      json['createExam'] == null
          ? null
          : Exam.fromJson(json['createExam'] as Map<String, dynamic>),
  updateExam:
      json['updateExam'] == null
          ? null
          : Exam.fromJson(json['updateExam'] as Map<String, dynamic>),
  deleteExam:
      json['deleteExam'] == null
          ? null
          : Exam.fromJson(json['deleteExam'] as Map<String, dynamic>),
  createExamTemplate:
      json['createExamTemplate'] == null
          ? null
          : ExamTemplate.fromJson(
            json['createExamTemplate'] as Map<String, dynamic>,
          ),
  updateExamTemplate:
      json['updateExamTemplate'] == null
          ? null
          : ExamTemplate.fromJson(
            json['updateExamTemplate'] as Map<String, dynamic>,
          ),
  deleteExamTemplate:
      json['deleteExamTemplate'] == null
          ? null
          : ExamTemplate.fromJson(
            json['deleteExamTemplate'] as Map<String, dynamic>,
          ),
  createInvoice:
      json['createInvoice'] == null
          ? null
          : Invoice.fromJson(json['createInvoice'] as Map<String, dynamic>),
  createLaboratory:
      json['createLaboratory'] == null
          ? null
          : Laboratory.fromJson(
            json['createLaboratory'] as Map<String, dynamic>,
          ),
  updateLaboratory:
      json['updateLaboratory'] == null
          ? null
          : Laboratory.fromJson(
            json['updateLaboratory'] as Map<String, dynamic>,
          ),
  deleteLaboratory:
      json['deleteLaboratory'] == null
          ? null
          : Laboratory.fromJson(
            json['deleteLaboratory'] as Map<String, dynamic>,
          ),
  manageLaboratoryEmployees:
      json['manageLaboratoryEmployees'] == null
          ? null
          : Laboratory.fromJson(
            json['manageLaboratoryEmployees'] as Map<String, dynamic>,
          ),
  createPatient:
      json['createPatient'] == null
          ? null
          : Patient.fromJson(json['createPatient'] as Map<String, dynamic>),
  updatePatient:
      json['updatePatient'] == null
          ? null
          : Patient.fromJson(json['updatePatient'] as Map<String, dynamic>),
  createUser:
      json['createUser'] == null
          ? null
          : User.fromJson(json['createUser'] as Map<String, dynamic>),
  updateUser:
      json['updateUser'] == null
          ? null
          : User.fromJson(json['updateUser'] as Map<String, dynamic>),
  deleteUser:
      json['deleteUser'] == null
          ? null
          : User.fromJson(json['deleteUser'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MutationToJson(Mutation instance) => <String, dynamic>{
  if (instance.addChangeLog case final value?) 'addChangeLog': value,
  if (instance.updateCompany case final value?) 'updateCompany': value,
  if (instance.updateEvaluationPackage case final value?)
    'updateEvaluationPackage': value,
  if (instance.createExam case final value?) 'createExam': value,
  if (instance.updateExam case final value?) 'updateExam': value,
  if (instance.deleteExam case final value?) 'deleteExam': value,
  if (instance.createExamTemplate case final value?)
    'createExamTemplate': value,
  if (instance.updateExamTemplate case final value?)
    'updateExamTemplate': value,
  if (instance.deleteExamTemplate case final value?)
    'deleteExamTemplate': value,
  if (instance.createInvoice case final value?) 'createInvoice': value,
  if (instance.createLaboratory case final value?) 'createLaboratory': value,
  if (instance.updateLaboratory case final value?) 'updateLaboratory': value,
  if (instance.deleteLaboratory case final value?) 'deleteLaboratory': value,
  if (instance.manageLaboratoryEmployees case final value?)
    'manageLaboratoryEmployees': value,
  if (instance.createPatient case final value?) 'createPatient': value,
  if (instance.updatePatient case final value?) 'updatePatient': value,
  if (instance.createUser case final value?) 'createUser': value,
  if (instance.updateUser case final value?) 'updateUser': value,
  if (instance.deleteUser case final value?) 'deleteUser': value,
};
