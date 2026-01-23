import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/updateEvaluationPackage/updateevaluationpackage_mutation.dart';
import 'package:labs/src/domain/usecases/EvaluationPackage/update_evaluationpackage_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  
  final UpdateEvaluationInput input = UpdateEvaluationInput();
  EvaluationPackage? _currentEvaluationPackage;
  
  EvaluationPackage? get currentEvaluationPackage => _currentEvaluationPackage;
  bool get loading => _loading;
  
  set loading(bool newLoading) {
    _loading = newLoading;
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
    input.observations = List.from(evaluationPackage.observations);
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
                    examBuilder..id();
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
      
      if (response is EvaluationPackage) {
        isError = false;
        _currentEvaluationPackage = response;
        
        _errorService.showError(
          message: l10n.thingUpdatedSuccessfully(l10n.evaluationPackage),
          type: ErrorType.success,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en updateEvaluationPackage: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: 'Error al actualizar paquete de evaluación: ${e.toString()}',
        type: ErrorType.error,
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
