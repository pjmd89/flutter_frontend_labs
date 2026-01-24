import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class EvaluationPackageItem extends StatelessWidget {
  final EvaluationPackage evaluationPackage;
  final AppLocalizations l10n;
  final Function(String id)? onView;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const EvaluationPackageItem({
    super.key,
    required this.evaluationPackage,
    required this.l10n,
    this.onView,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusText = _getStatusText(evaluationPackage.status);
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
                '${l10n.status}: $statusText',
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text('${l10n.exams}: $examCount'),
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
                  const SizedBox(height: 8),
                  // Estado de aprobación
                  Row(
                    children: [
                      Icon(
                        evaluationPackage.isApproved 
                            ? Icons.verified_outlined 
                            : Icons.pending_outlined,
                        size: 16,
                        color: evaluationPackage.isApproved 
                            ? Colors.green 
                            : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          evaluationPackage.isApproved 
                              ? l10n.approved 
                              : l10n.notApproved,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: evaluationPackage.isApproved 
                                ? Colors.green 
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
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
                  const SizedBox(height: 16),
                  // Botón "Ver"
                  if (onView != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: () => onView!(evaluationPackage.id),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: Text(
                          l10n.view,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(ResultStatus? status) {
    switch (status) {
      case ResultStatus.cOMPLETED:
        return l10n.statusCompleted;
      case ResultStatus.iNPROGRESS:
        return l10n.statusInProgress;
      case ResultStatus.pENDING:
        return l10n.statusPending;
      default:
        return l10n.statusUnknown;
    }
  }

  IconData _getStatusIcon(ResultStatus? status) {
    switch (status) {
      case ResultStatus.cOMPLETED:
        return Icons.check_circle_outline;
      case ResultStatus.iNPROGRESS:
        return Icons.pending_outlined;
      case ResultStatus.pENDING:
        return Icons.access_time_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(ResultStatus? status) {
    switch (status) {
      case ResultStatus.cOMPLETED:
        return Colors.green;
      case ResultStatus.iNPROGRESS:
        return Colors.orange;
      case ResultStatus.pENDING:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
