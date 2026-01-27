import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
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
    switch (valueType) {
      case ValueType.nUMERIC:
      case ValueType.numeric:
        return l10n.valueTypeNumeric;
      case ValueType.tEXT:
      case ValueType.text:
        return l10n.valueTypeText;
      case ValueType.bOOLEAN:
      case ValueType.boolean:
        return l10n.valueTypeBoolean;
    }
  }
  
  String formatTimestamp(num timestamp) {
    try {
      final date = timestamp > 9999999999 
        ? DateTime.fromMillisecondsSinceEpoch(timestamp.toInt())
        : DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
      
      final months = [
        'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
        'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
      ];
      
      return '${date.day} de ${months[date.month - 1]} de ${date.year}';
    } catch (e) {
      return timestamp.toString();
    }
  }

  void _showAddIndicatorDialog() {
    final l10n = AppLocalizations.of(context)!;
    final indicatorNameController = TextEditingController();
    final indicatorUnitController = TextEditingController();
    final indicatorRangeController = TextEditingController();
    ValueType selectedValueType = ValueType.numeric;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.addIndicator),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  labelText: l10n.name,
                  controller: indicatorNameController,
                  isDense: true,
                  fieldLength: FormFieldLength.name,
                  counterText: "",
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ValueType>(
                  value: selectedValueType,
                  decoration: InputDecoration(
                    labelText: l10n.valueType,
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    ValueType.numeric,
                    ValueType.text,
                    ValueType.boolean
                  ].map((ValueType type) {
                    return DropdownMenuItem<ValueType>(
                      value: type,
                      child: Text(getValueTypeLabel(context, type)),
                    );
                  }).toList(),
                  onChanged: (ValueType? newValue) {
                    if (newValue != null) {
                      setDialogState(() {
                        selectedValueType = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  labelText: l10n.unit,
                  controller: indicatorUnitController,
                  isDense: true,
                  fieldLength: FormFieldLength.name,
                  counterText: "",
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  labelText: l10n.normalRange,
                  controller: indicatorRangeController,
                  isDense: true,
                  fieldLength: FormFieldLength.name,
                  counterText: "",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FilledButton(
              child: Text(l10n.add),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        // Mostrar error si ocurrió
        if (viewModel.error && !viewModel.loading) {
          return ContentDialog(
            icon: Icons.error_outline,
            title: l10n.somethingWentWrong,
            loading: false,
            form: Form(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.somethingWentWrong),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.pop(false),
                      child: Text(l10n.cancel),
                    ),
                  ],
                ),
              ),
            ),
            actions: [],
          );
        }
        
        // Mostrar loading mientras carga datos iniciales
        if (!_controllersInitialized || viewModel.currentExamTemplate == null) {
          return ContentDialog(
            icon: Icons.assignment_outlined,
            title: l10n.updateThing(l10n.examTemplate),
            loading: true,
            form: Form(child: const Center(child: CircularProgressIndicator())),
            actions: [],
          );
        }
        
        // Formulario con datos prellenados
        return ContentDialog(
          icon: Icons.assignment_outlined,
          title: l10n.updateThing(l10n.examTemplate),
          loading: viewModel.loading,
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información no editable
                  Card(
                    color: Theme.of(context).colorScheme.surfaceBright,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.nonEditableInformation,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${l10n.created}: ',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  formatTimestamp(viewModel.currentExamTemplate!.created),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${l10n.updated}: ',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  formatTimestamp(viewModel.currentExamTemplate!.updated),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Campos editables
                  CustomTextFormField(
                    labelText: l10n.name,
                    controller: nameController,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.name = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    labelText: l10n.description,
                    controller: descriptionController,
                    isDense: true,
                    fieldLength: FormFieldLength.description,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.description = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Sección de indicadores
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.indicators,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l10n.addIndicator),
                        onPressed: _showAddIndicatorDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (viewModel.input.indicators == null || viewModel.input.indicators!.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          l10n.noRegisteredThings(l10n.indicators),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
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
                          child: ListTile(
                            dense: true,
                            title: Text(indicator.name),
                            subtitle: Text(
                              '${getValueTypeLabel(context, indicator.valueType)} • ${indicator.unit ?? ''} • ${indicator.normalRange ?? ''}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
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
                      Text(l10n.updateThing(l10n.examTemplate)),
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
