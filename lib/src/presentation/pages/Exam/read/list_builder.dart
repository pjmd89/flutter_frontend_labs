import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './exam_item.dart';

List<Widget> buildList({
  required BuildContext context,
  required ViewModel viewModel,
  required AppLocalizations l10n,
}) {
  // Estado: Cargando
  if (viewModel.loading) {
    return [const Center(child: CircularProgressIndicator())];
  }

  // Estado: Error
  if (viewModel.error) {
    return [
      Center(
        child: Text(l10n.errorLoadingData),
      )
    ];
  }

  // Estado: Sin datos
  if (viewModel.examList == null || viewModel.examList!.isEmpty) {
    return [
      Center(
        child: Text(l10n.noRegisteredMaleThings(l10n.exams)),
      )
    ];
  }

  // Estado: Con datos - mapea cada item a su widget
  return viewModel.examList!.map((exam) {
    return ExamItem(
      exam: exam,
      l10n: l10n,
      onUpdate: (id) async {
        final result = await context.push('/exam/update/$id');
        if (result == true) {
          viewModel.getExams();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/exam/delete/$id');
        if (result == true) {
          viewModel.getExams();
        }
      },
    );
  }).toList();
}
