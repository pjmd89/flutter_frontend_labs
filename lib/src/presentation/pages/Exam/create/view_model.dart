import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/createExam/createexam_mutation.dart';
import 'package:labs/src/domain/usecases/Exam/create_exam_usecase.dart';
import 'package:labs/src/domain/operation/queries/getExamTemplates/getexamtemplates_query.dart';
import 'package:labs/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import 'package:labs/src/domain/usecases/ExamTemplate/read_examtemplate_usecase.dart';
import 'package:labs/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import 'package:labs/src/domain/extensions/edgeexamtemplate_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/edgelaboratory_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;
  bool _loadingData = true;
  List<ExamTemplate> _examTemplates = [];
  List<Laboratory> _laboratories = [];
  
  final CreateExamInput input = CreateExamInput(
    template: '',
    laboratory: '',
    baseCost: 0,
  );

  bool get loading => _loading;
  bool get loadingData => _loadingData;
  List<ExamTemplate> get examTemplates => _examTemplates;
  List<Laboratory> get laboratories => _laboratories;

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

  set laboratories(List<Laboratory> value) {
    _laboratories = value;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _init();
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

      // Cargar Laboratories
      final laboratoryUseCase = ReadLaboratoryUsecase(
        operation: GetLaboratoriesQuery(
          builder: EdgeLaboratoryFieldsBuilder().defaultValues(),
        ),
        conn: _gqlConn,
      );
      
      final laboratoryResponse = await laboratoryUseCase.readWithoutPaginate();
      
      if (laboratoryResponse is EdgeLaboratory) {
        laboratories = laboratoryResponse.edges;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error cargando datos iniciales: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al cargar datos: ${e.toString()}',
      );
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
      
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al crear examen: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
