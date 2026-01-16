import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class ExamItem extends StatelessWidget {
  final Exam exam;
  final AppLocalizations l10n;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const ExamItem({
    super.key,
    required this.exam,
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
                child: Icon(Icons.medical_services),
              ),
              title: Text(exam.template?.name ?? l10n.noDataAvailable),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (exam.laboratory != null)
                    Text('${l10n.laboratory}: ${exam.laboratory!.company?.name ?? l10n.noDataAvailable}'),
                  Text('${l10n.baseCost}: \$${exam.baseCost}'),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit' && onUpdate != null) {
                    onUpdate!(exam.id);
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!(exam.id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(l10n.edit),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(l10n.delete),
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
