import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/drawer_config.dart';


List<DrawerButtonConfig> getTechnicianDrawerButtonList(
  BuildContext context,
  String currentPath,
) {
  final l10n = AppLocalizations.of(context)!;
  return [
    DrawerButtonConfig(
      buttonText: l10n.exams,
      buttonRoute: "/exam",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.science),
    ),
    DrawerButtonConfig(
      buttonText: l10n.patients,
      buttonRoute: "/patient",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.people),
    ),
    DrawerButtonConfig(
      buttonText: l10n.evaluationPackages,
      buttonRoute: "/evaluationpackage",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.inventory_2),
    ),
    DrawerButtonConfig(
      buttonText: AppLocalizations.of(context)!.invoices,
      buttonRoute: "/invoice",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.receipt),
    ),
    
    // DrawerButtonConfig(
    //   buttonText: AppLocalizations.of(context)!.logout,
    //   buttonRoute: "/login",
    //   currentPath: currentPath,
    //   leadingIcon: const Icon(Icons.logout),
    //   callback: (BuildContext ctx) {
    //     ctx.read<FindNotifier>().setFind("");
    //     LocalStorage storage = LocalStorage('.loginData.json');
    //     Map<String,dynamic> currentJsonData = storage.getItem("login");
    //     LoginDataModel currentLoginData = LoginDataModel.fromJson(currentJsonData);
    //     currentLoginData.password = "";
    //     currentLoginData.cellPhone = "";
    //     String deviceID = currentLoginData.deviceID;
    //     if (!currentLoginData.rememberCredentials) {
    //       currentLoginData = LoginDataModel(
    //         cellPhone: "",
    //         password:"",
    //         deviceID: "",
    //         rememberCredentials: false,
    //         storedPass: "",
    //         storedPhone: ""
    //       );
    //     }
    //     storage.setItem("login",currentLoginData);
    //     conn.query(
    //       endSessionQuery,
    //       {"deviceID": deviceID},
    //       (p0) => null
    //     );
    //   }
    // )
  ];
}
