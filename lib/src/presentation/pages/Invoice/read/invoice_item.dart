import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:provider/provider.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';

class InvoiceItem extends StatefulWidget {
  final Invoice invoice;
  final AppLocalizations l10n;
  final Function(String id, PaymentStatus newStatus)? onUpdatePaymentStatus;

  const InvoiceItem({
    super.key,
    required this.invoice,
    required this.l10n,
    this.onUpdatePaymentStatus,
  });

  @override
  State<InvoiceItem> createState() => _InvoiceItemState();
}

class _InvoiceItemState extends State<InvoiceItem> {
  bool _isHovered = false;

  String _getPatientName() {
    if (widget.invoice.patient == null) return widget.l10n.patient;
    final patient = widget.invoice.patient!;
    if (patient.isPerson && patient.asPerson != null) {
      final p = patient.asPerson!;
      return '${p.firstName} ${p.lastName}';
    } else if (patient.isAnimal && patient.asAnimal != null) {
      final a = patient.asAnimal!;
      return '${a.firstName} ${a.lastName}';
    }
    return widget.l10n.patient;
  }

  String _getBillToName() {
    if (widget.invoice.billTo == null) return '—';
    final bt = widget.invoice.billTo!;
    return '${bt.firstName} ${bt.lastName}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = widget.l10n;
    final invoice = widget.invoice;
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final userRole = loggedUser?.labRole;
    final canManage = userRole != LabMemberRole.tECHNICIAN;

    // Status colors
    Color statusColor;
    Color statusBg;
    String statusLabel;
    switch (invoice.paymentStatus) {
      case PaymentStatus.pAID:
        statusColor = const Color(0xFF059669);
        statusBg = const Color(0xFFD1FAE5);
        statusLabel = l10n.paid;
        break;
      case PaymentStatus.pENDING:
        statusColor = const Color(0xFFD97706);
        statusBg = const Color(0xFFFEF3C7);
        statusLabel = l10n.pending;
        break;
      case PaymentStatus.cANCELED:
        statusColor = const Color(0xFFE11D48);
        statusBg = const Color(0xFFFFE4E6);
        statusLabel = l10n.canceled;
        break;
      default:
        statusColor = theme.colorScheme.outline;
        statusBg = theme.colorScheme.surfaceContainerHighest;
        statusLabel = 'N/A';
    }

    // Kind badge colors
    final isCredit = invoice.kind == InvoiceKind.cREDIT_NOTE;
    final kindLabel =
        isCredit ? l10n.invoiceTypeCreditNote : l10n.invoiceTypeInvoice;
    final kindColor = theme.colorScheme.primary;
    final kindBg = theme.colorScheme.primary.withOpacity(0.08);

    // Amount color: red for credit notes
    final amountColor =
        isCredit ? theme.colorScheme.error : theme.colorScheme.onSurface;
    final formattedAmount = '\$${invoice.totalAmount.toStringAsFixed(2)}';

    // Date
    final createdAt = invoice.created != 0
        ? DateFormat('MMM dd, yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(invoice.created * 1000),
          )
        : '—';

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
              // Order ID
              Expanded(
                flex: 2,
                child: Text(
                  invoice.orderID.isNotEmpty ? invoice.orderID : '—',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
              // Bill To
              Expanded(
                flex: 2,
                child: Text(
                  _getBillToName(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Amount
              Expanded(
                flex: 2,
                child: Text(
                  formattedAmount,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              // Kind Badge
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kindBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      kindLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: kindColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              // Status Pill
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                ),
              ),
              // Actions
              Expanded(
                flex: 2,
                child: widget.onUpdatePaymentStatus != null && canManage
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (invoice.paymentStatus == PaymentStatus.pENDING)
                            _ActionButton(
                              label: l10n.markAsPaid,
                              icon: Icons.check_circle_outline,
                              color: const Color(0xFF059669),
                              onTap: () => widget.onUpdatePaymentStatus!(
                                invoice.id,
                                PaymentStatus.pAID,
                              ),
                            ),
                          if (invoice.paymentStatus == PaymentStatus.pAID)
                            _ActionButton(
                              label: l10n.cancelPayment,
                              icon: Icons.block,
                              color: theme.colorScheme.error,
                              onTap: () => widget.onUpdatePaymentStatus!(
                                invoice.id,
                                PaymentStatus.cANCELED,
                              ),
                            ),
                        ],
                      )
                    : const SizedBox.shrink(),
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
