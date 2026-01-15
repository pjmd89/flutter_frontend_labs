import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';

class ExamCreatePage extends StatefulWidget {
  const ExamCreatePage({super.key});

  @override
  State<ExamCreatePage> createState() => _ExamCreatePageState();
}

class _ExamCreatePageState extends State<ExamCreatePage> {
  late ViewModel viewModel;
  final baseCostController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  ExamTemplate? selectedExamTemplate;
  Laboratory? selectedLaboratory;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
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
        // Mostrar loading mientras se cargan los datos iniciales
        if (viewModel.loadingData) {
          return ContentDialog(
            icon: Icons.medical_services,
            title: l10n.createThing(l10n.exam),
            loading: true,
            form: Form(
              key: formKey,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            actions: [],
          );
        }

        return ContentDialog(
          icon: Icons.medical_services,
          title: l10n.createThing(l10n.exam),
          loading: viewModel.loading,
          form: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ExamTemplate>(
                  value: selectedExamTemplate,
                  decoration: InputDecoration(
                    labelText: l10n.examTemplate,
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  items: viewModel.examTemplates.map((ExamTemplate template) {
                    return DropdownMenuItem<ExamTemplate>(
                      value: template,
                      child: Text(template.name),
                    );
                  }).toList(),
                  onChanged: (ExamTemplate? newValue) {
                    setState(() {
                      selectedExamTemplate = newValue;
                      viewModel.input.template = newValue?.id ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return l10n.emptyFieldError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Laboratory>(
                  value: selectedLaboratory,
                  decoration: InputDecoration(
                    labelText: l10n.laboratory,
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  items: viewModel.laboratories.map((Laboratory lab) {
                    return DropdownMenuItem<Laboratory>(
                      value: lab,
                      child: Text(lab.company?.name ?? lab.id),
                    );
                  }).toList(),
                  onChanged: (Laboratory? newValue) {
                    setState(() {
                      selectedLaboratory = newValue;
                      viewModel.input.laboratory = newValue?.id ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return l10n.emptyFieldError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  labelText: l10n.baseCost,
                  controller: baseCostController,
                  isDense: true,
                  fieldLength: FormFieldLength.name,
                  counterText: "",
                  onChange: (value) {
                    viewModel.input.baseCost = num.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(l10n.cancel),
                  onPressed: () {
                    context.pop();
                  },
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: viewModel.loading ? null : () async {
                    if (formKey.currentState!.validate()) {
                      var isErr = await viewModel.create();
                      
                      if (!isErr) {
                        if (!context.mounted) return;
                        context.pop(true);
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.createThing(l10n.exam)),
                      const SizedBox(width: 8),
                      viewModel.loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
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
}
