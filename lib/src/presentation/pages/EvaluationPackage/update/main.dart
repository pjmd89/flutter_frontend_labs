import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/custom_text_form_field.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/utils/form_field_length/main.dart';
import './view_model.dart';

class EvaluationPackageUpdatePage extends StatefulWidget {
  const EvaluationPackageUpdatePage({super.key, required this.evaluationPackage});
  final EvaluationPackage evaluationPackage;

  @override
  State<EvaluationPackageUpdatePage> createState() => _EvaluationPackageUpdatePageState();
}

class _EvaluationPackageUpdatePageState extends State<EvaluationPackageUpdatePage> {
  late ViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final List<TextEditingController> observationControllers = [];
  // Map: examIndex -> List<TextEditingController> para cada indicador
  final Map<int, List<TextEditingController>> examValueControllers = {};
  bool allResultsCompleted = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(
      context: context,
      evaluationPackage: widget.evaluationPackage,
    );
    
    // Inicializar controllers de observaciones
    if (observationControllers.isEmpty) {
      if (widget.evaluationPackage.observations.isNotEmpty) {
        for (var observation in widget.evaluationPackage.observations) {
          observationControllers.add(TextEditingController(text: observation));
        }
      } else {
        observationControllers.add(TextEditingController());
      }
    }
    
    // Inicializar controllers de valores de exámenes
    if (examValueControllers.isEmpty) {
      for (var i = 0; i < widget.evaluationPackage.valuesByExam.length; i++) {
        final examResult = widget.evaluationPackage.valuesByExam[i];
        final controllers = <TextEditingController>[];
        
        for (var indicatorValue in examResult.indicatorValues) {
          controllers.add(TextEditingController(text: indicatorValue.value));
        }
        
        examValueControllers[i] = controllers;
      }
    }
    
    // Prellenar estado de completitud
    allResultsCompleted = widget.evaluationPackage.status == ResultStatus.completed;
  }
  
  @override
  void dispose() {
    for (var controller in observationControllers) {
      controller.dispose();
    }
    for (var controllers in examValueControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }
  
  void _addObservationField() {
    setState(() {
      observationControllers.add(TextEditingController());
    });
  }
  
  void _removeObservationField(int index) {
    setState(() {
      observationControllers[index].dispose();
      observationControllers.removeAt(index);
      
      // Actualizar input
      viewModel.input.observations = observationControllers
        .map((c) => c.text)
        .where((text) => text.isNotEmpty)
        .toList();
    });
  }
  
  void _updateExamValues() {
    // Actualizar valuesByExam en el input con los valores de los controllers
    final examResults = <ExamResultInput>[];
    
    for (var i = 0; i < widget.evaluationPackage.valuesByExam.length; i++) {
      final examResult = widget.evaluationPackage.valuesByExam[i];
      final controllers = examValueControllers[i];
      
      if (controllers != null) {
        final indicatorValues = <SetIndicatorValue>[];
        
        for (var j = 0; j < controllers.length; j++) {
          indicatorValues.add(SetIndicatorValue(
            indicatorIndex: j,
            value: controllers[j].text,
          ));
        }
        
        examResults.add(ExamResultInput(
          exam: examResult.exam?.id ?? '',
          indicatorValues: indicatorValues,
        ));
      }
    }
    
    viewModel.input.valuesByExam = examResults;
  }
  
  String getStatusLabel(BuildContext context, ResultStatus? status) {
    final l10n = AppLocalizations.of(context)!;
    if (status == null) return l10n.status;
    switch (status) {
      case ResultStatus.pending:
        return 'Pendiente';
      case ResultStatus.inProgress:
        return 'En Progreso';
      case ResultStatus.completed:
        return 'Completado';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.assessment,
          title: l10n.updateThing(l10n.evaluationPackage),
          loading: viewModel.loading,
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de información no editable
                  if (viewModel.currentEvaluationPackage != null) ...[
                    Card(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.nonEditableInformation,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildReadOnlyField(
                              l10n.status,
                              getStatusLabel(context, viewModel.currentEvaluationPackage!.status),
                            ),
                            _buildReadOnlyField(
                              l10n.referred,
                              viewModel.currentEvaluationPackage!.referred.isEmpty
                                ? 'N/A'
                                : viewModel.currentEvaluationPackage!.referred,
                            ),
                            _buildReadOnlyField(
                              l10n.examsCount,
                              viewModel.currentEvaluationPackage!.valuesByExam.length.toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Sección de valores de exámenes
                  if (viewModel.currentEvaluationPackage!.valuesByExam.isNotEmpty) ...[
                    Text(
                      l10n.examResults,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    
                    ...List.generate(
                      viewModel.currentEvaluationPackage!.valuesByExam.length,
                      (examIndex) {
                        final examResult = viewModel.currentEvaluationPackage!.valuesByExam[examIndex];
                        final controllers = examValueControllers[examIndex] ?? [];
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.science_outlined,
                                      color: Theme.of(context).colorScheme.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        examResult.exam?.template?.name ?? 'Examen #${examIndex + 1}',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                
                                // Campos para cada indicador (solo edición de valores)
                                ...List.generate(
                                  examResult.indicatorValues.length,
                                  (indicatorIndex) {
                                    final indicatorValue = examResult.indicatorValues[indicatorIndex];
                                    final indicator = indicatorValue.indicator;
                                    
                                    if (indicatorIndex >= controllers.length) {
                                      return const SizedBox.shrink();
                                    }
                                    
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: CustomTextFormField(
                                        labelText: '${indicator?.name ?? 'Indicador ${indicatorIndex + 1}'} ${indicator?.unit != null ? '(${indicator!.unit})' : ''}',
                                        controller: controllers[indicatorIndex],
                                        isDense: true,
                                        fieldLength: FormFieldLength.name,
                                        counterText: "",
                                        onChange: (value) {
                                          _updateExamValues();
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return l10n.fieldRequired;
                                          }
                                          return null;
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16),
                  ],
                  
                  // Switch de completitud
                  SwitchListTile(
                    title: Text(l10n.allResultsCompleted),
                    subtitle: Text(l10n.allResultsCompletedDescription),
                    value: allResultsCompleted,
                    onChanged: (bool value) {
                      setState(() {
                        allResultsCompleted = value;
                        viewModel.input.allResultsCompleted = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Sección de observaciones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.observations,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l10n.addObservation),
                        onPressed: _addObservationField,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  if (observationControllers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          l10n.noObservations,
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
                      itemCount: observationControllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  labelText: '${l10n.observation} ${index + 1}',
                                  controller: observationControllers[index],
                                  isDense: true,
                                  fieldLength: FormFieldLength.name,
                                  counterText: "",
                                  onChange: (value) {
                                    viewModel.input.observations = observationControllers
                                      .map((c) => c.text)
                                      .where((text) => text.isNotEmpty)
                                      .toList();
                                  },
                                ),
                              ),
                              if (observationControllers.length > 1) ...[
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => _removeObservationField(index),
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ],
                            ],
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
                  onPressed: () => context.pop(false),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: viewModel.loading
                    ? null
                    : () async {
                      if (formKey.currentState!.validate()) {
                        // Actualizar valores de exámenes antes de guardar
                        _updateExamValues();
                        
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
                      Text(l10n.updateThing(l10n.evaluationPackage)),
                      if (viewModel.loading) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.save, size: 18),
                      ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
      ),
    );
  }
}
