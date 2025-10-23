import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './user_item.dart';

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
  if (viewModel.userList == null || viewModel.userList!.isEmpty) {
    return [Center(child: Text(l10n.noRegisteredMaleThings(l10n.users)))];
  }

  // Estado: Con datos - mapea cada item a su widget
  return viewModel.userList!.map((user) {
    return UserItem(
      user: user,
      l10n: l10n,
      onUpdate: (id) async {
        final result = await context.push('/user/update/$id');
        if (result == true) {
          viewModel.getUsers();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/user/delete/$id');
        if (result == true) {
          viewModel.getUsers();
        }
      },
      onViewLabs: (id) {
        // TODO: Implementar navegación a laboratorios
        // context.push('/user/$id/laboratories');
      },
      onViewBilling: (id) {
        // TODO: Implementar navegación a facturación
        // context.push('/user/$id/billing');
      },
    );
  }).toList();
}
