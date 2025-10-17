import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/widgets/loading/main.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_buttons_list.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/main.dart';

class BasicTemplate extends StatelessWidget {
  const BasicTemplate({super.key, required this.child, this.title = "GPS Agile"});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    String fullPath = GoRouterState.of(context).fullPath ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
      ),
      drawer: CustomDrawer(
        drawerButtonConfigList: getUserDrawerButtonList(context,fullPath)
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          const Expanded(
            flex: 0,
            child: Loading()
          ),
          Expanded(
            flex: 1,
            child: child
          )
        ],
      ),
    );
  }
}