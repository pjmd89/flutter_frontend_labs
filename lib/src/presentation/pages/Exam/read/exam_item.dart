import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExamItem extends StatefulWidget {
  final Exam exam;
  final AppLocalizations l10n;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const ExamItem({
    super.key,
    required this.exam,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
  });

  @override
  State<ExamItem> createState() => _ExamItemState();
}

class _ExamItemState extends State<ExamItem> {
  bool _isHovered = false;

  String get _templateShortId {
    final id = widget.exam.template?.id ?? widget.exam.id;
    final suffix = id.length > 6
        ? id.substring(id.length - 6).toUpperCase()
        : id.toUpperCase();
    return 'TMP-$suffix';
  }

  String get _formattedDate {
    try {
      if (widget.exam.created == 0) return '—';
      final date =
          DateTime.fromMillisecondsSinceEpoch(widget.exam.created * 1000);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return '—';
    }
  }

  String get _baseCost {
    final cost = widget.exam.baseCost;
    if (cost == cost.truncate()) {
      return '\$${cost.toInt()}.00';
    }
    return '\$${cost.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final userRole = loggedUser?.labRole;
    final shouldHideActions =
        userRole == LabMemberRole.bILLING ||
        userRole == LabMemberRole.tECHNICIAN;

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
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            // Col 1: Exam name
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.biotech_outlined,
                      color: colorScheme.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.exam.template?.name ??
                          widget.l10n.noDataAvailable,
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

            // Col 2: Template ID
            Expanded(
              flex: 2,
              child: Text(
                _templateShortId,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // Col 3: Laboratory
            Expanded(
              flex: 3,
              child: Text(
                widget.exam.laboratory?.company?.name ??
                    widget.l10n.noDataAvailable,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Col 4: Base cost
            Expanded(
              flex: 2,
              child: Text(
                _baseCost,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Col 5: Creation date
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
                  if (!shouldHideActions)
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
                              hoverBg:
                                  colorScheme.primary.withOpacity(0.1),
                              tooltip: widget.l10n.edit,
                              onTap: () =>
                                  widget.onUpdate!(widget.exam.id),
                            ),
                          if (widget.onDelete != null)
                            _ActionButton(
                              icon: Icons.delete_outline,
                              color: colorScheme.error,
                              hoverBg:
                                  colorScheme.error.withOpacity(0.1),
                              tooltip: widget.l10n.delete,
                              onTap: () =>
                                  widget.onDelete!(widget.exam.id),
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

// ── Action button ───────────────────────────────────────────────────────

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
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _hovered ? widget.hoverBg : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _hovered
                  ? widget.color
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
