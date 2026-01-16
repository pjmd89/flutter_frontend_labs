import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './evaluation_package_item.dart';

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
  if (viewModel.evaluationPackageList == null ||
      viewModel.evaluationPackageList!.isEmpty) {
    return [
      Center(
        child: Text(l10n.noRegisteredMaleThings(l10n.evaluationPackages)),
      )
    ];
  }

  // Estado: Con datos - mapea cada item a su widget
  return viewModel.evaluationPackageList!.map((evaluationPackage) {
    return EvaluationPackageItem(
      evaluationPackage: evaluationPackage,
      l10n: l10n,
      onUpdate: (id) async {
        final result = await context.push('/evaluationpackage/update', extra: evaluationPackage);
        if (result == true) {
          viewModel.getEvaluationPackages();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/evaluationpackage/delete/$id');
        if (result == true) {
          viewModel.getEvaluationPackages();
        }
      },
    );
  }).toList();
}
