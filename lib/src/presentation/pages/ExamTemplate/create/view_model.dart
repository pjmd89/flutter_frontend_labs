import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createExamTemplate/createexamtemplate_mutation.dart';
import '/src/domain/usecases/ExamTemplate/create_examtemplate_usecase.dart';
import '/src/domain/extensions/examtemplate_fields_builder_extension.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;

  final CreateExamTemplateInput input = CreateExamTemplateInput(
    name: '',
    description: '',
    indicators: [],
  );

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
  }

  Future<bool> create() async {
    bool isError = true;
    loading = true;

    CreateExamTemplateUsecase useCase = CreateExamTemplateUsecase(
      operation: CreateExamTemplateMutation(
        builder: ExamTemplateFieldsBuilder().defaultValues(),
      ),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute(input: input);

      if (response is ExamTemplate) {
        isError = false;
      } else {
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en create: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;

      // Mostrar error al usuario
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al crear plantilla de examen: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
