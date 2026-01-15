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
    final isPaid = invoice.paymentStatus == PaymentStatus.paid;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(
          '${invoice.patient?.firstName ?? ''} ${invoice.patient?.lastName ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${l10n.orderID}: ${invoice.orderID}'),
            Text('${l10n.laboratory}: ${invoice.laboratory?.address ?? 'N/A'}'),
            const SizedBox(height: 4),
            Text(
              '${invoice.totalAmount.toStringAsFixed(2)} USD',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              avatar: Icon(
                isPaid ? Icons.check_circle : Icons.cancel,
                color: isPaid ? Colors.green : Colors.red,
                size: 20,
              ),
              label: Text(
                isPaid ? l10n.paid : l10n.canceled,
                style: TextStyle(
                  color: isPaid ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: isPaid
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
            ),
            if (isPaid && onCancelPayment != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.block, color: Colors.red),
                tooltip: l10n.cancelPayment,
                onPressed: () => onCancelPayment!(invoice.id),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}
