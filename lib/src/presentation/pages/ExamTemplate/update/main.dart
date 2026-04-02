import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import './view_model.dart';

class ExamTemplateUpdatePage extends StatefulWidget {
  const ExamTemplateUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<ExamTemplateUpdatePage> createState() => _ExamTemplateUpdatePageState();
}

class _ExamTemplateUpdatePageState extends State<ExamTemplateUpdatePage> {
  late ViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Controllers para campos editables
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, examTemplateId: widget.id);
    
    // Escuchar cambios del ViewModel para inicializar controllers
    viewModel.addListener(_updateControllers);
  }
  
  void _updateControllers() {
    // Inicializar controllers cuando los datos se carguen
    if (viewModel.currentExamTemplate != null && !viewModel.loading && !_controllersInitialized) {
      setState(() {
        nameController = TextEditingController(
          text: viewModel.currentExamTemplate!.name
        );
        descriptionController = TextEditingController(
          text: viewModel.currentExamTemplate!.description
        );
        _controllersInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    viewModel.removeListener(_updateControllers);
    if (_controllersInitialized) {
      nameController.dispose();
      descriptionController.dispose();
    }
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
  
  String formatTimestamp(num timestamp) {
    try {
      final date = timestamp > 9999999999 
        ? DateTime.fromMillisecondsSinceEpoch(timestamp.toInt())
        : DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
      
      final l10n = AppLocalizations.of(context)!;
      final months = [
        l10n.january, l10n.february, l10n.march, l10n.april, 
        l10n.may, l10n.june, l10n.july, l10n.august, 
        l10n.september, l10n.october, l10n.november, l10n.december
      ];
      
      final locale = Localizations.localeOf(context).languageCode;
      
      if (locale == 'es') {
        return '${date.day} de ${months[date.month - 1]} de ${date.year}';
      } else {
        return '${months[date.month - 1]} ${date.day}, ${date.year}';
      }
    } catch (e) {
      return timestamp.toString();
    }
  }

  Future<void> _handleSave() async {
    if (formKey.currentState!.validate()) {
      final isErr = await viewModel.update();
      if (!isErr && context.mounted) {
        context.pop(true);
      }
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
                      ...viewModel.input.indicators ?? [],
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(l10n.updateThing(l10n.examTemplate)),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          // Mostrar error si ocurrió
          if (viewModel.error && !viewModel.loading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.somethingWentWrong,
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.pop(false),
                    child: Text(l10n.cancel),
                  ),
                ],
              ),
            );
          }
          
          // Mostrar loading mientras carga datos iniciales
          if (!_controllersInitialized || viewModel.currentExamTemplate == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
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
              Row(
                children: [
                  Icon(Icons.assignment_outlined, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.examTemplate.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.updateExamTemplateData,
                style: textTheme.bodyMedium,
              ),
              const Divider(height: 48),
              
              // Nombre
              _buildTextField(
                l10n.name,
                l10n.name,
                context,
                controller: nameController,
                onChanged: (value) => viewModel.input.name = value,
              ),
              const SizedBox(height: 16),
              
              // Descripción
              _buildTextField(
                l10n.description,
                l10n.description,
                context,
                controller: descriptionController,
                onChanged: (value) => viewModel.input.description = value,
                maxLines: 3,
              ),
              
              const SizedBox(height: 32),
              const Divider(height: 32),
              
              // Sección de indicadores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.list_alt, size: 20, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n.indicators.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  FilledButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.addIndicator),
                    onPressed: _showAddIndicatorDialog,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (viewModel.input.indicators == null || viewModel.input.indicators!.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.list_alt,
                          size: 48,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.noRegisteredThings(l10n.indicators),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
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
                  itemCount: viewModel.input.indicators!.length,
                  itemBuilder: (context, index) {
                    final indicator = viewModel.input.indicators![index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: colorScheme.outlineVariant),
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
                            style: textTheme.bodySmall,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: colorScheme.error,
                          ),
                          onPressed: () {
                            setState(() {
                              final newList = List<CreateExamIndicator>.from(
                                viewModel.input.indicators ?? [],
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
                Text(
                  l10n.referenceData,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _readOnlyInfo(
                  l10n.created,
                  formatTimestamp(viewModel.currentExamTemplate!.created),
                  textTheme,
                  Icons.calendar_today_outlined,
                ),
                const SizedBox(height: 20),
                _readOnlyInfo(
                  l10n.updated,
                  formatTimestamp(viewModel.currentExamTemplate!.updated),
                  textTheme,
                  Icons.update_outlined,
                ),
                const SizedBox(height: 20),
                _readOnlyInfo(
                  l10n.indicators,
                  '${viewModel.currentExamTemplate!.indicators.length}',
                  textTheme,
                  Icons.list_alt,
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
              OutlinedButton(
                onPressed: () => context.pop(),
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 12),
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
        ),
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
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: textTheme.bodySmall?.color,
                ),
              ),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
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
