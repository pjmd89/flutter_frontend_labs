import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';
import './list_builder.dart';
import './search_config.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late ViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return SearchTemplate(
          config: getSearchConfig(
            context: context,
            viewModel: viewModel,
            l10n: l10n,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Tabla de facturas
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _InvoiceTableHeader(l10n: l10n),
                    ...buildList(
                      context: context,
                      viewModel: viewModel,
                      l10n: l10n,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Stat card
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: _InvoiceStatCard(
                    label: l10n.invoices,
                    count: viewModel.invoiceList?.length ?? 0,
                    theme: theme,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Table Header ─────────────────────────────────────────────────────────────

class _InvoiceTableHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _InvoiceTableHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurfaceVariant,
      letterSpacing: 0.8,
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(l10n.orderID.toUpperCase(), style: style),
          ),
          Expanded(
            flex: 3,
            child: Text(l10n.patient.toUpperCase(), style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(l10n.billTo.toUpperCase(), style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(l10n.totalAmount.toUpperCase(), style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(l10n.invoiceType.toUpperCase(), style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(l10n.paymentStatus.toUpperCase(), style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(l10n.created.toUpperCase(), style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(l10n.actions.toUpperCase(), style: style),
          ),
        ],
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────

class _InvoiceStatCard extends StatelessWidget {
  final String label;
  final int count;
  final ThemeData theme;

  const _InvoiceStatCard({
    required this.label,
    required this.count,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: theme.colorScheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count.toString(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

