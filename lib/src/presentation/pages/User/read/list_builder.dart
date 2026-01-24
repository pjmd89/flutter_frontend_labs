import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './membership_item.dart';

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
  if (viewModel.membershipList == null || viewModel.membershipList!.isEmpty) {
    return [Center(child: Text(l10n.noRegisteredFemaleThings('Membresías')))];
  }

  // Estado: Con datos - mapea cada item a su widget
  return viewModel.membershipList!.map((membership) {
    return MembershipItem(
      membership: membership,
      l10n: l10n,
      onUpdate: (id) async {
        final result = await context.push('/membership/update/$id');
        if (result == true) {
          viewModel.getMemberships();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/membership/delete/$id');
        if (result == true) {
          viewModel.getMemberships();
        }
      },
    );
  }).toList();
}
