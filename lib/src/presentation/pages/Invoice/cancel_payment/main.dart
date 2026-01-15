import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';

class InvoiceCancelPaymentPage extends StatefulWidget {
  final String id;

  const InvoiceCancelPaymentPage({
    super.key,
    required this.id,
  });

  @override
  State<InvoiceCancelPaymentPage> createState() =>
      _InvoiceCancelPaymentPageState();
}

class _InvoiceCancelPaymentPageState extends State<InvoiceCancelPaymentPage> {
  late ViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return AlertDialog(
          title: const Text('Cancelar Pago'),
          content: const Text('¿Cancelar el pago de esta factura?'),
          actions: [
            TextButton(
              onPressed: viewModel.loading ? null : () => context.pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: viewModel.loading
                  ? null
                  : () async {
                      final success = await viewModel.cancel(id: widget.id);
                      if (!context.mounted) return;
                      context.pop(success);
                    },
              child: viewModel.loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }
}
