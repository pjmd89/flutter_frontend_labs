import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';

class ExamUpdatePage extends StatefulWidget {
  const ExamUpdatePage({super.key, required this.exam});
  final Exam exam;

  @override
  State<ExamUpdatePage> createState() => _ExamUpdatePageState();
}

class _ExamUpdatePageState extends State<ExamUpdatePage> {
  late ViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Controller para el único campo editable
  late TextEditingController baseCostController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, exam: widget.exam);
    
    // Inicializar controller con valor existente
    baseCostController = TextEditingController(
      text: widget.exam.baseCost.toString()
    );
  }

  @override
  void dispose() {
    baseCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.medical_services,
          title: l10n.updateThing(l10n.exam),
          loading: viewModel.loading,
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de información no editable
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.nonEditableInformation,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 12),
                          _buildReadOnlyField(
                            l10n.examTemplate,
                            widget.exam.template?.name ?? l10n.noDataAvailable,
                          ),
                          const SizedBox(height: 8),
                          _buildReadOnlyField(
                            l10n.templateDescription,
                            widget.exam.template?.description ?? '-',
                          ),
                          const SizedBox(height: 8),
                          _buildReadOnlyField(
                            l10n.laboratory,
                            widget.exam.laboratory != null 
                              ? '${widget.exam.laboratory!.company?.name} - ${widget.exam.laboratory!.address}'
                              : l10n.noDataAvailable,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo editable: baseCost
                  CustomTextFormField(
                    labelText: l10n.baseCost,
                    controller: baseCostController,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.fieldRequired;
                      }
                      final number = num.tryParse(value);
                      if (number == null) {
                        return l10n.invalidNumber;
                      }
                      if (number < 0) {
                        return l10n.mustBePositive;
                      }
                      return null;
                    },
                    onChange: (value) {
                      final number = num.tryParse(value);
                      if (number != null) {
                        viewModel.input.baseCost = number;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(l10n.cancel),
                  onPressed: () => context.pop(false),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: viewModel.loading ? null : () async {
                    if (formKey.currentState!.validate()) {
                      var isErr = await viewModel.update();
                      
                      if (!isErr) {
                        if (!context.mounted) return;
                        context.pop(true);
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.updateThing(l10n.exam)),
                      const SizedBox(width: 8),
                      if (viewModel.loading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      else
                        const Icon(Icons.save, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildReadOnlyField(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
