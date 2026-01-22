import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getEvaluationPackage/getevaluationpackage_query.dart';
import '/src/domain/extensions/edgeevaluationpackage_fields_builder_extension.dart';
import '/src/domain/usecases/EvaluationPackage/readone_evaluationpackage_usecase.dart';

class ViewModel extends ChangeNotifier {
  // Estados privados
  bool _loading = false;
  bool _error = false;
  EvaluationPackage? _evaluationPackage;

  // Dependencias
  late GqlConn _gqlConn;
  late ReadOneEvaluationPackageUsecase _readUseCase;
  final BuildContext _context;
  final String _id;

  // Query con FieldsBuilder configurado
  final GetEvaluationPackageQuery _operation = GetEvaluationPackageQuery(
    builder: EdgeEvaluationPackageFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  EvaluationPackage? get evaluationPackage => _evaluationPackage;

  // Setters con notificación
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set evaluationPackage(EvaluationPackage? value) {
    _evaluationPackage = value;
    notifyListeners();
  }

  // Constructor - Inicializa dependencias
  ViewModel({required BuildContext context, required String id}) 
      : _context = context, 
        _id = id {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _readUseCase = ReadOneEvaluationPackageUsecase(
      operation: _operation,
      conn: _gqlConn,
    );
    _init();
  }

  // Inicialización - Carga datos al crear el ViewModel
  Future<void> _init() async {
    await getEvaluationPackage();
  }

  // Obtener el evaluation package por ID
  Future<void> getEvaluationPackage() async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.readOne(_id);

      if (response is EdgeEvaluationPackage) {
        if (response.edges.isNotEmpty) {
          evaluationPackage = response.edges.first;
        } else {
          error = true;
        }
      } else {
        error = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getEvaluationPackage: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      
      // Mostrar error al usuario
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al cargar paquete de evaluación: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }
}
