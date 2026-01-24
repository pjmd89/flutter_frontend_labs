import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class ExamsSection extends StatelessWidget {
  final EvaluationPackage evaluationPackage;
  final AppLocalizations l10n;

  const ExamsSection({
    super.key,
    required this.evaluationPackage,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (evaluationPackage.valuesByExam.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noExamsRegistered,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '${l10n.exams} (${evaluationPackage.valuesByExam.length})',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Lista de exámenes
        ...evaluationPackage.valuesByExam.asMap().entries.map((entry) {
          final index = entry.key;
          final examResult = entry.value;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ExamCard(
              examResult: examResult,
              index: index + 1,
              l10n: l10n,
            ),
          );
        }),
      ],
    );
  }
}

class _ExamCard extends StatelessWidget {
  final ExamResult examResult;
  final int index;
  final AppLocalizations l10n;

  const _ExamCard({
    required this.examResult,
    required this.index,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final examName = examResult.exam?.template?.name ?? l10n.examWithoutName;
    final hasIndicators = examResult.indicatorValues.isNotEmpty;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            '$index',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          examName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.payments_outlined,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              '${l10n.cost}: \$${examResult.cost.toStringAsFixed(2)}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.analytics_outlined,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              '${examResult.indicatorValues.length} ${l10n.indicators}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        children: [
          if (!hasIndicators)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.noIndicatorValues,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1),
                const SizedBox(height: 16),
                Text(
                  l10n.indicatorValues,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...examResult.indicatorValues.map((indicatorValue) {
                  return _IndicatorValueItem(
                    indicatorValue: indicatorValue,
                    theme: theme,
                    l10n: l10n,
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }
}

class _IndicatorValueItem extends StatelessWidget {
  final IndicatorValue indicatorValue;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _IndicatorValueItem({
    required this.indicatorValue,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorName = indicatorValue.indicator?.name ?? l10n.indicator;
    final value = indicatorValue.value;
    final unit = indicatorValue.indicator?.unit ?? '';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              indicatorName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$value $unit',
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
