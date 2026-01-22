import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import './view_model.dart';

class LaboratoryBillingPage extends StatefulWidget {
  const LaboratoryBillingPage({super.key, required this.laboratoryId});
  final String laboratoryId;

  @override
  State<LaboratoryBillingPage> createState() => _LaboratoryBillingPageState();
}

class _LaboratoryBillingPageState extends State<LaboratoryBillingPage> {
  late ViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, laboratoryId: widget.laboratoryId);
    viewModel.loadInvoices();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.receipt_long_outlined,
          title: l10n.viewBilling,
          loading: viewModel.loading,
          form: Form(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.error)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          l10n.errorLoadingData,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    )
                  else if (viewModel.invoiceList == null || viewModel.invoiceList!.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(l10n.noRegisteredFemaleThings('Facturas')),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.invoiceList!.length,
                        itemBuilder: (context, index) {
                          final invoice = viewModel.invoiceList![index];
                          return _buildInvoiceCard(context, invoice, l10n);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInvoiceCard(BuildContext context, Invoice invoice, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.receipt),
        title: Text('Order: ${invoice.orderID}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.totalAmount}: \$${invoice.totalAmount}'),
            Text('${l10n.status}: ${invoice.paymentStatus.toString().split('.').last}'),
            if (invoice.patient != null)
              Text('${l10n.patient}: ${invoice.patient!.firstName} ${invoice.patient!.lastName}'),
          ],
        ),
      ),
    );
  }
}
