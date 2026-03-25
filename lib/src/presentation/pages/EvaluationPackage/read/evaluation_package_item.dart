import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'dart:html' as html;

class EvaluationPackageItem extends StatefulWidget {
  final EvaluationPackage evaluationPackage;
  final AppLocalizations l10n;
  final Function(String id)? onView;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const EvaluationPackageItem({
    super.key,
    required this.evaluationPackage,
    required this.l10n,
    this.onView,
    this.onUpdate,
    this.onDelete,
  });

  @override
  State<EvaluationPackageItem> createState() => _EvaluationPackageItemState();
}

class _EvaluationPackageItemState extends State<EvaluationPackageItem> {
  bool _isHovered = false;

  String _getPatientName() {
    if (widget.evaluationPackage.patient == null) return '—';
    final patient = widget.evaluationPackage.patient!;
    if (patient.isPerson && patient.asPerson != null) {
      final p = patient.asPerson!;
      return '${p.firstName} ${p.lastName}';
    } else if (patient.isAnimal && patient.asAnimal != null) {
      final a = widget.evaluationPackage.patient!.asAnimal!;
      return '${a.firstName} ${a.lastName}';
    }
    return '—';
  }

  String _getStatusText(ResultStatus? status) {
    switch (status) {
      case ResultStatus.cOMPLETED:
        return widget.l10n.statusCompleted;
      case ResultStatus.iNPROGRESS:
        return widget.l10n.statusInProgress;
      case ResultStatus.pENDING:
        return widget.l10n.statusPending;
      default:
        return widget.l10n.statusUnknown;
    }
  }

  Color _getStatusColor(ResultStatus? status, ThemeData theme) {
    switch (status) {
      case ResultStatus.cOMPLETED:
        return const Color(0xFF059669);
      case ResultStatus.iNPROGRESS:
        return const Color(0xFFD97706);
      case ResultStatus.pENDING:
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = widget.l10n;
    final pkg = widget.evaluationPackage;

    // Status
    final statusLabel = _getStatusText(pkg.status);
    final statusColor = _getStatusColor(pkg.status, theme);
    final statusBg = statusColor.withOpacity(0.12);

    // Date
    final createdAt = pkg.created != 0
        ? DateFormat('MMM dd, yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(pkg.created * 1000),
          )
        : '—';

    // Referred
    final referred = pkg.referred.isNotEmpty ? pkg.referred : '—';

    // Exam count
    final examCount = pkg.valuesByExam.length.toString();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered
              ? theme.colorScheme.primary.withOpacity(0.04)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Patient
              Expanded(
                flex: 3,
                child: Text(
                  _getPatientName(),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Referred
              Expanded(
                flex: 2,
                child: Text(
                  referred,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Exam Count
              Expanded(
                flex: 2,
                child: Text(
                  '$examCount ${l10n.exams.toLowerCase()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Status Badge
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              // Approved Badge
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      pkg.isApproved
                          ? Icons.verified_outlined
                          : Icons.pending_outlined,
                      size: 16,
                      color: pkg.isApproved
                          ? const Color(0xFF059669)
                          : const Color(0xFFD97706),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        pkg.isApproved ? l10n.approved : l10n.notApproved,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: pkg.isApproved
                              ? const Color(0xFF059669)
                              : const Color(0xFFD97706),
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Date
              Expanded(
                flex: 2,
                child: Text(
                  createdAt,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Actions
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // PDF Button
                      if (pkg.pdfToken.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: _ActionButton(
                            label: l10n.viewPdf,
                            icon: Icons.picture_as_pdf,
                            color: theme.colorScheme.primary,
                            onTap: () {
                              final token = pkg.pdfToken;
                              final url = 'https://localhost:8443/evaluation-pdf/$token';
                              html.window.open(url, '_blank');
                            },
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Tooltip(
                            message: 'PDF no disponible',
                            child: Icon(
                              Icons.picture_as_pdf_outlined,
                              size: 20,
                              color: theme.colorScheme.outline
                                  .withOpacity(0.3),
                            ),
                          ),
                        ),
                      // View Button
                      if (widget.onView != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: _ActionButton(
                            label: l10n.view,
                            icon: Icons.visibility_outlined,
                            color: theme.colorScheme.primary,
                            onTap: () => widget.onView!(pkg.id),
                          ),
                        ),
                      // Edit Button
                      if (widget.onUpdate != null)
                        _ActionButton(
                          label: l10n.edit,
                          icon: Icons.edit_outlined,
                          color: theme.colorScheme.secondary,
                          onTap: () => widget.onUpdate!(pkg.id),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Action Button ───────────────────────────────────────────────────────────

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _hovered
              ? widget.color.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 16, color: widget.color),
                const SizedBox(width: 4),
                Text(
                  widget.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: widget.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
