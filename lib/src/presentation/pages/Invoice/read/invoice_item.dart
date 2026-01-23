import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class InvoiceItem extends StatelessWidget {
  final Invoice invoice;
  final AppLocalizations l10n;
  final Function(String id)? onCancelPayment;

  const InvoiceItem({
    super.key,
    required this.invoice,
    required this.l10n,
    this.onCancelPayment,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.paymentStatus == PaymentStatus.pENDING;
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Patient name y payment status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${invoice.patient?.firstName ?? ''} ${invoice.patient?.lastName ?? ''}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    avatar: Icon(
                      isPaid ? Icons.check_circle : Icons.cancel,
                      color: isPaid ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    label: Text(
                      isPaid ? l10n.paid : l10n.canceled,
                      style: TextStyle(
                        color: isPaid ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: isPaid
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              
              // Order ID
              Row(
                children: [
                  Icon(Icons.receipt_long, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${l10n.orderID}: ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      invoice.orderID,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              
              // Laboratory
              Row(
                children: [
                  Icon(Icons.science, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${l10n.laboratory}: ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      invoice.laboratory?.company?.name ?? invoice.laboratory?.address ?? 'N/A',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              
              // Evaluation Package Status (si existe)
              if (invoice.evaluationPackage != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.medical_information, size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.evaluationPackage}: ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        invoice.evaluationPackage!.status?.name.toUpperCase() ?? 'N/A',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 8),
              // Total Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.totalAmount,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${invoice.totalAmount.toStringAsFixed(2)} USD',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              
              // Cancel Payment Button (solo si está pagado)
              if (isPaid && onCancelPayment != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    icon: const Icon(Icons.block, size: 18),
                    label: Text(l10n.cancelPayment),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    onPressed: () => onCancelPayment!(invoice.id),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
