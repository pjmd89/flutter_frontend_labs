import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/l10n/app_localizations.dart';
import './view_model.dart';

class PatientDeletePage extends StatefulWidget {
  const PatientDeletePage({
    super.key,
    required this.id,
    this.patientName,
  });
  
  final String id;
  final String? patientName;

  @override
  State<PatientDeletePage> createState() => _PatientDeletePageState();
}

class _PatientDeletePageState extends State<PatientDeletePage> {
  late ViewModel viewModel;
  late AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
    l10n = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return AlertDialog(
          icon: const Icon(Icons.warning),
          title: Text(l10n.deleteThing(l10n.patient)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.patientName != null
                  ? l10n.deleteQuestion(widget.patientName!)
                  : l10n.deleteQuestion(l10n.patient),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.actionIsIrreversible,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: viewModel.loading ? null : () async {
                bool success = await viewModel.delete(id: widget.id);
                
                if (success && context.mounted) {
                  context.pop(true);
                }
              },
              child: viewModel.loading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(l10n.deleting),
                    ],
                  )
                : Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}
