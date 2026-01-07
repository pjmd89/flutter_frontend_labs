import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './patient_item.dart';

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
  if (viewModel.patientList == null || viewModel.patientList!.isEmpty) {
    return [Center(child: Text(l10n.noRegisteredMaleThings(l10n.patients)))];
  }

  // Estado: Con datos - mapea cada item a su widget
  return viewModel.patientList!.map((patient) {
    return PatientItem(
      patient: patient,
      l10n: l10n,
      onUpdate: (id) async {
        final result = await context.push('/patient/update/$id');
        if (result == true) {
          viewModel.getPatients();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/patient/delete/$id');
        if (result == true) {
          viewModel.getPatients();
        }
      },
    );
  }).toList();
}
