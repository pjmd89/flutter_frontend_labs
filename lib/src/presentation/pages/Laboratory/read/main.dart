import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';
import './search_config.dart';
import './list_builder.dart';

class LaboratoryPage extends StatefulWidget {
  const LaboratoryPage({super.key});

  @override
  State<LaboratoryPage> createState() => _LaboratoryPageState();
}

class _LaboratoryPageState extends State<LaboratoryPage> {
  late ViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

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
        final totalLabs =
            viewModel.pageInfo?.total.toInt() ??
            viewModel.laboratoryList?.length ??
            0;

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

              // ── Table container ──────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Table header
                    _LaboratoryTableHeader(l10n: l10n),
                    // Rows
                    ...buildList(
                      context: context,
                      viewModel: viewModel,
                      l10n: l10n,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Stats grid ───────────────────────────────────────────
              _LaboratoryStatsGrid(totalLabs: totalLabs, l10n: l10n),

              const SizedBox(height: 48),
            ],
          ),
        );
      },
    );
  }
}

// ── Table header ──────────────────────────────────────────────────────────────

class _LaboratoryTableHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _LaboratoryTableHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          bottom:
              BorderSide(color: colorScheme.onSurface.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          _HeaderCell(label: l10n.laboratory.toUpperCase(), flex: 4),
          _HeaderCell(label: l10n.address.toUpperCase(), flex: 3),
          _HeaderCell(label: l10n.phone.toUpperCase(), flex: 3),
          _HeaderCell(label: l10n.employees.toUpperCase(), flex: 1, centered: true),
          _HeaderCell(label: l10n.created.toUpperCase(), flex: 2),
          _HeaderCell(label: l10n.actions.toUpperCase(), flex: 2, alignEnd: true),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  final bool centered;
  final bool alignEnd;

  const _HeaderCell({
    required this.label,
    required this.flex,
    this.centered = false,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: alignEnd
            ? TextAlign.end
            : (centered ? TextAlign.center : TextAlign.start),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ── Stats grid ────────────────────────────────────────────────────────────────

class _LaboratoryStatsGrid extends StatelessWidget {
  final int totalLabs;
  final AppLocalizations l10n;
  const _LaboratoryStatsGrid({required this.totalLabs, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: _statCard(
          context,
          l10n.totalLabs.toUpperCase(),
          totalLabs.toString(),
          Icons.science_outlined,
          colorScheme.primary,
        ),
      ),
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}