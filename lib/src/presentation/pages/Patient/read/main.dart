import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';
import './search_config.dart';
import './list_builder.dart';
import './patient_item.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  late ViewModel viewModel;
  PatientType? selectedPatientType;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  List<Widget> _applyFilter(List<Widget> list) {
    if (selectedPatientType == null) return list;
    return list.where((w) {
      if (w is PatientItem) {
        return w.patient.patientType == selectedPatientType;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final allList = buildList(
          context: context,
          viewModel: viewModel,
          l10n: l10n,
        );
        final filteredList = _applyFilter(allList);
        final totalCount =
            viewModel.pageInfo?.total.toInt() ??
            viewModel.patientList?.length ??
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

              // ── Filter bar ───────────────────────────────────────────
              _PatientFilterBar(
                selectedType: selectedPatientType,
                onTypeChanged: (t) => setState(() => selectedPatientType = t),
              ),
              const SizedBox(height: 8),

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
                    _PatientTableHeader(l10n: l10n),
                    ...filteredList,
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Stat card ────────────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: _StatCard(
                    title: l10n.patients.toUpperCase(),
                    value: totalCount.toString(),
                    icon: Icons.groups_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        );
      },
    );
  }
}

// ── Filter bar ────────────────────────────────────────────────────────────────

class _PatientFilterBar extends StatelessWidget {
  final PatientType? selectedType;
  final Function(PatientType?) onTypeChanged;

  const _PatientFilterBar({
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(
                color: colorScheme.onSurface.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<PatientType?>(
            value: selectedType,
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.arrow_drop_down, size: 20),
            dropdownColor: colorScheme.surfaceContainerHighest,
            style: TextStyle(
                fontSize: 13, color: colorScheme.onSurface),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(l10n.allPatients),
              ),
              DropdownMenuItem(
                value: PatientType.hUMAN,
                child: Text(l10n.patientTypeHuman),
              ),
              DropdownMenuItem(
                value: PatientType.aNIMAL,
                child: Text(l10n.patientTypeAnimal),
              ),
            ],
            onChanged: onTypeChanged,
          ),
        ),
      ],
    );
  }
}

// ── Table header ──────────────────────────────────────────────────────────────

class _PatientTableHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _PatientTableHeader({required this.l10n});

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
          _HeaderCell(label: l10n.patient.toUpperCase(), flex: 4),
          _HeaderCell(label: l10n.patientType.toUpperCase(), flex: 2),
          _HeaderCell(label: l10n.gender.toUpperCase(), flex: 3),
          _HeaderCell(label: l10n.birthDate.toUpperCase(), flex: 2),
          _HeaderCell(label: '${l10n.phone} / ${l10n.dni}'.toUpperCase(), flex: 3),
          _HeaderCell(label: l10n.actions.toUpperCase(), flex: 2, centered: true),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  final bool centered;

  const _HeaderCell({
    required this.label,
    required this.flex,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: centered ? TextAlign.center : TextAlign.start,
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

// ── Stat card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.1)),
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

