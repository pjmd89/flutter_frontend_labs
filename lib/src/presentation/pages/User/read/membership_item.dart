import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';

class MembershipItem extends StatelessWidget {
  final LabMembershipInfo membership;
  final AppLocalizations l10n;
  final Function(User user)? onUpdate;
  final Function(String id)? onDelete;

  const MembershipItem({
    super.key,
    required this.membership,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
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
    // Obtener el rol del usuario logueado
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final isBilling = loggedUser?.labRole == LabMemberRole.bILLING;

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
              trailing: isBilling
                  ? null // Ocultar el menú si es billing
                  : PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit' && onUpdate != null && membership.member != null) {
                          debugPrint('\n📤 ========== NAVEGANDO A UPDATE (MembershipItem) ==========');
                          debugPrint('📤 membership.id: "${membership.id}"');
                          debugPrint('📤 membership.member.id: "${membership.member!.id}"');
                          debugPrint('📤 Nombre: ${membership.member!.firstName} ${membership.member!.lastName}');
                          debugPrint('📤 Pasando objeto User completo');
                          debugPrint('========================================\n');
                          onUpdate!(membership.member!);  // ✅ Pasar objeto User completo
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
