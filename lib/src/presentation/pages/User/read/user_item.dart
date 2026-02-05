import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';

class UserItem extends StatelessWidget {
  final User user;
  final AppLocalizations l10n;
  final Function(String id)? onViewLabs;
  final Function(User user)? onUpdate;
  final Function(String id)? onDelete;

  const UserItem({
    super.key,
    required this.user,
    required this.l10n,
    this.onViewLabs,
    this.onUpdate,
    this.onDelete,
  });

  String _getRoleText() {
    if (user.role == null) return l10n.roleUnknown;
    
    switch (user.role!) {
      case Role.rOOT:
        return l10n.roleRoot;
      case Role.aDMIN:
        return l10n.roleAdmin;
      case Role.uSER:
        return l10n.roleUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullName = '${user.firstName} ${user.lastName}'.trim();
    final roleText = _getRoleText();
    
    // Obtener el rol del usuario logueado
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final userRole = loggedUser?.labRole;
    final shouldHideMenu = userRole == LabMemberRole.bILLING || 
                          userRole == LabMemberRole.bIOANALYST;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360, maxHeight: 150),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text(fullName, style: theme.textTheme.titleMedium),
              subtitle: Text(roleText),
              trailing: shouldHideMenu
                  ? null // Ocultar el menú si es billing o bioanalista
                  : PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'edit' && onUpdate != null) {
                          debugPrint('\n📤 ========== NAVEGANDO A UPDATE (UserItem) ==========');
                          debugPrint('📤 user.id: "${user.id}"');
                          debugPrint('📤 user.firstName: ${user.firstName}');
                          debugPrint('📤 user.lastName: ${user.lastName}');
                          debugPrint('📤 Pasando objeto User completo');
                          debugPrint('========================================\n');
                          onUpdate!(user);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  const Icon(Icons.edit),
                                  const SizedBox(width: 8),
                                  Text(l10n.edit),
                                ],
                              ),
                            ),
                          ],
                    ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onViewLabs != null)
                    OutlinedButton(
                      onPressed: () => onViewLabs!(user.id),
                      child: Text(l10n.viewLaboratories),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
