import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class InvoiceItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determinar label, color e icono del estado de pago
    String paymentStatusLabel;
    Color paymentStatusColor;
    IconData paymentStatusIcon;
    
    switch (invoice.paymentStatus) {
      case PaymentStatus.pAID:
        paymentStatusLabel = l10n.paid;
        paymentStatusColor = Colors.green;
        paymentStatusIcon = Icons.check_circle;
        break;
      case PaymentStatus.pENDING:
        paymentStatusLabel = l10n.pending;
        paymentStatusColor = Colors.orange;
        paymentStatusIcon = Icons.schedule;
        break;
      case PaymentStatus.cANCELED:
        paymentStatusLabel = l10n.canceled;
        paymentStatusColor = Colors.red;
        paymentStatusIcon = Icons.cancel;
        break;
      case null:
        paymentStatusLabel = 'N/A';
        paymentStatusColor = Colors.grey;
        paymentStatusIcon = Icons.help_outline;
        break;
    }
    
    // Determinar label y color del tipo de factura
    String invoiceTypeLabel;
    Color invoiceTypeColor;
    
    if (invoice.kind == InvoiceKind.cREDIT_NOTE) {
      invoiceTypeLabel = l10n.invoiceTypeCreditNote;
      invoiceTypeColor = Colors.orange;
    } else {
      invoiceTypeLabel = l10n.invoiceTypeInvoice;
      invoiceTypeColor = Colors.blue;
    }

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
                      _getPatientName(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    avatar: Icon(
                      paymentStatusIcon,
                      color: paymentStatusColor,
                      size: 18,
                    ),
                    label: Text(
                      paymentStatusLabel,
                      style: TextStyle(
                        color: paymentStatusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: paymentStatusColor.withOpacity(0.15), // color del estado de pago
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Tipo de Factura
              Row(
                children: [
                  Icon(Icons.description, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${l10n.invoiceType}: ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Chip(
                    label: Text(
                      invoiceTypeLabel,
                      style: TextStyle(
                        color: invoiceTypeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                    backgroundColor: invoiceTypeColor.withOpacity(0.15), //color del tipo de factura
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    visualDensity: VisualDensity.compact,
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
              
              // Botones de actualización de estado de pago
              if (onUpdatePaymentStatus != null && invoice.paymentStatus != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Botón Marcar como Pagado (si está pending o canceled)
                    if (invoice.paymentStatus != PaymentStatus.pAID)
                      Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.check_circle, size: 18),
                          label: Text(l10n.markAsPaid),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                          onPressed: () => onUpdatePaymentStatus!(invoice.id, PaymentStatus.pAID),
                        ),
                      ),
                    
                    // Espaciador si hay dos botones
                    if (invoice.paymentStatus != PaymentStatus.pAID && 
                        invoice.paymentStatus != PaymentStatus.cANCELED)
                      const SizedBox(width: 8),
                    
                    // Botón Cancelar Pago (si está paid o pending)
                    if (invoice.paymentStatus != PaymentStatus.cANCELED)
                      Expanded(
                        child: TextButton.icon(
                          icon: const Icon(Icons.block, size: 18),
                          label: Text(l10n.cancelPayment),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () => onUpdatePaymentStatus!(invoice.id, PaymentStatus.cANCELED),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  String _getPatientName() {
    if (invoice.patient == null) return l10n.patient;
    
    final patient = invoice.patient!;
    
    if (patient.isPerson && patient.asPerson != null) {
      final person = patient.asPerson!;
      return '${person.firstName} ${person.lastName}';
    } else if (patient.isAnimal && patient.asAnimal != null) {
      final animal = patient.asAnimal!;
      return '${animal.firstName} ${animal.lastName}';
    }
    
    return '${l10n.patient} ${patient.id}';
  }
}
