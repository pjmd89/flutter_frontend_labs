import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:intl/intl.dart';

class LaboratoryItem extends StatelessWidget {
  final Laboratory laboratory;
  final AppLocalizations l10n;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;
  final Function(String id)? onViewBilling;

  const LaboratoryItem({
    super.key,
    required this.laboratory,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
    this.onViewBilling,
  });

  String _getContactName() {
    final owner = laboratory.company?.owner;
    if (owner != null) {
      final fullName = '${owner.firstName} ${owner.lastName}'.trim();
      return fullName.isNotEmpty ? fullName : 'Sin contacto';
    }
    return 'Sin contacto';
  }

  String _getContactPhone() {
    if (laboratory.contactPhoneNumbers.isNotEmpty) {
      return laboratory.contactPhoneNumbers.first;
    }
    return 'Sin teléfono';
  }

  String _getFormattedDate() {
    try {
      if (laboratory.created == 0) return 'Sin fecha';
      
      // created es un timestamp Unix (int)
      final date = DateTime.fromMillisecondsSinceEpoch(laboratory.created * 1000);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Sin fecha';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit' && onUpdate != null) {
                        onUpdate!(laboratory.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Nombre de contacto
              Text(
                _getContactName(),
                style: const TextStyle(
                  fontSize: 14,
                  
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Dirección del laboratorio
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      laboratory.address.isNotEmpty 
                        ? laboratory.address 
                        : 'Sin dirección',
                      style: const TextStyle(
                        fontSize: 16,
                        
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),

              // Fila Inferior: Teléfono, Fecha y Botón
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Teléfono y Fecha
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getContactPhone(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getFormattedDate(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Botón "Ver facturación"
                  if (onViewBilling != null)
                    FilledButton(
                      onPressed: () => onViewBilling!(laboratory.id),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: Text(
                        l10n.viewBilling,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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