import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/entities/enums/labmemberrole_enum.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';

class PatientItem extends StatelessWidget {
  final Patient patient;
  final AppLocalizations l10n;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const PatientItem({
    super.key,
    required this.patient,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener el rol del usuario logueado
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final isTechnician = loggedUser?.labRole == LabMemberRole.tECHNICIAN;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text('${patient.firstName} ${patient.lastName}'),
          subtitle: Text('${l10n.dni}: ${patient.dni ?? "-"}'),
          trailing: isTechnician 
              ? null // Ocultar el menú si es technician
              : PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit' && onUpdate != null) {
                      onUpdate!(patient.id);
                    } else if (value == 'delete' && onDelete != null) {
                      onDelete!(patient.id);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                    PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                  ],
                ),
        ),
      ),
    );
  }
}
