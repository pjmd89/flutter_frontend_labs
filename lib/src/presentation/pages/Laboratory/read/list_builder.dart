import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './laboratory_item.dart';

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
  if (viewModel.laboratoryList == null || viewModel.laboratoryList!.isEmpty) {
    return [Center(child: Text(l10n.noRegisteredMaleThings('Laboratorios')))];
  }

  // Estado: Con datos - mapea cada item a su widget
  return viewModel.laboratoryList!.map((laboratory) {
    return LaboratoryItem(
      laboratory: laboratory,
      l10n: l10n,
      onUpdate: (id) async {
        final result = await context.push('/laboratory/update/$id');
        if (result == true) {
          viewModel.getLaboratory();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/laboratory/delete/$id');
        if (result == true) {
          viewModel.getLaboratory();
        }
      },
    );
  }).toList();
}
