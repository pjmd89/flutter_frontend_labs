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
      const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
    ];
  }

  // Estado: Error
  if (viewModel.error) {
    return [
      Center(
        child: Text(l10n.errorLoadingData),
      )
    ];
  }

  // Estado: Sin datos
  if (viewModel.invoiceList == null || viewModel.invoiceList!.isEmpty) {
    return [
      Center(
        child: Text(l10n.noRegisteredFemaleThings(l10n.invoices)),
      )
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
