import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/updateExamTemplate/updateexamtemplate_mutation.dart';
import 'package:labs/src/domain/usecases/ExamTemplate/update_examtemplate_usecase.dart';
import 'package:labs/src/domain/usecases/ExamTemplate/read_examtemplate_usecase.dart';
import 'package:labs/src/domain/operation/queries/getExamTemplates/getexamtemplates_query.dart';
import 'package:labs/src/domain/extensions/edgeexamtemplate_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  bool _error = false;
  
  final UpdateExamTemplateInput input = UpdateExamTemplateInput();
  ExamTemplate? _currentExamTemplate;
  
  ExamTemplate? get currentExamTemplate => _currentExamTemplate;
  bool get loading => _loading;
  bool get error => _error;
  
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }
  
  set error(bool newError) {
    _error = newError;
    notifyListeners();
  }
  
  ViewModel({
    required BuildContext context,
    required String examTemplateId,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    loadData(examTemplateId);
  }
  
  AppLocalizations get l10n => AppLocalizations.of(_context)!;
  
  Future<void> loadData(String id) async {
    loading = true;
    error = false;
    
    try {
      debugPrint('🔍 Cargando ExamTemplate con ID: $id');
      
      ReadExamTemplateUsecase useCase = ReadExamTemplateUsecase(
        operation: GetExamTemplatesQuery(
          builder: EdgeExamTemplateFieldsBuilder().defaultValues()
        ),
        conn: _gqlConn,
      );
      
      var response = await useCase.build();
      
      debugPrint('🔍 Tipo de response: ${response.runtimeType}');
      
      if (response is EdgeExamTemplate && response.edges.isNotEmpty) {
        // Filtrar ExamTemplate por ID en memoria
        final templates = response.edges.where((template) => template.id == id).toList();
        
        if (templates.isNotEmpty) {
          _currentExamTemplate = templates.first;
          debugPrint('✅ ExamTemplate cargado: ${_currentExamTemplate!.name}');
          
          // Prellenar input con datos existentes
          input.id = _currentExamTemplate!.id;
          input.name = _currentExamTemplate!.name;
          input.description = _currentExamTemplate!.description;
          
          // Convertir ExamIndicator a CreateExamIndicator para edición
          input.indicators = _currentExamTemplate!.indicators.map((indicator) {
            return CreateExamIndicator(
              name: indicator.name,
              valueType: indicator.valueType,
              unit: indicator.unit,
              normalRange: indicator.normalRange,
            );
          }).toList();
          
          debugPrint('✅ Input prellenado: ${input.toJson()}');
        } else {
          debugPrint('⚠️ No se encontró ExamTemplate con ID: $id');
          error = true;
          _errorService.showError(
            message: l10n.recordNotFound,
            type: ErrorType.error,
          );
        }
      } else if (response is EdgeExamTemplate && response.edges.isEmpty) {
        debugPrint('⚠️ EdgeExamTemplate sin datos');
        error = true;
        _errorService.showError(
          message: l10n.recordNotFound,
          type: ErrorType.error,
        );
      } else {
        debugPrint('⚠️ Response no es EdgeExamTemplate');
        error = true;
        _errorService.showError(
          message: l10n.somethingWentWrong,
          type: ErrorType.error,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en loadData: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      
      _errorService.showError(
        message: 'Error al cargar plantilla: ${e.toString()}',
        type: ErrorType.error,
      );
    } finally {
      loading = false;
    }
  }
  
  Future<bool> update() async {
    bool isError = true;
    loading = true;

    UpdateExamTemplateUsecase useCase = UpdateExamTemplateUsecase(
      operation: UpdateExamTemplateMutation(builder: ExamTemplateFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      debugPrint('🔄 Actualizando ExamTemplate: ${input.toJson()}');
      
      var response = await useCase.execute(input: input);
 
      if (response is ExamTemplate) {
        isError = false;
        _currentExamTemplate = response;
        debugPrint('✅ ExamTemplate actualizado exitosamente');
        
        _errorService.showError(
          message: l10n.thingUpdatedSuccessfully(l10n.examTemplate),
          type: ErrorType.success,
        );
      } else {
        debugPrint('⚠️ Response NO es de tipo ExamTemplate');
        isError = true;
        
        _errorService.showError(
          message: l10n.errorUpdating,
          type: ErrorType.error,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en updateExamTemplate: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: 'Error al actualizar plantilla: ${e.toString()}',
        type: ErrorType.error,
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
