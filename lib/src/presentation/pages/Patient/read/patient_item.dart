import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

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

    // Obtener datos del paciente según su tipo
    String patientName = '';
    String patientInfo = '';
    
    if (patient.isPerson && patient.asPerson != null) {
      final person = patient.asPerson!;
      patientName = '${person.firstName} ${person.lastName}';
      patientInfo = '${l10n.dni}: ${person.dni}';
    } else if (patient.isAnimal && patient.asAnimal != null) {
      final animal = patient.asAnimal!;
      patientName = '${animal.firstName} ${animal.lastName}';
      patientInfo = animal.species;
    } else {
      patientName = '${l10n.patient} ${patient.id}';
      patientInfo = _getPatientTypeLabel();
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text(patientName),
          subtitle: Text(patientInfo),
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
  
  String _getPatientTypeLabel() {
    if (patient.patientType == null) return '';
    
    switch (patient.patientType!) {
      case PatientType.hUMAN:
        return l10n.patientTypeHuman;
      case PatientType.aNIMAL:
        return l10n.patientTypeAnimal;
    }
  }
}
