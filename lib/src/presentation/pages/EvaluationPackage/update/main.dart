import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agile_front/agile_front.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/custom_text_form_field.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/utils/form_field_length/main.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import './view_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' show HTMLInputElement, FileReader;
import 'dart:js_interop';

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
  final Map<int, List<TextEditingController>> examValueControllers = {};
  bool allResultsCompleted = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(
      context: context,
      evaluationPackage: widget.evaluationPackage,
    );
    
    if (observationControllers.isEmpty) {
      if (widget.evaluationPackage.observations.isNotEmpty) {
        for (var observation in widget.evaluationPackage.observations) {
          observationControllers.add(TextEditingController(text: observation));
        }
      } else {
        observationControllers.add(TextEditingController());
      }
    }
    
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
    
    allResultsCompleted = widget.evaluationPackage.status == ResultStatus.cOMPLETED;
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
      
      viewModel.input.observations = observationControllers
        .map((c) => c.text)
        .where((text) => text.isNotEmpty)
        .toList();
    });
  }
  
  void _updateExamValues() {
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
  
  Future<void> _pickAndUploadSignature(BuildContext context) async {
    try {
      final authNotifier = context.read<AuthNotifier>();
      final userId = authNotifier.id.isEmpty ? 'bioanalyst' : authNotifier.id;
      
      debugPrint('🔧 Iniciando selección de firma... (kIsWeb: $kIsWeb)');
      
      if (kIsWeb) {
        debugPrint('🌐 Usando implementación web nativa');
        
        final uploadInput = HTMLInputElement();
        uploadInput.type = 'file';
        uploadInput.accept = 'image/jpeg,image/jpg,image/png,image/gif';
        uploadInput.click();

        await Future.delayed(const Duration(milliseconds: 100));
        
        final completer = Completer<void>();
        uploadInput.addEventListener('change', ((JSAny event) {
          completer.complete();
        }).toJS);
        
        await completer.future;

        final files = uploadInput.files;
        if (files != null && files.length > 0) {
          final file = files.item(0)!;
          final reader = FileReader();
          
          final loadCompleter = Completer<void>();
          reader.addEventListener('load', ((JSAny event) {
            loadCompleter.complete();
          }).toJS);
          
          reader.readAsArrayBuffer(file);
          await loadCompleter.future;

          final result = reader.result;
          final Uint8List fileBytes = (result as JSArrayBuffer).toDart.asUint8List();
          final String fileName = file.name;

          debugPrint('📄 Archivo web: $fileName, Bytes: ${fileBytes.length}');

          final extension = fileName.split('.').last.toLowerCase();
          if (!['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Formato no válido. Usa JPG, JPEG, PNG o GIF')),
            );
            return;
          }

          final success = await viewModel.uploadBioanalystSignature(
            fileBytes: fileBytes,
            fileName: fileName,
            userId: userId,
          );

          if (success) {
            setState(() {});
          }
        } else {
          debugPrint('ℹ️ Selección de archivo cancelada');
        }
      } else {
        debugPrint('⚠️ Esta ruta solo funciona en web');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionalidad solo disponible en web')),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al seleccionar archivo: $e');
      debugPrint('💥 Tipo de error: ${e.runtimeType}');
      debugPrint('📍 StackTrace: $stackTrace');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  
  String getStatusLabel(BuildContext context, ResultStatus? status) {
    final l10n = AppLocalizations.of(context)!;
    if (status == null) return l10n.status;
    switch (status) {
      case ResultStatus.pENDING:
        return l10n.pending;
      case ResultStatus.iNPROGRESS:
        return l10n.inProgress;
      case ResultStatus.cOMPLETED:
        return l10n.completed;
    }
  }
  
  String _getValueTypeLabel(ValueType valueType, AppLocalizations l10n) {
    final normalized = valueType.normalize();
    if (normalized.isNumeric) return l10n.valueTypeNumeric;
    if (normalized.isBoolean) return l10n.valueTypeBoolean;
    return l10n.valueTypeText;
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authNotifier = context.read<AuthNotifier>();
    final isBioanalyst = authNotifier.labRole == LabMemberRole.bIOANALYST;
    final isTechnician = authNotifier.labRole == LabMemberRole.tECHNICIAN;
    final isOwner = authNotifier.userIsLabOwner;
    final canEdit = (isOwner || isTechnician) && !isBioanalyst;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: colorScheme.surfaceContainerLowest,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: colorScheme.surface,
            title: Row(
              children: [
                Icon(Icons.edit_note_outlined, size: 24, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text(l10n.updateThing(l10n.evaluationPackage)),
              ],
            ),
            actions: [
              if (viewModel.currentEvaluationPackage?.isApproved == true)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Chip(
                    avatar: Icon(Icons.verified, size: 16, color: colorScheme.primary),
                    label: Text(
                      l10n.approved,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: colorScheme.primaryContainer.withOpacity(0.5),
                    side: BorderSide.none,
                  ),
                ),
            ],
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      
                      // Layout Principal
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 8, child: _buildMainContent(l10n, colorScheme, textTheme, canEdit)),
                            const SizedBox(width: 24),
                            Expanded(flex: 4, child: _buildSidePanel(l10n, colorScheme, textTheme, isBioanalyst, canEdit)),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildMainContent(l10n, colorScheme, textTheme, canEdit),
                            const SizedBox(height: 24),
                            _buildSidePanel(l10n, colorScheme, textTheme, isBioanalyst, canEdit),
                          ],
                        ),
                      
                      const SizedBox(height: 32),
                      
                      // Botones de acción
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => context.pop(false),
                            icon: const Icon(Icons.close, size: 18),
                            label: Text(l10n.cancel),
                          ),
                          const SizedBox(width: 12),
                          
                          // Botón de aprobación
                          if (isBioanalyst && 
                              viewModel.currentEvaluationPackage?.isApproved == false &&
                              viewModel.currentEvaluationPackage?.status == ResultStatus.cOMPLETED) ...[
                            FilledButton.tonalIcon(
                              onPressed: viewModel.loading ? null : () async {
                                // ✅ Validar que haya firma antes de aprobar
                                if (!viewModel.hasSignature) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.signatureRequired)),
                                  );
                                  return;
                                }
                                
                                final shouldApprove = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      icon: Icon(Icons.verified_outlined, size: 48, color: colorScheme.primary),
                                      title: Text(l10n.approveEvaluationPackage),
                                      content: Text(l10n.approveEvaluationPackageConfirmation),
                                      actions: [
                                        TextButton(
                                          child: Text(l10n.cancel),
                                          onPressed: () => Navigator.of(context).pop(false),
                                        ),
                                        FilledButton.icon(
                                          icon: const Icon(Icons.check, size: 18),
                                          label: Text(l10n.approve),
                                          onPressed: () => Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                
                                if (shouldApprove == true) {
                                  var isErr = await viewModel.approve();
                                  if (!isErr && context.mounted) context.pop(true);
                                }
                              },
                              icon: const Icon(Icons.verified, size: 18),
                              label: Text(l10n.approve),
                            ),
                            const SizedBox(width: 12),
                          ],
                          
                          // Botón de actualizar
                          if (canEdit)
                            viewModel.loading
                              ? Container(
                                  padding: const EdgeInsets.all(12),
                                  child: const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : FilledButton.icon(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      _updateExamValues();
                                      var isErr = await viewModel.update();
                                      if (!isErr && context.mounted) context.pop(true);
                                    }
                                  },
                                  icon: const Icon(Icons.save_outlined, size: 18),
                                  label: Text(l10n.save),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme, bool canEdit) {
    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.examResultsTitle,
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.examResultsDescription,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const Divider(height: 48),
            
            // Exámenes con diseño mejorado
            if (viewModel.currentEvaluationPackage!.valuesByExam.isNotEmpty)
              ...List.generate(
                viewModel.currentEvaluationPackage!.valuesByExam.length,
                (examIndex) {
                  final examResult = viewModel.currentEvaluationPackage!.valuesByExam[examIndex];
                  final controllers = examValueControllers[examIndex] ?? [];
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header del examen
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(0.3),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.biotech_outlined,
                                  color: colorScheme.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      examResult.exam?.template?.name ?? '${l10n.exam} #${examIndex + 1}',
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${examResult.indicatorValues.length} ${l10n.indicators}',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '#${examIndex + 1}',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Indicadores
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: List.generate(
                              examResult.indicatorValues.length,
                              (indicatorIndex) {
                                final indicatorValue = examResult.indicatorValues[indicatorIndex];
                                final indicator = indicatorValue.indicator;
                                
                                if (indicatorIndex >= controllers.length) {
                                  return const SizedBox.shrink();
                                }
                                
                                final valueType = indicator?.valueType?.normalize();
                                final isBoolean = valueType?.isBoolean ?? false;
                                
                                // Si es booleano, usar un Switch
                                if (isBoolean) {
                                  // Parsear el valor actual como bool
                                  bool currentValue = controllers[indicatorIndex].text.toLowerCase() == 'true' ||
                                                      controllers[indicatorIndex].text == '1';
                                  
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: Card(
                                      elevation: 0,
                                      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    indicator?.name ?? '${l10n.indicator} ${indicatorIndex + 1}',
                                                    style: textTheme.titleSmall?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: colorScheme.tertiaryContainer,
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                        child: Text(
                                                          l10n.valueTypeBoolean,
                                                          style: textTheme.labelSmall?.copyWith(
                                                            color: colorScheme.onTertiaryContainer,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                      if (indicator?.unit != null && indicator!.unit.isNotEmpty) ...[
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          '(${indicator.unit})',
                                                          style: textTheme.bodySmall?.copyWith(
                                                            color: colorScheme.onSurfaceVariant,
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Transform.scale(
                                                  scale: 0.9,
                                                  child: Switch(
                                                    value: currentValue,
                                                    onChanged: canEdit ? (value) {
                                                      setState(() {
                                                        controllers[indicatorIndex].text = value.toString();
                                                        _updateExamValues();
                                                      });
                                                    } : null,
                                                  ),
                                                ),
                                                Text(
                                                  currentValue ? l10n.yes : l10n.no,
                                                  style: textTheme.labelSmall?.copyWith(
                                                    color: colorScheme.onSurfaceVariant,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                
                                // Para tipos TEXT y NUMERIC, usar TextField
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (valueType != null) ...[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 6),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: valueType.isNumeric 
                                                ? colorScheme.secondaryContainer 
                                                : colorScheme.tertiaryContainer,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              _getValueTypeLabel(valueType, l10n),
                                              style: textTheme.labelSmall?.copyWith(
                                                color: valueType.isNumeric
                                                  ? colorScheme.onSecondaryContainer
                                                  : colorScheme.onTertiaryContainer,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      CustomTextFormField(
                                        labelText: '${indicator?.name ?? '${l10n.indicator} ${indicatorIndex + 1}'} ${indicator?.unit != null && indicator!.unit.isNotEmpty ? '(${indicator.unit})' : ''}',
                                        controller: controllers[indicatorIndex],
                                        isDense: true,
                                        fieldLength: FormFieldLength.name,
                                        counterText: "",
                                        readOnly: !canEdit,
                                        type: valueType?.isNumeric ?? false 
                                          ? TextInputType.number 
                                          : TextInputType.text,
                                        onChange: (value) => _updateExamValues(),
                                        validator: (value) {
                                          if (canEdit && (value == null || value.isEmpty)) {
                                            return l10n.fieldRequired;
                                          }
                                          
                                          // Validar que sea numérico si el tipo es NUMERIC
                                          if (canEdit && valueType?.isNumeric == true) {
                                            final numValue = double.tryParse(value!);
                                            if (numValue == null) {
                                              return l10n.mustBeNumeric;
                                            }
                                          }
                                          
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            
            const SizedBox(height: 24),
            
            // Switch con Card mejorado
            if (canEdit) ...[
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: allResultsCompleted ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.allResultsCompleted,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              l10n.markAsCompletedDescription,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Transform.scale(
                        scale: 0.9,
                        child: Switch(
                          value: allResultsCompleted,
                          onChanged: (bool value) {
                            setState(() {
                              allResultsCompleted = value;
                              viewModel.input.allResultsCompleted = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
            
            // Observaciones
            Row(
              children: [
                Icon(Icons.note_alt_outlined, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.observations,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (canEdit)
                  TextButton.icon(
                    onPressed: _addObservationField,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.addObservation),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (observationControllers.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.note_outlined,
                        size: 48,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.noObservations,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...List.generate(
                observationControllers.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: '${l10n.observation} ${index + 1}',
                          controller: observationControllers[index],
                          isDense: true,
                          fieldLength: FormFieldLength.name,
                          counterText: "",
                          readOnly: !canEdit,
                          onChange: (value) {
                            viewModel.input.observations = observationControllers
                              .map((c) => c.text)
                              .where((text) => text.isNotEmpty)
                              .toList();
                          },
                        ),
                      ),
                      if (canEdit && observationControllers.length > 1) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.delete_sweep_outlined, color: colorScheme.error),
                          onPressed: () => _removeObservationField(index),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidePanel(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme, bool isBioanalyst, bool canEdit) {
    return Column(
      children: [
        // Mensaje según rol - estilo mejorado
        if (!canEdit && !isBioanalyst)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.tertiary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  color: colorScheme.onTertiaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.viewOnlyMode,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        if (isBioanalyst)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.bioanalystViewMode,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        // ✅ Campo de firma - SOLO para bioanalistas
        if (isBioanalyst &&
            viewModel.currentEvaluationPackage?.isApproved == false &&
            viewModel.currentEvaluationPackage?.status == ResultStatus.cOMPLETED)
          Card(
            elevation: 0,
            color: colorScheme.primaryContainer.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorScheme.primary.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.draw_outlined,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.bioanalystSignature,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  if (viewModel.hasSignature) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: colorScheme.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.displaySignatureFileName ?? l10n.signature,
                              style: textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  FilledButton.tonalIcon(
                    onPressed: viewModel.loading || viewModel.uploading
                        ? null
                        : () => _pickAndUploadSignature(context),
                    icon: viewModel.uploading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            viewModel.hasSignature ? Icons.edit : Icons.upload,
                            size: 18,
                          ),
                    label: Text(
                      viewModel.hasSignature
                          ? l10n.changeSignature
                          : l10n.uploadSignature,
                    ),
                  ),
                  
                  if (!viewModel.hasSignature) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.signatureRequired,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        
        const SizedBox(height: 16),
        
        // Información - Card mejorado
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
                  l10n.status,
                  getStatusLabel(context, viewModel.currentEvaluationPackage!.status),
                  textTheme,
                  Icons.sync_outlined,
                  colorScheme,
                ),
                const SizedBox(height: 20),
                _readOnlyInfo(
                  l10n.referred,
                  viewModel.currentEvaluationPackage!.referred.isEmpty
                      ? 'N/A'
                      : viewModel.currentEvaluationPackage!.referred,
                  textTheme,
                  Icons.person_outline,
                  colorScheme,
                ),
                const SizedBox(height: 20),
                _readOnlyInfo(
                  l10n.examsCount,
                  viewModel.currentEvaluationPackage!.valuesByExam.length.toString(),
                  textTheme,
                  Icons.science_outlined,
                  colorScheme,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _readOnlyInfo(String label, String value, TextTheme textTheme, IconData icon, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary.withOpacity(0.7)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
