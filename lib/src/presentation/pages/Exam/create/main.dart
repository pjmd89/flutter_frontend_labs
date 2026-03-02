import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart'; 
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          l10n.createThing(l10n.exam), 
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.loadingData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Área de contenido desplazable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // EXAM TEMPLATE
                        _buildLabel(context, Icons.description, l10n.examTemplate),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<ExamTemplate>(
                          value: selectedExamTemplate,
                          isExpanded: true,
                          dropdownColor: colorScheme.surfaceContainerHigh,
                          decoration: _inputDecoration(context, l10n.examTemplate, null),
                          items: viewModel.examTemplates.map((template) {
                            return DropdownMenuItem(
                              value: template, 
                              child: Text(template.name, overflow: TextOverflow.ellipsis)
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedExamTemplate = newValue;
                              viewModel.input.template = newValue?.id ?? '';
                            });
                          },
                          validator: (value) => value == null ? l10n.emptyFieldError : null,
                        ),
                        const SizedBox(height: 6),
                        _buildSubtext(context, "Ej: Hemograma completo, Perfil lipídico..."),

                        const SizedBox(height: 32),

                        // LABORATORY
                        _buildLabel(context, Icons.biotech, l10n.laboratory),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<Laboratory>(
                          value: selectedLaboratory,
                          isExpanded: true,
                          dropdownColor: colorScheme.surfaceContainerHigh,
                          decoration: _inputDecoration(context, l10n.laboratory, null),
                          items: viewModel.laboratories.map((lab) {
                            return DropdownMenuItem(
                              value: lab, 
                              child: Text(lab.company?.name ?? lab.id, overflow: TextOverflow.ellipsis)
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedLaboratory = newValue;
                              viewModel.input.laboratory = newValue?.id ?? '';
                            });
                          },
                          validator: (value) => value == null ? l10n.emptyFieldError : null,
                        ),

                        const SizedBox(height: 32),

                        // BASE COST
                        _buildLabel(context, Icons.payments, l10n.baseCost),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: baseCostController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: _inputDecoration(context, l10n.baseCost, null).copyWith(
                            prefixText: "\$ ",
                            prefixStyle: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                          ),
                          onChanged: (value) {
                            viewModel.input.baseCost = num.tryParse(value) ?? 0;
                          },
                          validator: (value) {
                            final n = num.tryParse(value ?? '');
                            if (n == null || n <= 0) return "El costo debe ser mayor a cero";
                            return null;
                          },
                        ),

                        const SizedBox(height: 40),

                        // INFO BOX INTEGRADA
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline, color: colorScheme.primary, size: 22),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "Una vez creado, el laboratorio y la plantilla serán de solo lectura. Solo el costo base podrá ajustarse posteriormente.",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Barra de acciones inferior (fija)
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.1)),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
                        ),
                        onPressed: () => context.pop(),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        onPressed: viewModel.loading ? null : _handleSave,
                        child: viewModel.loading
                            ? SizedBox(
                                width: 24, 
                                height: 24, 
                                child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary)
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.save_rounded, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    l10n.createThing(l10n.exam), 
                                    style: const TextStyle(fontWeight: FontWeight.bold)
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- MÉTODOS DE APOYO ---

  Future<void> _handleSave() async {
    if (formKey.currentState!.validate()) {
      var isErr = await viewModel.create();
      if (!isErr) {
        if (!mounted) return;
        context.pop(true);
      }
    }
  }

  Widget _buildLabel(BuildContext context, IconData icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 10),
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtext(BuildContext context, String text) {
    return Text(
      text, 
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String label, IconData? suffix) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InputDecoration(
      hintText: label,
      filled: true,
      fillColor: theme.brightness == Brightness.dark 
          ? colorScheme.surfaceContainerHighest.withOpacity(0.3) 
          : colorScheme.surfaceVariant.withOpacity(0.2),
      suffixIcon: suffix != null ? Icon(suffix, size: 20) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    );
  }
}