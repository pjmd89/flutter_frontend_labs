import 'package:flutter/material.dart';
//import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/drawer_config.dart';


List<DrawerButtonConfig> getRootDrawerButtonList(
  BuildContext context,
  String currentPath,
) {
  //final l10n = AppLocalizations.of(context)!;
  return [
    DrawerButtonConfig(
      buttonText: "Dashboard",
      buttonRoute: "/home",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.dashboard),
    ),
    DrawerButtonConfig(
      buttonText: "Empresas",
      buttonRoute: "/company",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.business),
    ),
    DrawerButtonConfig(
      buttonText: "Laboratorios",
      buttonRoute: "/laboratory",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.science),
    ),
    DrawerButtonConfig(
      buttonText: "Usuarios",
      buttonRoute: "/user",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.person),
    ),
    DrawerButtonConfig(
      buttonText: "Lista de Exámenes",
      buttonRoute: "/examtemplate",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.assignment), // icono de caja embalada
    ),
    DrawerButtonConfig(
      buttonText: "Pacientes",
      buttonRoute: "/patient",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.people),
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
