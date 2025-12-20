import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class LaboratoryItem extends StatelessWidget {
  final Laboratory laboratory;
  final AppLocalizations l10n;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const LaboratoryItem({
    super.key,
    required this.laboratory,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
   

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        // Color oscuro similar al de la imagen
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fila Superior: Título y Menú
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      laboratory.company?.name ?? 'Sin nombre',              
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit' && onUpdate != null) {
                        onUpdate!(laboratory.id);
                      } else if (value == 'delete' && onDelete != null) {
                        onDelete!(laboratory.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                      PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                    ],
                  ),
                ],
              ),
              
              // Subtítulo (Nombre de contacto/persona)
              Text(
                'Jaime Reyes', // Reemplazar con el campo real si existe, ej: laboratory.contactName
              
              ),
              
              const SizedBox(height: 16),

              // Fila Inferior: Monto, Fecha y Botón
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Monto y Fecha
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '12.000,00', // Reemplazar con laboratory.amount si aplica
                        
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '09/10/2025', // Reemplazar con laboratory.date
                       
                      ),
                    ],
                  ),
                  
                  // Botón "Ver facturación"
                  ElevatedButton(
                    onPressed: () {
                      // Acción para ver facturación
                    },
                    style: ElevatedButton.styleFrom(                 // Texto oscuro
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text(
                      'Ver facturación',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}