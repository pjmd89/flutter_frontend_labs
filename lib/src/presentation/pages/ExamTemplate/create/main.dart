import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import './view_model.dart';

class ExamTemplateCreatePage extends StatefulWidget {
  const ExamTemplateCreatePage({super.key});

  @override
  State<ExamTemplateCreatePage> createState() => _ExamTemplateCreatePageState();
}

class _ExamTemplateCreatePageState extends State<ExamTemplateCreatePage> {
  late ViewModel viewModel;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String getValueTypeLabel(BuildContext context, ValueType valueType) {
    final l10n = AppLocalizations.of(context)!;
    // Normalizar a mayúsculas para manejar valores legacy en minúsculas
    switch (valueType.normalize()) {
      case ValueType.nUMERIC:
        return l10n.valueTypeNumeric;
      case ValueType.tEXT:
        return l10n.valueTypeText;
      case ValueType.bOOLEAN:
        return l10n.valueTypeBoolean;
      default:
        return l10n.valueTypeText;
    }
  }

  void _showAddIndicatorDialog() {
    final l10n = AppLocalizations.of(context)!;
    final indicatorNameController = TextEditingController();
    final indicatorUnitController = TextEditingController();
    final indicatorRangeController = TextEditingController();
    ValueType selectedValueType = ValueType.nUMERIC;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.add_circle_outline, color: theme.primaryColor),
              const SizedBox(width: 8),
              Text(l10n.addIndicator),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField(
                  l10n.name,
                  l10n.name,
                  context,
                  controller: indicatorNameController,
                  icon: Icons.science,
                ),
                const SizedBox(height: 16),
                _buildDialogDropdown(
                  l10n.valueType,
                  selectedValueType,
                  context,
                  onChanged: (ValueType? newValue) {
                    if (newValue != null) {
                      setDialogState(() {
                        selectedValueType = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  l10n.unit,
                  l10n.unit,
                  context,
                  controller: indicatorUnitController,
                  icon: Icons.straighten,
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  l10n.normalRange,
                  l10n.normalRange,
                  context,
                  controller: indicatorRangeController,
                  icon: Icons.analytics_outlined,
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.check, size: 18),
              label: Text(l10n.add),
              onPressed: () {
                if (indicatorNameController.text.isNotEmpty) {
                  final newIndicator = CreateExamIndicator(
                    name: indicatorNameController.text,
                    valueType: selectedValueType,
                    unit: indicatorUnitController.text,
                    normalRange: indicatorRangeController.text,
                  );
                  setState(() {
                    viewModel.input.indicators = [
                      ...viewModel.input.indicators,
                      newIndicator,
                    ];
                  });
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTextField(
    String label,
    String hint,
    BuildContext context, {
    TextEditingController? controller,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fieldBg = theme.inputDecorationTheme.fillColor ?? 
        (isDark ? theme.scaffoldBackgroundColor : theme.cardColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 18) : null,
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogDropdown(
    String label,
    ValueType selectedValue,
    BuildContext context, {
    required Function(ValueType?) onChanged,
  }) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fieldBg = theme.inputDecorationTheme.fillColor ?? 
        (isDark ? theme.scaffoldBackgroundColor : theme.cardColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ValueType>(
              value: selectedValue,
              isExpanded: true,
              items: [
                ValueType.nUMERIC,
                ValueType.tEXT,
                ValueType.bOOLEAN,
              ].map((ValueType type) {
                return DropdownMenuItem<ValueType>(
                  value: type,
                  child: Text(
                    getValueTypeLabel(context, type),
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.createThing(l10n.examTemplate)),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(l10n.examTemplate, Icons.assignment_outlined, context),
                  const SizedBox(height: 16),
                  _buildTextField(
                    l10n.name,
                    l10n.name,
                    context,
                    controller: nameController,
                    onChanged: (value) => viewModel.input.name = value,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    l10n.description,
                    l10n.description,
                    context,
                    controller: descriptionController,
                    onChanged: (value) => viewModel.input.description = value,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  Divider(color: Theme.of(context).dividerColor),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle(l10n.indicators, Icons.list_alt, context),
                      FilledButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l10n.addIndicator),
                        onPressed: _showAddIndicatorDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (viewModel.input.indicators.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.list_alt,
                              size: 48,
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.noRegisteredThings(l10n.indicators),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.input.indicators.length,
                      itemBuilder: (context, index) {
                        final indicator = viewModel.input.indicators[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Theme.of(context).dividerColor),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(
                              indicator.name,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${getValueTypeLabel(context, indicator.valueType)} • ${indicator.unit ?? ''} • ${indicator.normalRange ?? ''}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              onPressed: () {
                                setState(() {
                                  final newList = List<CreateExamIndicator>.from(
                                    viewModel.input.indicators,
                                  );
                                  newList.removeAt(index);
                                  viewModel.input.indicators = newList;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(l10n.cancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: viewModel.loading ? null : () async {
                            if (formKey.currentState!.validate()) {
                              var isErr = await viewModel.create();

                              if (!isErr) {
                                if (!context.mounted) return;
                                context.pop(true);
                              }
                            }
                          },
                          icon: viewModel.loading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.save, size: 18),
                          label: Text(l10n.createThing(l10n.examTemplate)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 10,
                            shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title, IconData icon, BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = theme.textTheme.bodyLarge?.color ?? theme.primaryColor;
    return Row(
      children: [
        Icon(icon, size: 16, color: titleColor),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: titleColor,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    BuildContext context, {
    TextEditingController? controller,
    Function(String)? onChanged,
    IconData? icon,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fieldBg = theme.inputDecorationTheme.fillColor ?? 
        (isDark ? theme.scaffoldBackgroundColor : theme.cardColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 18) : null,
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
          ),
        ),
      ],
    );
  }
}
