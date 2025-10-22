import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/domain/entities/enums/role_enum.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_billing_buttons_list.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_header_buttons_list.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_owner_buttons_list.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_root_buttons_list.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_technician_buttons_list.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/drawer_config.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import '/src/presentation/widgets/loading/main.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/main.dart';


class BasicTemplate extends StatelessWidget {
  const BasicTemplate({super.key, required this.child, this.title = "Labs"});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();
    String fullPath = GoRouterState.of(context).fullPath ?? "";
    List<DrawerButtonConfig> drawerButtonConfigList = [];
    switch (authNotifier.role) {
      case Role.owner:
        drawerButtonConfigList = getOwnerDrawerButtonList(context, fullPath);
        break;
      case Role.billing:
        drawerButtonConfigList = getBillingDrawerButtonList(context, fullPath);
        break;
      case Role.technician:
        drawerButtonConfigList = getTechnicianDrawerButtonList(context, fullPath);
        break;
      case Role.root:
        drawerButtonConfigList = getRootDrawerButtonList(context, fullPath);
        break;
      default:
        fullPath = "/login";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
      ),
      drawer: CustomDrawer(
        drawerHeader: buildDrawerHeader(),
        drawerButtonConfigList: drawerButtonConfigList
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