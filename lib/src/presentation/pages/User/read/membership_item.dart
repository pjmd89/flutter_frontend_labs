import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';

class MembershipItem extends StatelessWidget {
  final LabMembershipInfo membership;
  final AppLocalizations l10n;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const MembershipItem({
    super.key,
    required this.membership,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
  });

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
                    Text('Rol: ${membership.role}'),
                ],
              ),
              trailing: isBilling
                  ? null // Ocultar el menú si es billing
                  : PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit' && onUpdate != null) {
                          onUpdate!(membership.id);
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
