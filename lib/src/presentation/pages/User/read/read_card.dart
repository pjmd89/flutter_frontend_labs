import 'package:flutter/material.dart';

class ReadCard extends StatelessWidget {
  const ReadCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360, maxHeight: 150),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person_outline),
            ),
            title: Text(
              'Jaime Reyes',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: const Text('Laboratorio Clínico Dr. Jaime ...'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Ver laboratorios'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Ver facturación'),
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
