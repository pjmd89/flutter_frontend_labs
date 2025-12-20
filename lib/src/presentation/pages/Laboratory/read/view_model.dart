import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/laboratory_fields_builder.dart';
import 'package:labs/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import 'package:labs/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<Laboratory>? _laboratoryList; // Cambiado de User a Laboratory
  PageInfo? _pageInfo;

  late GqlConn _gqlConn;
  late ReadLaboratoryUsecase _readUseCase;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetLaboratoriesQuery _operation = GetLaboratoriesQuery(
    builder: EdgeLaboratoryFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<Laboratory>? get laboratoryList => _laboratoryList;
  PageInfo? get pageInfo => _pageInfo;

  // Setters privados
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set laboratoryList(List<Laboratory>? value) {
    _laboratoryList = value;
    notifyListeners();
  }

  set pageInfo(PageInfo? value) {
    _pageInfo = value;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _readUseCase = ReadLaboratoryUsecase(operation: _operation, conn: _gqlConn);
    _init();
  }

  Future<void> _init() async {
    await getLaboratory();
  }

  Future<void> getLaboratory() async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.build();

      if (response is EdgeLaboratory) {
        laboratoryList = response.edges; // Descomenta y usa laboratoryList
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getLaboratorios: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      laboratoryList = [];

      // Mostrar error al usuario
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al cargar laboratorios: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  Future<void> search(List<SearchInput> searchInputs) async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.search(searchInputs, _pageInfo);

      if (response is EdgeLaboratory) {
        laboratoryList = response.edges; // Cambiado de userList a laboratoryList
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search laboratories: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      laboratoryList = [];

      // Mostrar error al usuario
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al buscar laboratorios: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]); // Recargar con la nueva página
  }
}