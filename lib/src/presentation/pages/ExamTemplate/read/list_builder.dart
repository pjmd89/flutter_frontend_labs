import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './examtemplate_item.dart';

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
    return [Center(child: Text(l10n.errorLoadingData))];
  }

  // Estado: Sin datos
  if (viewModel.examTemplateList == null ||
      viewModel.examTemplateList!.isEmpty) {
    return [
      Center(child: Text(l10n.noRegisteredFemaleThings(l10n.examTemplates))),
    ];
  }

  // Estado: Con datos - mapea cada item a su widget
  return viewModel.examTemplateList!.map((examTemplate) {
    return ExamTemplateItem(
      examTemplate: examTemplate,
      l10n: l10n,
      onUpdate: (id) async {
        final result = await context.push('/examtemplate/update/$id');
        if (result == true) {
          viewModel.getExamTemplates();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/examtemplate/delete/$id');
        if (result == true) {
          viewModel.getExamTemplates();
        }
      },
    );
  }).toList();
}
