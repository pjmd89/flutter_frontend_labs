import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './membership_item.dart';
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

  // Usuario ROOT: mostrar lista de usuarios
  if (viewModel.isRootUser) {
    // Estado: Sin datos
    if (viewModel.userList == null || viewModel.userList!.isEmpty) {
      return [Center(child: Text(l10n.noRegisteredMaleThings(l10n.users)))];
    }

    // Estado: Con datos - mapea cada user a UserItem
    return viewModel.userList!.map((user) {
      return UserItem(
        user: user,
        l10n: l10n,
        onUpdate: (id) async {
          final result = await context.push('/user/update/$id');
          if (result == true) {
            viewModel.getMemberships();
          }
        },
        onViewLabs: (id) async {
          await context.push('/user/$id/laboratories');
        },
      );
    }).toList();
  }

  // Otros usuarios: mostrar lista de membresías
  // Estado: Sin datos
  if (viewModel.membershipList == null || viewModel.membershipList!.isEmpty) {
    return [Center(child: Text(l10n.noRegisteredFemaleThings('Membresías')))];
  }

  // Estado: Con datos - mapea cada membership a MembershipItem
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
    );
  }).toList();
}
