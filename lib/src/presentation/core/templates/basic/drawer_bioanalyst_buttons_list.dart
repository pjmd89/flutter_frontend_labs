import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/drawer_config.dart';


List<DrawerButtonConfig> getBioanalystDrawerButtonList(
  BuildContext context,
  String currentPath,
) {
  final l10n = AppLocalizations.of(context)!;
  return [
    DrawerButtonConfig(
      buttonText: AppLocalizations.of(context)!.users,
      buttonRoute: "/user",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.person),
    ),
    DrawerButtonConfig(
      buttonText: AppLocalizations.of(context)!.exam,
      buttonRoute: "/exam",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.assignment), // icono de caja embalada
    ),
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
