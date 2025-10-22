import 'package:flutter/material.dart';
//import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/drawer_config.dart';


List<DrawerButtonConfig> getOwnerDrawerButtonList(
  BuildContext context,
  String currentPath,
) {
  //final l10n = AppLocalizations.of(context)!;
  return [
    DrawerButtonConfig(
      buttonText: "hola", //l10n.user,
      buttonRoute: "/user",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.person),
    ),
    DrawerButtonConfig(
      buttonText: "hola", //l10n.user,
      buttonRoute: "/destinationoffice",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.business),
    ),
    DrawerButtonConfig(
      buttonText: "hola", //l10n.user,
      buttonRoute: "/regulatedproduct",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.gavel),
    ),
    DrawerButtonConfig(
      buttonText: "hola", //l10n.user,
      buttonRoute: "/service",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.settings),
    ),
    DrawerButtonConfig(
      buttonText: "hola", //l10n.user,
      buttonRoute: "/clientpackage",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.inventory_2), // icono de caja embalada
    ),
    DrawerButtonConfig(
      buttonText: "hola", //l10n.user,
      buttonRoute: "/pallette",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.palette),
    ),
    DrawerButtonConfig(
      buttonText: "hola", //l10n.user,
      buttonRoute: "/shipment",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.directions_boat),
    ),
    DrawerButtonConfig(
      buttonText: "hola", //l10n.user,
      buttonRoute: "/typeaccess",
      currentPath: currentPath,
      leadingIcon: const Icon(Icons.vpn_key),
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
