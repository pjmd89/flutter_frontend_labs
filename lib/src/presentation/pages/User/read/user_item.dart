import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/entities/enums/labmemberrole_enum.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';

class UserItem extends StatelessWidget {
  final User user;
  final AppLocalizations l10n;
  final Function(String id)? onViewLabs;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const UserItem({
    super.key,
    required this.user,
    required this.l10n,
    this.onViewLabs,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullName = '${user.firstName} ${user.lastName}'.trim();
    final roleText = user.role?.toString().split('.').last ?? 'Sin rol';
    
    // Obtener el rol del usuario logueado
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final isBilling = loggedUser?.labRole == LabMemberRole.bILLING;

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
              trailing: isBilling
                  ? null // Ocultar el menú si es billing
                  : PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'edit' && onUpdate != null) {
                          onUpdate!(user.id);
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
