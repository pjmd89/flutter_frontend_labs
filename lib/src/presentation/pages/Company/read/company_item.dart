import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/infraestructure/config/env.dart';
import 'package:intl/intl.dart';

class CompanyItem extends StatefulWidget {
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

  @override
  State<CompanyItem> createState() => _CompanyItemState();
}

class _CompanyItemState extends State<CompanyItem> {
  bool _isHovered = false;

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

  String get _formattedDate {
    try {
      if (widget.company.created == 0) return '—';
      final date =
          DateTime.fromMillisecondsSinceEpoch(widget.company.created * 1000);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String? logoUrl = widget.company.logo.isNotEmpty 
        ? _buildLogoUrl(widget.company.logo) 
        : null;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered
              ? colorScheme.surfaceContainerHighest.withOpacity(0.35)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: colorScheme.onSurface.withOpacity(0.08),
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            // Col 1: Company name with logo
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: logoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              logoUrl,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.business_outlined,
                                  color: colorScheme.onPrimaryContainer,
                                  size: 18,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.business_outlined,
                            color: colorScheme.onPrimaryContainer,
                            size: 18,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.company.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Col 2: Tax ID
            Expanded(
              flex: 2,
              child: Text(
                widget.company.taxID,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // Col 3: Owner
            Expanded(
              flex: 3,
              child: Text(
                widget.company.owner != null
                    ? '${widget.company.owner!.firstName} ${widget.company.owner!.lastName}'.trim()
                    : '—',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Col 4: Creation date
            Expanded(
              flex: 2,
              child: Text(
                _formattedDate,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // Col 6: Actions
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.onUpdate != null)
                          _ActionButton(
                            icon: Icons.edit_outlined,
                            color: colorScheme.primary,
                            hoverBg: colorScheme.primary.withOpacity(0.1),
                            tooltip: widget.l10n.edit,
                            onTap: () => widget.onUpdate!(widget.company.id),
                          ),
                      ],
                    ),
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

// ── Action button ────────────────────────────────────────────────────

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final Color hoverBg;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.hoverBg,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Tooltip(
        message: widget.tooltip,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _isHovered ? widget.hoverBg : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                widget.icon,
                size: 18,
                color: widget.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
