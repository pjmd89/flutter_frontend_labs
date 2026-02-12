import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';

class MembershipItem extends StatelessWidget {
  final LabMembershipInfo membership;
  final AppLocalizations l10n;
  final Function(LabMembershipInfo membership)? onUpdate;
  final Function(String id)? onDelete;
  final Function(String id)? onViewLabs;
  final bool isRootView;

  const MembershipItem({
    super.key,
    required this.membership,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
    this.onViewLabs,
    this.isRootView = false,
  });

  String _getRoleTranslation(LabMemberRole? role) {
    if (role == null) return l10n.roleUnknown;
    
    switch (role) {
      case LabMemberRole.oWNER:
        return l10n.roleOwner;
      case LabMemberRole.tECHNICIAN:
        return l10n.roleTechnician;
      case LabMemberRole.bILLING:
        return l10n.roleBilling;
      case LabMemberRole.bIOANALYST:
        return l10n.roleBioanalyst;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullName = membership.member != null 
        ? '${membership.member!.firstName} ${membership.member!.lastName}'.trim()
        : 'Sin miembro';
    final roleText = _getRoleTranslation(membership.role);
    
    // Obtener el rol del usuario logueado
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final userRole = loggedUser?.labRole;
    final shouldHideMenu = userRole == LabMemberRole.bILLING || 
                          userRole == LabMemberRole.bIOANALYST;

    // Diseño para ROOT/ADMIN (similar a UserItem)
    if (isRootView) {
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
                            debugPrint('\n📤 ========== NAVEGANDO A UPDATE (MembershipItem ROOT) ==========');
                            debugPrint('📤 membership.id: "${membership.id}"');
                            debugPrint('📤 membership.member.id: "${membership.member?.id}"');
                            debugPrint('📤 Nombre: ${membership.member?.firstName} ${membership.member?.lastName}');
                            debugPrint('📤 Pasando objeto LabMembershipInfo completo');
                            debugPrint('========================================\n');
                            onUpdate!(membership);
                          }
                        },
                        itemBuilder: (context) => [
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (membership.laboratory != null)
                      Expanded(
                        child: Text(
                          '${l10n.laboratory}: ${membership.laboratory!.address}',
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (onViewLabs != null && membership.member != null)
                      OutlinedButton(
                        onPressed: () => onViewLabs!(membership.member!.id),
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

    // Diseño original para usuarios normales
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.group_outlined)),
              title: Text(
                membership.member != null 
                    ? '${membership.member!.firstName} ${membership.member!.lastName}'
                    : 'Sin miembro'
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (membership.laboratory != null)
                    Text('Lab: ${membership.laboratory!.address}'),
                  if (membership.role != null)
                    Text('${l10n.role}: ${_getRoleTranslation(membership.role)}'),
                ],
              ),
              trailing: shouldHideMenu
                  ? null // Ocultar el menú si es billing o bioanalista
                  : PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit' && onUpdate != null) {
                          debugPrint('\n📤 ========== NAVEGANDO A UPDATE (MembershipItem) ==========');
                          debugPrint('📤 membership.id: "${membership.id}"');
                          debugPrint('📤 membership.member.id: "${membership.member?.id}"');
                          debugPrint('📤 Nombre: ${membership.member?.firstName} ${membership.member?.lastName}');
                          debugPrint('📤 Pasando objeto LabMembershipInfo completo');
                          debugPrint('========================================\n');
                          onUpdate!(membership);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(l10n.edit),
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
