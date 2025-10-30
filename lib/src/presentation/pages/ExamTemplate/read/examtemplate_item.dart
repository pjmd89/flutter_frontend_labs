import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class ExamTemplateItem extends StatelessWidget {
  final ExamTemplate examTemplate;
  final AppLocalizations l10n;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const ExamTemplateItem({
    super.key,
    required this.examTemplate,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.assignment_outlined),
              ),
              title: Text(examTemplate.name),
              subtitle: Text(
                examTemplate.description.isNotEmpty
                    ? examTemplate.description
                    : l10n.noDataAvailable,
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit' && onUpdate != null) {
                    onUpdate!(examTemplate.id);
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!(examTemplate.id);
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                      PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                    ],
              ),
            ),
            if (examTemplate.indicators.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Indicadores (${examTemplate.indicators.length}):',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children:
                          examTemplate.indicators.take(3).map((indicator) {
                              return Chip(
                                label: Text(
                                  indicator.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              );
                            }).toList()
                            ..addAll(
                              examTemplate.indicators.length > 3
                                  ? [
                                    Chip(
                                      label: Text(
                                        '+${examTemplate.indicators.length - 3}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ]
                                  : [],
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
}
