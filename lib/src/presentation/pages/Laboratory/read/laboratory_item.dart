import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:intl/intl.dart';

class LaboratoryItem extends StatefulWidget {
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

  @override
  State<LaboratoryItem> createState() => _LaboratoryItemState();
}

class _LaboratoryItemState extends State<LaboratoryItem> {
  bool _isHovered = false;

  static const List<Color> _iconBgColors = [
    Color(0xFF137fec),
    Color(0xFF10B981),
    Color(0xFFF97316),
    Color(0xFF6366F1),
    Color(0xFFEC4899),
  ];

  static const List<IconData> _labIcons = [
    Icons.corporate_fare_outlined,
    Icons.science_outlined,
    Icons.medical_services_outlined,
    Icons.biotech_outlined,
    Icons.foundation_outlined,
  ];

  Color get _iconColor {
    final idx = widget.laboratory.id.hashCode.abs() % _iconBgColors.length;
    return _iconBgColors[idx];
  }

  IconData get _icon {
    final idx = widget.laboratory.id.hashCode.abs() % _labIcons.length;
    return _labIcons[idx];
  }

  String _getFormattedDate() {
    try {
      if (widget.laboratory.created == 0) return '—';
      final date = DateTime.fromMillisecondsSinceEpoch(
          widget.laboratory.created * 1000);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return '—';
    }
  }

  int get _employeeCount =>
      widget.laboratory.employees?.edges.length ?? 0;

  String get _labShortId {
    final id = widget.laboratory.id;
    final suffix =
        id.length > 6 ? id.substring(id.length - 6).toUpperCase() : id.toUpperCase();
    return 'LAB-ID: $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lab = widget.laboratory;
    final phones = lab.contactPhoneNumbers;

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
            // Col 1: Laboratory Name
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _iconColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_icon, color: _iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lab.company?.name ?? '—',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _labShortId,
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Col 2: Address
            Expanded(
              flex: 3,
              child: Text(
                lab.address.isNotEmpty ? lab.address : '—',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Col 3: Contact phones
            Expanded(
              flex: 3,
              child: phones.isEmpty
                  ? Text(
                      '—',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    )
                  : Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        for (int i = 0; i < phones.length; i++)
                          _PhoneChip(
                              phone: phones[i], isPrimary: i == 0),
                      ],
                    ),
            ),

            // Col 4: Employees count
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  _employeeCount.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Col 5: Created date
            Expanded(
              flex: 2,
              child: Text(
                _getFormattedDate(),
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
                        if (widget.onViewBilling != null)
                          _ActionButton(
                            icon: Icons.receipt_long_outlined,
                            tooltip: widget.l10n.viewBilling,
                            onTap: () =>
                                widget.onViewBilling!(lab.id),
                          ),
                        if (widget.onUpdate != null)
                          _ActionButton(
                            icon: Icons.edit_outlined,
                            tooltip: widget.l10n.edit,
                            onTap: () => widget.onUpdate!(lab.id),
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

// ── Phone chip ────────────────────────────────────────────────────────────────

class _PhoneChip extends StatelessWidget {
  final String phone;
  final bool isPrimary;

  const _PhoneChip({required this.phone, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPrimary
            ? colorScheme.primary.withOpacity(0.1)
            : colorScheme.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isPrimary
              ? colorScheme.primary.withOpacity(0.25)
              : colorScheme.onSurface.withOpacity(0.12),
        ),
      ),
      child: Text(
        phone,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isPrimary
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ── Action icon button ────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}