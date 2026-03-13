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

  Color _getAvatarColor(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
    ];
    return colors[index % colors.length];
  }

  String _getInitials(String firstName, String lastName) {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  @override
  Widget build(BuildContext context) {
    final fullName = '${user.firstName} ${user.lastName}'.trim();
    final roleText = _getRoleText();
    final initials = _getInitials(user.firstName, user.lastName);
    final avatarColor = _getAvatarColor(context, user.id.hashCode);
    
    // Obtener el rol del usuario logueado
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final isBilling = loggedUser?.labRole == LabMemberRole.bILLING;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Usuario con avatar
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: avatarColor.withOpacity(0.1),
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: avatarColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Rol
          Expanded(
            flex: 2,
            child: Text(
              roleText,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          
          // Laboratorio / Fecha (placeholder)
          const Expanded(
            flex: 2,
            child: Text(
              "Lab General",
              style: TextStyle(fontSize: 14),
            ),
          ),
          
          // Acciones
          Expanded(
            flex: 1,
            child: isBilling
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (onUpdate != null) {
                            debugPrint('\n📤 ========== NAVEGANDO A UPDATE (UserItem) ==========');
                            debugPrint('📤 user.id: "${user.id}"');
                            debugPrint('📤 user.firstName: ${user.firstName}');
                            debugPrint('📤 user.lastName: ${user.lastName}');
                            debugPrint('📤 Pasando objeto User completo');
                            debugPrint('========================================\n');
                            onUpdate!(user);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
