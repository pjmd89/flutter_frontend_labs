import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';

class MembershipItem extends StatelessWidget {
  final LabMembershipInfo membership;
  final AppLocalizations l10n;
  final Function(User user)? onUpdate;
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

  Color _getAvatarColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.pink,
      Colors.orange,
      Colors.teal,
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
    if (membership.member == null) {
      return const SizedBox.shrink();
    }

    final fullName = '${membership.member!.firstName} ${membership.member!.lastName}'.trim();
    final roleText = _getRoleTranslation(membership.role);
    final initials = _getInitials(membership.member!.firstName, membership.member!.lastName);
    final avatarColor = _getAvatarColor(membership.member!.id.hashCode);
    final labName = membership.laboratory?.address ?? 'N/A';
    
    // Obtener el rol del usuario logueado
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final isBilling = loggedUser?.labRole == LabMemberRole.bILLING;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
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
                        membership.member!.email,
                        style: const TextStyle(
                          color: Colors.grey,
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
          
          // Laboratorio
          Expanded(
            flex: 2,
            child: Text(
              labName,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Estado
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Activo",
                  style: TextStyle(fontSize: 12),
                ),
              ],
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
                            debugPrint('\n📤 ========== NAVEGANDO A UPDATE (MembershipItem) ==========');
                            debugPrint('📤 membership.id: "${membership.id}"');
                            debugPrint('📤 membership.member.id: "${membership.member!.id}"');
                            debugPrint('📤 Nombre: ${fullName}');
                            debugPrint('📤 Pasando objeto User completo');
                            debugPrint('========================================\n');
                            onUpdate!(membership.member!);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          if (onDelete != null) {
                            onDelete!(membership.member!.id);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.redAccent,
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
