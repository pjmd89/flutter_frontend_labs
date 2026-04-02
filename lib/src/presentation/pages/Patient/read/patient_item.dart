import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PatientItem extends StatefulWidget {
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
  State<PatientItem> createState() => _PatientItemState();
}

class _PatientItemState extends State<PatientItem> {
  bool _isHovered = false;

  // ── Helpers ──────────────────────────────────────────────────────────────

  bool get _isHuman => widget.patient.isPerson;

  String get _name {
    if (widget.patient.isPerson && widget.patient.asPerson != null) {
      final p = widget.patient.asPerson!;
      return '${p.firstName} ${p.lastName}'.trim();
    }
    if (widget.patient.isAnimal && widget.patient.asAnimal != null) {
      final a = widget.patient.asAnimal!;
      return '${a.firstName} ${a.lastName}'.trim();
    }
    return '${widget.l10n.patient} ${widget.patient.id}';
  }

  String get _initials {
    final parts = _name.trim().split(' ');
    final first = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0] : '';
    final last = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return '$first$last'.toUpperCase();
  }

  String get _subtitle {
    if (_isHuman) {
      final shortId = widget.patient.id.length > 6
          ? widget.patient.id.substring(widget.patient.id.length - 6).toUpperCase()
          : widget.patient.id.toUpperCase();
      return 'ID: P-$shortId';
    }
    final species = widget.patient.asAnimal?.species ?? '';
    return species.isNotEmpty ? species : '';
  }

  String get _sexLabel {
    Sex? sex;
    if (widget.patient.isPerson) sex = widget.patient.asPerson?.sex;
    if (widget.patient.isAnimal) sex = widget.patient.asAnimal?.sex;
    if (sex == null) return '—';
    switch (sex) {
      case Sex.mALE:
        return widget.l10n.genderMale;
      case Sex.fEMALE:
        return widget.l10n.genderFemale;
      case Sex.iNTERSEX:
        return 'Intersex';
    }
  }

  String get _speciesLabel {
    if (_isHuman) return '';
    return widget.patient.asAnimal?.species ?? '';
  }

  String get _birthDateLabel {
    int ts = 0;
    if (widget.patient.isPerson) ts = widget.patient.asPerson?.birthDate ?? 0;
    if (widget.patient.isAnimal) ts = widget.patient.asAnimal?.birthDate ?? 0;
    if (ts == 0) return '—';
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return '—';
    }
  }

  String get _contactPrimary {
    if (_isHuman) {
      final dni = widget.patient.asPerson?.dni ?? '';
      return dni.isNotEmpty ? '${widget.l10n.dni}: $dni' : '—';
    }
    return '—';
  }

  String get _contactSecondary {
    if (_isHuman) {
      return widget.patient.asPerson?.email ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final userRole = loggedUser?.labRole;
    final shouldHideMenu = userRole == LabMemberRole.tECHNICIAN || 
                           userRole == LabMemberRole.bILLING;

    final avatarColor =
        _isHuman ? colorScheme.primary : const Color(0xFFF59E0B);
    final badgeColor = _isHuman
        ? colorScheme.primary
        : const Color(0xFFF59E0B);
    final badgeBg = _isHuman
        ? colorScheme.primary.withOpacity(0.1)
        : const Color(0xFFF59E0B).withOpacity(0.12);
    final badgeLabel =
        _isHuman ? widget.l10n.patientTypeHuman : widget.l10n.patientTypeAnimal;

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
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            // Col 1: Nombre
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: avatarColor.withOpacity(0.12),
                    child: Text(
                      _initials,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: avatarColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_subtitle.isNotEmpty)
                          Text(
                            _subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Col 2: Clasificación
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badgeLabel.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: badgeColor,
                    ),
                  ),
                ),
              ),
            ),

            // Col 3: Demografía
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _sexLabel,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (_speciesLabel.isNotEmpty)
                    Text(
                      _speciesLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),

            // Col 4: Fecha de nacimiento
            Expanded(
              flex: 2,
              child: Text(
                _birthDateLabel,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // Col 5: Contacto / identificación
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _contactPrimary,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_contactSecondary.isNotEmpty)
                    Text(
                      _contactSecondary,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Col 6: Acciones
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isTechnician && widget.onUpdate != null)
                          _ActionButton(
                            icon: Icons.edit_outlined,
                            color: colorScheme.primary,
                            tooltip: widget.l10n.edit,
                            onTap: () =>
                                widget.onUpdate!(widget.patient.id),
                          ),
                        if (!isTechnician && widget.onDelete != null)
                          _ActionButton(
                            icon: Icons.delete_outline,
                            color: colorScheme.error,
                            tooltip: widget.l10n.delete,
                            onTap: () =>
                                widget.onDelete!(widget.patient.id),
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

// ── Action button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
