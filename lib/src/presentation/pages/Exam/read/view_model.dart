import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getExams/getexams_query.dart';
import '/src/domain/extensions/edgeexam_fields_builder_extension.dart';
import '/src/domain/usecases/Exam/read_exam_usecase.dart';
import '/src/domain/entities/inputs/searchinput_input.dart';
import '/src/domain/entities/types/pageinfo/pageinfo_model.dart';

class ViewModel extends ChangeNotifier {
  // Estados privados
  bool _loading = false;
  bool _error = false;
  List<Exam>? _examList;
  PageInfo? _pageInfo;

  // Dependencias
  late GqlConn _gqlConn;
  late ReadExamUsecase _readUseCase;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetExamsQuery _operation = GetExamsQuery(
    builder: EdgeExamFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<Exam>? get examList => _examList;
  PageInfo? get pageInfo => _pageInfo;

  // Setters con notificación
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set examList(List<Exam>? value) {
    _examList = value;
    notifyListeners();
  }

  set pageInfo(PageInfo? value) {
    _pageInfo = value;
    notifyListeners();
  }

  // Constructor - Inicializa dependencias
  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _readUseCase = ReadExamUsecase(operation: _operation, conn: _gqlConn);
    _init();
  }

  // Inicialización - Carga datos al crear el ViewModel
  Future<void> _init() async {
    await getExams();
  }

  // Obtener todos los exámenes (sin filtros)
  Future<void> getExams() async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.build();

      if (response is EdgeExam) {
        examList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getExams: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      examList = [];
      
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al cargar exámenes: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  // Buscar exámenes con filtros
  Future<void> search(List<SearchInput> searchInputs) async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.search(searchInputs, _pageInfo);

      if (response is EdgeExam) {
        examList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      examList = [];
      
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al buscar exámenes: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  // Cambiar de página
  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]);
  }
}
