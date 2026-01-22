import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:intl/intl.dart';

class DetailsSection extends StatelessWidget {
  final EvaluationPackage evaluationPackage;
  final AppLocalizations l10n;

  const DetailsSection({
    super.key,
    required this.evaluationPackage,
    required this.l10n,
  });

  String _getStatusText(ResultStatus? status) {
    switch (status) {
      case ResultStatus.completed:
        return 'Completado';
      case ResultStatus.inProgress:
        return 'En Progreso';
      case ResultStatus.pending:
        return 'Pendiente';
      default:
        return 'Desconocido';
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

  IconData _getStatusIcon(ResultStatus? status) {
    switch (status) {
      case ResultStatus.completed:
        return Icons.check_circle;
      case ResultStatus.inProgress:
        return Icons.pending;
      case ResultStatus.pending:
        return Icons.access_time;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(num? timestamp) {
    if (timestamp == null || timestamp == 0) return 'N/A';
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(evaluationPackage.status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección
            Text(
              'Información General',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),

            // Estado con chip grande
            Row(
              children: [
                Icon(
                  _getStatusIcon(evaluationPackage.status),
                  color: statusColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.status,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          _getStatusText(evaluationPackage.status),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // Referido
            _buildInfoRow(
              context: context,
              icon: Icons.person_outline,
              label: l10n.referred,
              value: evaluationPackage.referred.isEmpty 
                  ? 'N/A' 
                  : evaluationPackage.referred,
            ),
            
            const SizedBox(height: 16),

            // Número de exámenes
            _buildInfoRow(
              context: context,
              icon: Icons.assignment_outlined,
              label: l10n.exams,
              value: '${evaluationPackage.valuesByExam.length}',
            ),
            
            const SizedBox(height: 16),

            // Fecha de creación
            _buildInfoRow(
              context: context,
              icon: Icons.calendar_today_outlined,
              label: 'Fecha de creación',
              value: _formatDate(evaluationPackage.created),
            ),
            
            if (evaluationPackage.completedAt != 0) ...[
              const SizedBox(height: 16),
              _buildInfoRow(
                context: context,
                icon: Icons.event_available_outlined,
                label: 'Completado el',
                value: _formatDate(evaluationPackage.completedAt),
              ),
            ],

            // Observaciones
            if (evaluationPackage.observations.isNotEmpty) ...[
              const Divider(height: 32),
              Text(
                l10n.observations,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...evaluationPackage.observations.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
