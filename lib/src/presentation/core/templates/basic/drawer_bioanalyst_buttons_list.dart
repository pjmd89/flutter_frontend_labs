import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/drawer_config.dart';


List<DrawerButtonConfig> getBioanalystDrawerButtonList(
  BuildContext context,
  String currentPath,
) {
  final l10n = AppLocalizations.of(context)!;
  return [
    //DrawerButtonConfig(
    //  buttonText: l10n.dashboard,
    //  buttonRoute: "/dashboard",
    //  currentPath: currentPath,
    //  leadingIcon: const Icon(Icons.dashboard),
    //),
    //DrawerButtonConfig(
    //  buttonText: l10n.patients,
    //  buttonRoute: "/patient",
    //  currentPath: currentPath,
    //  leadingIcon: const Icon(Icons.people),
    //),
    DrawerButtonConfig(
      buttonText: l10n.evaluationPackages,
      buttonRoute: "/evaluationpackage",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.inventory_2),
    ),
    //DrawerButtonConfig(
    //  buttonText: l10n.laboratories,
    //  buttonRoute: "/laboratory",
    //  currentPath: currentPath,
    //  leadingIcon: const Icon(Icons.science),
    //),
  ];
}
