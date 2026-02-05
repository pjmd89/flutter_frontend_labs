import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/main.dart';

/// Diálogo para seleccionar un paciente de la lista
/// Permite buscar por nombre (funciona para humanos y animales)
class PatientSelectorDialog extends StatefulWidget {
  final List<Patient> patients;
  
  const PatientSelectorDialog({
    super.key,
    required this.patients,
  });

  @override
  State<PatientSelectorDialog> createState() => _PatientSelectorDialogState();
}

class _PatientSelectorDialogState extends State<PatientSelectorDialog> {
  final searchController = TextEditingController();
  List<Patient> filteredPatients = [];

  @override
  void initState() {
    super.initState();
    filteredPatients = widget.patients;
    searchController.addListener(_filterPatients);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterPatients);
    searchController.dispose();
    super.dispose();
  }

  void _filterPatients() {
    final query = searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        filteredPatients = widget.patients;
      } else {
        filteredPatients = widget.patients.where((patient) {
          // Buscar por nombre (funciona para humanos y animales)
          String firstName = '';
          String lastName = '';
          String dni = '';
          String species = '';
          
          if (patient.isPerson && patient.asPerson != null) {
            final person = patient.asPerson!;
            firstName = person.firstName.toLowerCase();
            lastName = person.lastName.toLowerCase();
            dni = person.dni.toLowerCase();
          } else if (patient.isAnimal && patient.asAnimal != null) {
            final animal = patient.asAnimal!;
            firstName = animal.firstName.toLowerCase();
            lastName = animal.lastName.toLowerCase();
            species = animal.species.toLowerCase();
          }
          
          final fullName = '$firstName $lastName';
          
          return fullName.contains(query) || 
                 dni.contains(query) || 
                 species.contains(query);
        }).toList();
      }
    });
  }

  String _getPatientName(Patient patient) {
    if (patient.isPerson && patient.asPerson != null) {
      final person = patient.asPerson!;
      return '${person.firstName} ${person.lastName}';
    } else if (patient.isAnimal && patient.asAnimal != null) {
      final animal = patient.asAnimal!;
      return '${animal.firstName} ${animal.lastName}';
    }
    return 'Paciente ${patient.id}';
  }
  
  String _getPatientInfo(Patient patient, AppLocalizations l10n) {
    if (patient.isPerson && patient.asPerson != null) {
      final person = patient.asPerson!;
      return '${l10n.dni}: ${person.dni}';
    } else if (patient.isAnimal && patient.asAnimal != null) {
      final animal = patient.asAnimal!;
      return '${l10n.species}: ${animal.species}';
    }
    
    if (patient.patientType != null) {
      switch (patient.patientType!) {
        case PatientType.hUMAN:
          return l10n.patientTypeHuman;
        case PatientType.aNIMAL:
          return l10n.patientTypeAnimal;
      }
    }
    
    return '';
  }

  IconData _getPatientIcon(Patient patient) {
    if (patient.isPerson) {
      return Icons.person;
    } else if (patient.isAnimal) {
      return Icons.pets;
    }
    return Icons.help_outline;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Dialog(
      child: Container(
        width: 600,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Row(
              children: [
                const Icon(Icons.person_search, size: 28),
                const SizedBox(width: 12),
                Text(
                  l10n.selectPatient,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Campo de búsqueda
            CustomTextFormField(
              labelText: l10n.searchByName,
              controller: searchController,
              isDense: true,
              prefixIcon: const Icon(Icons.search),
              counterText: "",
              fieldLength: FormFieldLength.password,
            ),
            const SizedBox(height: 16),
            
            // Contador de resultados
            Text(
              '${filteredPatients.length} ${filteredPatients.length == 1 ? l10n.patient : l10n.patients}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            
            const Divider(height: 1),
            const SizedBox(height: 12),
            
            // Lista de pacientes
            Expanded(
              child: filteredPatients.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            l10n.patientNotFound,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(_getPatientIcon(patient)),
                            ),
                            title: Text(_getPatientName(patient)),
                            subtitle: Text(_getPatientInfo(patient, l10n)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.of(context).pop(patient);
                            },
                          ),
                        );
                      },
                    ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón de cancelar
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(l10n.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
