import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/domain/entities/enums/role_enum.dart';
import 'package:labs/src/domain/entities/enums/labmemberrole_enum.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_header_buttons_list.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_owner_buttons_list.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_root_buttons_list.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_technician_buttons_list.dart';
import 'package:labs/src/presentation/core/templates/basic/drawer_billing_buttons_list.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/drawer_config.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import '/src/presentation/widgets/loading/main.dart';
import 'package:labs/src/presentation/core/ui/custom_drawer/main.dart';
import 'package:labs/src/presentation/core/ui/user_menu/main.dart';
import 'package:labs/src/presentation/core/ui/laboratory_selector/main.dart';

class BasicTemplate extends StatelessWidget {
  const BasicTemplate({super.key, required this.child, this.title = "Labs"});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();
    final laboratoryNotifier = context.watch<LaboratoryNotifier>();
    String fullPath = GoRouterState.of(context).fullPath ?? "";
    List<DrawerButtonConfig> drawerButtonConfigList = [];
    switch (authNotifier.role) {
      case Role.rOOT:
        drawerButtonConfigList = getRootDrawerButtonList(context, fullPath);
        break;
      case Role.aDMIN:
        drawerButtonConfigList = getOwnerDrawerButtonList(context, fullPath);
        break;
      case Role.uSER:
        // Determinar drawer según labRole del laboratorio actual
        if (authNotifier.labRole != null) {
          switch (authNotifier.labRole!) {
            case LabMemberRole.oWNER:
              drawerButtonConfigList = getOwnerDrawerButtonList(context, fullPath);
              break;
            case LabMemberRole.tECHNICIAN:
            case LabMemberRole.bIOANALYST:
              drawerButtonConfigList = getTechnicianDrawerButtonList(context, fullPath);
              break;
            case LabMemberRole.bILLING:
              drawerButtonConfigList = getBillingDrawerButtonList(context, fullPath);
              break;
          }
        } else {
          // Si no tiene labRole, usar userIsLabOwner como fallback
          drawerButtonConfigList = authNotifier.userIsLabOwner
              ? getOwnerDrawerButtonList(context, fullPath)
              : getTechnicianDrawerButtonList(context, fullPath);
        }
        break;
      default:
        fullPath = "/login";
    }
    
    // Usar el nombre del laboratorio si está seleccionado, sino usar "Labs"
    final displayTitle = laboratoryNotifier.laboratoryName;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(displayTitle),
        centerTitle: false,
        actions: [
          // Botón para seleccionar laboratorio
          IconButton(
            icon: Icon(
              laboratoryNotifier.hasLaboratory
                  ? Icons.science
                  : Icons.science_outlined,
            ),
            tooltip: 'Seleccionar Laboratorio',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const LaboratorySelectorDialog(),
              );
            },
          ),
          const UserMenu(),
        ],
      ),
      drawer: CustomDrawer(
        drawerHeader: buildDrawerHeader(),
        drawerButtonConfigList: drawerButtonConfigList,
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          const Expanded(flex: 0, child: Loading()),
          Expanded(flex: 1, child: child),
        ],
      ),
    );
  }
}
