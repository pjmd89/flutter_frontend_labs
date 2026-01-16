import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class EvaluationPackageItem extends StatelessWidget {
  final EvaluationPackage evaluationPackage;
  final AppLocalizations l10n;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const EvaluationPackageItem({
    super.key,
    required this.evaluationPackage,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusText = evaluationPackage.status?.toString().split('.').last ?? 'pending';
    final referredText = evaluationPackage.referred.isEmpty 
        ? 'N/A' 
        : evaluationPackage.referred;
    final hasObservations = evaluationPackage.observations.isNotEmpty;
    final examCount = evaluationPackage.valuesByExam.length;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  _getStatusIcon(evaluationPackage.status),
                  color: _getStatusColor(evaluationPackage.status),
                ),
              ),
              title: Text(
                'ID: ${evaluationPackage.id.substring(0, 8)}...',
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${l10n.status}: $statusText'),
                  Text('${l10n.exams}: $examCount'),
                ],
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit' && onUpdate != null) {
                    onUpdate!(evaluationPackage.id);
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!(evaluationPackage.id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit),
                        const SizedBox(width: 8),
                        Text(l10n.edit),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete),
                        const SizedBox(width: 8),
                        Text(l10n.delete),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 16, color: theme.colorScheme.secondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${l10n.referred}: $referredText',
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (hasObservations) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.note_outlined, size: 16, color: theme.colorScheme.secondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${evaluationPackage.observations.length} ${l10n.observations.toLowerCase()}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(ResultStatus? status) {
    switch (status) {
      case ResultStatus.completed:
        return Icons.check_circle_outline;
      case ResultStatus.inProgress:
        return Icons.pending_outlined;
      case ResultStatus.pending:
        return Icons.access_time_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(ResultStatus? status) {
    switch (status) {
      case ResultStatus.completed:
        return Colors.green;
      case ResultStatus.inProgress:
        return Colors.orange;
      case ResultStatus.pending:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
