import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './invoice_item.dart';

List<Widget> buildList({
  required BuildContext context,
  required ViewModel viewModel,
  required AppLocalizations l10n,
}) {
  // Estado: Cargando
  if (viewModel.loading) {
    return [
      Padding(
        padding: const EdgeInsets.all(48.0),
        child: Center(child: CircularProgressIndicator()),
      ),
    ];
  }

  // Estado: Error
  if (viewModel.error) {
    return [
      Padding(
        padding: const EdgeInsets.all(48.0),
        child: Center(child: Text(l10n.errorLoadingData)),
      ),
    ];
  }

  // Estado: Sin datos
  if (viewModel.invoiceList == null || viewModel.invoiceList!.isEmpty) {
    return [
      Padding(
        padding: const EdgeInsets.all(48.0),
        child: Center(child: Text(l10n.noRegisteredFemaleThings(l10n.invoices))),
      ),
    ];
  }

  return viewModel.invoiceList!.map((invoice) {
    return InvoiceItem(
      invoice: invoice,
      l10n: l10n,
      onUpdatePaymentStatus: (id, newStatus) async {
        await viewModel.updatePaymentStatus(id, newStatus);
      },
    );
  }).toList();
}

