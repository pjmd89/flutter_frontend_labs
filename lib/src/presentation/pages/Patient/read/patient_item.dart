import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text('${patient.firstName} ${patient.lastName}'),
          subtitle: Text('${l10n.dni}: ${patient.dni}'),
          trailing: PopupMenuButton<String>(
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
