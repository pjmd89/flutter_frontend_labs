import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class UserItem extends StatelessWidget {
  final User user;
  final AppLocalizations l10n;
  final Function(String id)? onViewLabs;
  final Function(String id)? onViewBilling;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const UserItem({
    super.key,
    required this.user,
    required this.l10n,
    this.onViewLabs,
    this.onViewBilling,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullName = '${user.firstName} ${user.lastName}'.trim();
    final roleText = user.role?.toString().split('.').last ?? 'Sin rol';

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
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit' && onUpdate != null) {
                    onUpdate!(user.id);
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!(user.id);
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
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete),
                            const SizedBox(width: 8),
                            Text(l10n.delete),
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
                  if (onViewLabs != null) const SizedBox(width: 8),
                  if (onViewBilling != null)
                    FilledButton(
                      onPressed: () => onViewBilling!(user.id),
                      child: Text(l10n.viewBilling),
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
