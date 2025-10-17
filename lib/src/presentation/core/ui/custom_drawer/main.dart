import 'package:flutter/material.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/drawer_button.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/drawer_config.dart';

class CustomDrawer extends StatelessWidget {
  final Widget? drawerHeader;
  final List<DrawerButtonConfig> drawerButtonConfigList;
  
  const CustomDrawer({super.key, required this.drawerButtonConfigList, this.drawerHeader});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: setDrawerChildren(context),
      ),
    );
  }

  List<Widget> setDrawerChildren(BuildContext context) {
    
    List<Widget> list = [];
    if (drawerHeader!= null){
      list.add(drawerHeader!);
    }
    for(final i in drawerButtonConfigList){
      list.add(CustomDrawerButton(
        key: Key('drawer_button_${drawerButtonConfigList.indexOf(i)}'),
        drawerButtonConfig: i
      ));
    }
    return list;
  }
}
