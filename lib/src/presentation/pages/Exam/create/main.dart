import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        title: Text(l10n.createThing(l10n.exam)),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.loadingData) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // EXAM TEMPLATE
                  _sectionTitle(l10n.examTemplate, Icons.description, context),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: l10n.examTemplate,
                    hint: "Ej: Hemograma completo, Perfil lipídico...",
                    context: context,
                    value: selectedExamTemplate,
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

                  const SizedBox(height: 32),

                  // LABORATORY
                  _sectionTitle(l10n.laboratory, Icons.biotech, context),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: l10n.laboratory,
                    hint: l10n.laboratory,
                    context: context,
                    value: selectedLaboratory,
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
                  _sectionTitle(l10n.baseCost, Icons.payments, context),
                  const SizedBox(height: 16),
                  _buildTextField(
                    l10n.baseCost,
                    "0.00",
                    context,
                    prefix: "\$",
                    controller: baseCostController,
                    onChanged: (value) {
                      viewModel.input.baseCost = num.tryParse(value) ?? 0;
                    },
                    validator: (value) {
                      final n = num.tryParse(value ?? '');
                      if (n == null || n <= 0) return "El costo debe ser mayor a cero";
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),
                  Divider(color: theme.dividerColor),
                  const SizedBox(height: 16),

                  // INFO BOX
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Una vez creado, el laboratorio y la plantilla serán de solo lectura. Solo el costo base podrá ajustarse posteriormente.",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(l10n.cancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: viewModel.loading ? null : _handleSave,
                          icon: viewModel.loading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                )
                              : const Icon(Icons.save, size: 18),
                          label: Text(l10n.createThing(l10n.exam)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 10,
                            shadowColor: theme.primaryColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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

  Widget _sectionTitle(String title, IconData icon, BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = theme.textTheme.bodyLarge?.color ?? theme.primaryColor;
    return Row(
      children: [
        Icon(icon, size: 16, color: titleColor),
        const SizedBox(width: 8),
        Text(title.toUpperCase(), 
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: titleColor, letterSpacing: 1.2)),
      ],
    );
  }

  Widget _buildTextField(
    String label, 
    String hint, 
    BuildContext context,
    {
      IconData? icon, 
      String? prefix, 
      TextEditingController? controller, 
      Function(String)? onChanged,
      String? Function(String?)? validator,
    }
  ) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fieldBg = theme.inputDecorationTheme.fillColor ?? (isDark ? theme.scaffoldBackgroundColor : theme.cardColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          keyboardType: prefix != null ? const TextInputType.numberWithOptions(decimal: true) : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 18) : (prefix != null ? Padding(padding: const EdgeInsets.all(12), child: Text(prefix)) : null),
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.dividerColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required String hint,
    required BuildContext context,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fieldBg = theme.inputDecorationTheme.fillColor ?? (isDark ? theme.scaffoldBackgroundColor : theme.cardColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            items: items,
            onChanged: onChanged,
            validator: validator,
          ),
        ),
        if (hint.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(hint, style: TextStyle(fontSize: 11, color: theme.hintColor)),
        ],
      ],
    );
  }
}