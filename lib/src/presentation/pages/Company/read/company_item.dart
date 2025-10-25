import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class CompanyItem extends StatelessWidget {
  final Company company;
  final AppLocalizations l10n;
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const CompanyItem({
    super.key,
    required this.company,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.business_outlined)),
        title: Text(company.name),
        subtitle: Text('${l10n.taxID}: ${company.taxID}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit' && onUpdate != null) {
              onUpdate!(company.id);
            } else if (value == 'delete' && onDelete != null) {
              onDelete!(company.id);
            }
          },
          itemBuilder:
              (context) => [
                PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
              ],
        ),
      ),
    );
  }
}
