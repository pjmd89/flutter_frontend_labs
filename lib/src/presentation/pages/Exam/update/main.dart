import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
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
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, exam: widget.exam);
    
    // Inicializar controller con valor existente
    if (!_controllersInitialized) {
      baseCostController = TextEditingController(
        text: widget.exam.baseCost.toString()
      );
      _controllersInitialized = true;
    }
  }

  @override
  void dispose() {
    if (_controllersInitialized) {
      baseCostController.dispose();
    }
    super.dispose();
  }
  
  Future<void> _handleSave() async {
    if (formKey.currentState!.validate()) {
      final isErr = await viewModel.update();
      if (!isErr && context.mounted) {
        context.pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(l10n.updateThing(l10n.exam)),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          // Formulario con datos prellenados
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 9, child: _buildMainForm(l10n, colorScheme, textTheme)),
                        const SizedBox(width: 24),
                        Expanded(flex: 5, child: _buildSidePanel(l10n, colorScheme, textTheme)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildMainForm(l10n, colorScheme, textTheme),
                        const SizedBox(height: 24),
                        _buildSidePanel(l10n, colorScheme, textTheme),
                      ],
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainForm(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.examInformation, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l10n.updateExamData, style: textTheme.bodyMedium),
              const Divider(height: 48),
              
              // Campo editable: baseCost
              CustomTextFormField(
                labelText: l10n.baseCost,
                controller: baseCostController,
                isDense: true,
                fieldLength: 20,
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
    );
  }

  Widget _buildSidePanel(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        Card(
          elevation: 0,
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.nonEditableInformation, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _readOnlyInfo(
                  l10n.examTemplate,
                  widget.exam.template?.name ?? l10n.noDataAvailable,
                  textTheme,
                  Icons.description_outlined
                ),
                const SizedBox(height: 20),
                _readOnlyInfo(
                  l10n.templateDescription,
                  widget.exam.template?.description ?? '-',
                  textTheme,
                  Icons.notes_outlined
                ),
                const SizedBox(height: 20),
                _readOnlyInfo(
                  l10n.laboratory,
                  widget.exam.laboratory != null 
                    ? '${widget.exam.laboratory!.company?.name ?? ''} - ${widget.exam.laboratory!.address}'
                    : l10n.noDataAvailable,
                  textTheme,
                  Icons.biotech_outlined
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Botones de acción
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Botón Cancelar
              OutlinedButton(
                onPressed: () => context.pop(),
                child: Text(l10n.cancel),
              ),
              
              const SizedBox(width: 12),
              
              // Botón Guardar o Loader
              viewModel.loading
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: _handleSave,
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: Text(l10n.save),
                    ),
            ],
          ),
        )
      ],
    );
  }

  Widget _readOnlyInfo(String label, String value, TextTheme textTheme, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: textTheme.bodySmall?.color?.withOpacity(0.6)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: textTheme.labelMedium?.copyWith(color: textTheme.bodySmall?.color)),
              Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
