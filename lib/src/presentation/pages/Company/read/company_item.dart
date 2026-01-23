import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/infraestructure/config/env.dart';

class CompanyItem extends StatelessWidget {
  final Company company;
  final AppLocalizations l10n;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const CompanyItem({
    super.key,
    required this.company,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
  });

  /// Construye la URL completa del logo
  String _buildLogoUrl(String logoPath) {
    // Si ya es una URL completa, retornarla tal cual
    if (logoPath.startsWith('http://') || logoPath.startsWith('https://')) {
      return logoPath;
    }
    
    // Obtener URL base del servidor y remover /graphql si existe
    String baseUrl = Environment.backendApiUrl.replaceAll('/graphql', '');
    
    // Agregar prefijo /files/ a la ruta relativa
    // Backend devuelve: companies/logos/archivo.jpeg
    // URL correcta: https://localhost:8443/files/companies/logos/archivo.jpeg
    return '$baseUrl/files/$logoPath';
  }

  @override
  Widget build(BuildContext context) {
    // Construir URL completa del logo
    final String? logoUrl = company.logo.isNotEmpty ? _buildLogoUrl(company.logo) : null;
    
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: logoUrl != null
                ? ClipOval(
                    child: Image.network(
                      logoUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('❌ Error cargando logo de ${company.name}: $error');
                        return Icon(
                          Icons.business_outlined,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.business_outlined,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
          ),
          title: Text(company.name),
          subtitle: Text('${l10n.taxID}: ${company.taxID}'),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit' && onUpdate != null) {
                onUpdate!(company.id);
              } else if (value == 'delete' && onDelete != null) {
                onDelete!(company.id);
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                  PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                ],
          ),
        ),
      ),
    );
  }
}
