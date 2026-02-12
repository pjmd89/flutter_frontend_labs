import 'dart:typed_data';
import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/updateEvaluationPackage/updateevaluationpackage_mutation.dart';
import 'package:labs/src/domain/operation/mutations/approveEvaluationPackage/approveevaluationpackage_mutation.dart';
import 'package:labs/src/domain/usecases/EvaluationPackage/update_evaluationpackage_usecase.dart';
import 'package:labs/src/domain/usecases/EvaluationPackage/approve_evaluationpackage_usecase.dart';
import 'package:labs/src/domain/usecases/upload/upload_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  bool _uploadingSignature = false;
  
  final UpdateEvaluationInput input = UpdateEvaluationInput();
  EvaluationPackage? _currentEvaluationPackage;
  
  String? _uploadedSignaturePath;
  String? _signatureOriginalFileName;
  Uint8List? _signatureImageBytes;
  
  EvaluationPackage? get currentEvaluationPackage => _currentEvaluationPackage;
  bool get loading => _loading;
  bool get uploadingSignature => _uploadingSignature;
  String? get uploadedSignaturePath => _uploadedSignaturePath;
  Uint8List? get signatureImageBytes => _signatureImageBytes;
  bool get hasSignature => _signatureImageBytes != null;
  String? get signatureDisplayFileName => _signatureOriginalFileName;
  
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }
  
  set uploadingSignature(bool newUploading) {
    _uploadingSignature = newUploading;
    notifyListeners();
  }
  
  ViewModel({
    required BuildContext context,
    required EvaluationPackage evaluationPackage,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    _currentEvaluationPackage = evaluationPackage;
    
    // 🐛 DEBUG: Ver qué tiene el evaluationPackage original
    debugPrint('🔍 EvaluationPackage recibido:');
    debugPrint('  - ID: ${evaluationPackage.id}');
    debugPrint('  - Observations: ${evaluationPackage.observations}');
    debugPrint('  - Status: ${evaluationPackage.status}');
    debugPrint('  - ValuesByExam count: ${evaluationPackage.valuesByExam.length}');
    for (var i = 0; i < evaluationPackage.valuesByExam.length; i++) {
      final examResult = evaluationPackage.valuesByExam[i];
      debugPrint('    ExamResult #$i:');
      debugPrint('      - Exam ID: ${examResult.exam?.id}');
      debugPrint('      - IndicatorValues count: ${examResult.indicatorValues.length}');
      for (var j = 0; j < examResult.indicatorValues.length; j++) {
        final iv = examResult.indicatorValues[j];
        debugPrint('        IndicatorValue #$j: value="${iv.value}"');
      }
    }
    
    // Prellenar input con datos existentes
    input.id = evaluationPackage.id;
    // ❌ NO prellenar observations aquí - se llenará solo cuando el usuario edite
    // Las observaciones se muestran prellenadas en el controller del UI pero no se envían
    // a menos que el usuario las modifique
    
    // Prellenar allResultsCompleted basado en el estado actual
    input.allResultsCompleted = evaluationPackage.status == ResultStatus.cOMPLETED;
    
    // Prellenar valuesByExam (estructura compleja)
    input.valuesByExam = evaluationPackage.valuesByExam.map((examResult) {
      final indicatorValues = <SetIndicatorValue>[];
      
      for (var i = 0; i < examResult.indicatorValues.length; i++) {
        indicatorValues.add(SetIndicatorValue(
          indicatorIndex: i,
          value: examResult.indicatorValues[i].value,
        ));
      }
      
      debugPrint('🔍 Mapeando ExamResult: exam=${examResult.exam?.id}, indicatorValues count=${indicatorValues.length}');
      
      return ExamResultInput(
        exam: examResult.exam?.id ?? '',
        indicatorValues: indicatorValues,
      );
    }).toList();
    
    debugPrint('🔍 Input prellenado: valuesByExam count = ${input.valuesByExam?.length ?? 0}');
  }
  
  AppLocalizations get l10n => AppLocalizations.of(_context)!;
  
  Future<bool> update() async {
    bool isError = true;
    loading = true;

    // ✅ DEBUG: Ver qué se está enviando
    debugPrint('🔍 Input que se enviará al backend:');
    debugPrint('  - ID: ${input.id}');
    debugPrint('  - Observations: ${input.observations}');
    debugPrint('  - AllResultsCompleted: ${input.allResultsCompleted}');
    debugPrint('  - ValuesByExam count: ${input.valuesByExam?.length ?? 0}');
    if (input.valuesByExam != null) {
      for (var i = 0; i < input.valuesByExam!.length; i++) {
        final examResult = input.valuesByExam![i];
        debugPrint('    Exam #$i: exam=${examResult.exam}, indicatorValues count=${examResult.indicatorValues.length}');
      }
    }
    debugPrint('  - JSON completo: ${input.toJson()}');

    UpdateEvaluationPackageUsecase useCase = UpdateEvaluationPackageUsecase(
      operation: UpdateEvaluationPackageMutation(
        builder: EvaluationPackageFieldsBuilder()
          ..id()
          ..status()
          ..observations()
          ..valuesByExam(
            builder: (examResultBuilder) {
              examResultBuilder
                ..exam(
                  builder: (examBuilder) {
                    examBuilder.id();
                  },
                )
                ..indicatorValues(
                  builder: (indicatorValueBuilder) {
                    indicatorValueBuilder
                      ..value()
                      ..indicator(
                        builder: (indicatorBuilder) {
                          indicatorBuilder
                            ..name()
                            ..unit()
                            ..valueType();
                        },
                      );
                  },
                );
            },
          )
          ..updated(),
      ),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute(input: input);
      
      // 🐛 DEBUG: Ver tipo y valor de la respuesta
      debugPrint('✅ Response recibido en ViewModel:');
      debugPrint('  - Type: ${response.runtimeType}');
      debugPrint('  - Value: $response');
      debugPrint('  - Is EvaluationPackage? ${response is EvaluationPackage}');
      
      if (response is EvaluationPackage) {
        debugPrint('✅ Response ES EvaluationPackage - Todo OK!');
        isError = false;
        _currentEvaluationPackage = response;
        
        _errorService.showError(
          message: l10n.thingUpdatedSuccessfully(l10n.evaluationPackage),
          type: ErrorType.success,
        );
      } else {
        debugPrint('❌ Response NO es EvaluationPackage - isError sigue siendo true');
        debugPrint('   Por eso no se ejecuta el pop(true)');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en updateEvaluationPackage: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      // Solo mostrar error si no es un error controlado del backend
      // (Los errores controlados ya fueron mostrados por el ErrorManager)
      final errorMessage = e.toString();
      if (!errorMessage.contains('Backend error handled')) {
        _errorService.showError(
          message: '${l10n.errorUpdating}: $errorMessage',
          type: ErrorType.error,
        );
      }
      // Si es "Backend error handled", el ErrorManager ya mostró el mensaje traducido
    } finally {
      loading = false;
    }

    return isError;
  }
  
  Future<bool> approve() async {
    bool isError = true;
    loading = true;

    ApproveEvaluationPackageUsecase useCase = ApproveEvaluationPackageUsecase(
      operation: ApproveEvaluationPackageMutation(
        builder: EvaluationPackageFieldsBuilder()
          ..id()
          ..status()
          ..isApproved()
          ..bioanalystReview(
            builder: (bioanalystReviewBuilder) {
              bioanalystReviewBuilder
                ..bioanalyst(
                  builder: (userBuilder) {
                    userBuilder
                      ..id()
                      ..firstName()
                      ..lastName();
                  },
                )
                ..signatureFilepath()
                ..reviewedAt();
            },
          )
          ..updated(),
      ),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute(
        evaluationPackageId: input.id,
        signatureFilepath: _uploadedSignaturePath,
      );
      
      debugPrint('✅ Response recibido en ViewModel (approve):');
      debugPrint('  - Type: ${response.runtimeType}');
      debugPrint('  - Value: $response');
      debugPrint('  - Is EvaluationPackage? ${response is EvaluationPackage}');
      
      if (response is EvaluationPackage) {
        debugPrint('✅ Aprobación exitosa!');
        isError = false;
        _currentEvaluationPackage = response;
        
        _errorService.showError(
          message: l10n.evaluationPackageApprovedSuccessfully,
          type: ErrorType.success,
        );
      } else {
        debugPrint('❌ Response NO es EvaluationPackage');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en approveEvaluationPackage: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      // Solo mostrar error si no es un error controlado del backend
      final errorMessage = e.toString();
      if (!errorMessage.contains('Backend error handled')) {
        _errorService.showError(
          message: '${l10n.errorApprovingEvaluationPackage}: $errorMessage',
          type: ErrorType.error,
        );
      }
    } finally {
      loading = false;
    }

    return isError;
  }
  
  /// Sube la firma del bioanalista
  Future<bool> uploadSignature({
    required Uint8List fileBytes,
    required String fileName,
    required String evaluationPackageId,
  }) async {
    uploadingSignature = true;

    try {
      final uploadUseCase = UploadFileUseCase(conn: _gqlConn);

      debugPrint('📤 Iniciando upload de firma: $fileName, ${fileBytes.length} bytes');

      final result = await uploadUseCase.uploadFile(
        fileOriginalName: fileName,
        fileDestinyName: 'signature_$evaluationPackageId',
        fileBytes: fileBytes,
        destinyDirectory: 'evaluations/signatures',
        userId: evaluationPackageId,
        onlyXlsx: false,
      );

      debugPrint('📦 Resultado upload - success: ${result.success}, code: ${result.code}');
      debugPrint('📦 uploadedFile: ${result.uploadedFile}');

      if (result.success && result.uploadedFile != null) {
        _uploadedSignaturePath = '${result.uploadedFile!['folder']}/${result.uploadedFile!['name']}';
        _signatureOriginalFileName = fileName;
        _signatureImageBytes = fileBytes;

        debugPrint('✅ Firma subida exitosamente: $_uploadedSignaturePath');

        _errorService.showError(
          message: l10n.signatureUploadedSuccessfully,
          type: ErrorType.success,
        );

        return true;
      } else {
        String errorMessage;
        switch (result.code) {
          case UploadFileUseCase.codeNoExtension:
            errorMessage = 'El archivo no tiene extensión';
            break;
          case UploadFileUseCase.codeInvalidExtension:
            errorMessage = 'Extensión no válida. Use: jpeg, jpg, png, gif';
            break;
          case UploadFileUseCase.codeUploadError:
            errorMessage = 'Error al subir el archivo';
            break;
          default:
            errorMessage = 'Error desconocido';
        }

        debugPrint('❌ Error al subir firma: $errorMessage');

        _errorService.showError(
          message: errorMessage,
          type: ErrorType.error,
        );

        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al subir firma: $e');
      debugPrint('📍 StackTrace: $stackTrace');

      _errorService.showError(
        message: '${l10n.errorUploadingSignature}: ${e.toString()}',
        type: ErrorType.error,
      );

      return false;
    } finally {
      uploadingSignature = false;
    }
  }
}
