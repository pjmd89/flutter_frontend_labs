import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/createExam/createexam_mutation.dart';
import 'package:labs/src/domain/usecases/Exam/create_exam_usecase.dart';
import 'package:labs/src/domain/operation/queries/getExamTemplates/getexamtemplates_query.dart';
import 'package:labs/src/domain/usecases/ExamTemplate/read_examtemplate_usecase.dart';
import 'package:labs/src/domain/extensions/edgeexamtemplate_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late LaboratoryNotifier _laboratoryNotifier;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  bool _loadingData = true;
  List<ExamTemplate> _examTemplates = [];
  
  final CreateExamInput input = CreateExamInput(
    template: '',
    laboratory: '',
    baseCost: 0,
  );

  bool get loading => _loading;
  bool get loadingData => _loadingData;
  List<ExamTemplate> get examTemplates => _examTemplates;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set loadingData(bool value) {
    _loadingData = value;
    notifyListeners();
  }

  set examTemplates(List<ExamTemplate> value) {
    _examTemplates = value;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _laboratoryNotifier = _context.read<LaboratoryNotifier>();
    _errorService = _context.read<ErrorService>();
    _assignLaboratoryFromContext();
    _init();
  }

  void _assignLaboratoryFromContext() {
    final labId = _laboratoryNotifier.selectedLaboratory?.id;
    if (labId != null && labId.isNotEmpty) {
      input.laboratory = labId;
      debugPrint('🔗 Laboratory asignado desde contexto: $labId');
    } else {
      debugPrint('⚠️ No hay laboratorio seleccionado en contexto');
    }
  }

  Future<void> _init() async {
    await _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    loadingData = true;

    try {
      // Cargar ExamTemplates
      final examTemplateUseCase = ReadExamTemplateUsecase(
        operation: GetExamTemplatesQuery(
          builder: EdgeExamTemplateFieldsBuilder().defaultValues(),
        ),
        conn: _gqlConn,
      );
      
      final examTemplateResponse = await examTemplateUseCase.readWithoutPaginate();
      
      if (examTemplateResponse is EdgeExamTemplate) {
        examTemplates = examTemplateResponse.edges;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error cargando datos iniciales: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      
     
    } finally {
      loadingData = false;
    }
  }

  Future<bool> create() async {
    bool isError = true;
    loading = true;

    CreateExamUsecase useCase = CreateExamUsecase(
      operation: CreateExamMutation(
        builder: ExamFieldsBuilder()
      ),
      conn: _gqlConn,
    );

    try {
      final labId = _laboratoryNotifier.selectedLaboratory?.id;
      if (labId == null || labId.isEmpty) {
        final l10n = AppLocalizations.of(_context)!;
        _errorService.showError(message: l10n.selectLaboratory);
        return true;
      }

      input.laboratory = labId;

      var response = await useCase.execute(input: input);
      
      if (response is Exam) {
        isError = false;
      } else {
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en createExam: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
     
    } finally {
      loading = false;
    }

    return isError;
  }
}
