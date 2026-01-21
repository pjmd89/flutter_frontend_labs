import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/updateExam/updateexam_mutation.dart';
import 'package:labs/src/domain/usecases/Exam/update_exam_usecase.dart';
import 'package:labs/src/domain/extensions/exam_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  
  final UpdateExamInput input = UpdateExamInput();
  Exam? _currentExam;
  
  Exam? get currentExam => _currentExam;
  bool get loading => _loading;
  
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }
  
  ViewModel({
    required BuildContext context,
    required Exam exam,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<GQLNotifier>().errorService;
    _currentExam = exam;
    
    // Prellenar input con datos existentes
    input.id = exam.id;
    input.baseCost = exam.baseCost;
  }
  
  AppLocalizations get l10n => AppLocalizations.of(_context)!;
  
  Future<bool> update() async {
    bool isError = true;
    loading = true;

    UpdateExamUsecase useCase = UpdateExamUsecase(
      operation: UpdateExamMutation(builder: ExamFieldsBuilder().defaultValues()),
      conn: _gqlConn,
    );

    try {
      debugPrint('🔄 Iniciando update de Exam con ID: ${input.id}');
      debugPrint('📊 baseCost: ${input.baseCost}');
      
      var response = await useCase.execute(input: input);
      
      if (response is Exam) {
        isError = false;
        _currentExam = response;
        
        debugPrint('✅ Exam actualizado exitosamente: ${response.id}');
        
        _errorService.showError(
          message: l10n.thingUpdatedSuccessfully(l10n.exam),
          type: ErrorType.success,
        );
      } else {
        debugPrint('⚠️ Response no es Exam. Tipo: ${response.runtimeType}');
        _errorService.showError(
          message: l10n.somethingWentWrong,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en updateExam: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: '${l10n.somethingWentWrong}: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
