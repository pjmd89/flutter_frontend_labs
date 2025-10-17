import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/drawer_config.dart';

class CustomDrawerButton extends StatelessWidget {
  final DrawerButtonConfig drawerButtonConfig;
  const CustomDrawerButton({super.key, required this.drawerButtonConfig});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 45, left: 20),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        leading: drawerButtonConfig.leadingIcon,
        selected: drawerButtonConfig.isSelected,
        
        selectedTileColor: Theme.of(context).hoverColor  ,
        title: Text(drawerButtonConfig.buttonText),
        onTap: () {
          if (drawerButtonConfig.callback != null){
            drawerButtonConfig.callback!(context);
          }
          context.go(drawerButtonConfig.buttonRoute);
          Navigator.pop(context);
        },
      ),
    );
  }
}
