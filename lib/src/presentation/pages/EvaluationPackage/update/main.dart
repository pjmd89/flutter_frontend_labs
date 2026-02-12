import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agile_front/agile_front.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
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
  
  final TextEditingController observationController = TextEditingController();
  // Map: examIndex -> List<TextEditingController> para cada indicador
  final Map<int, List<TextEditingController>> examValueControllers = {};
  // Map: examIndex -> Map<indicatorIndex -> bool> para indicadores booleanos
  final Map<int, Map<int, bool>> examBooleanValues = {};
  bool allResultsCompleted = false;
  final signatureController = TextEditingController();
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(
      context: context,
      evaluationPackage: widget.evaluationPackage,
    );
    
    // Inicializar controller de observaciones (solo prellenar el controller, no el input)
    if (observationController.text.isEmpty) {
      if (widget.evaluationPackage.observations.isNotEmpty) {
        observationController.text = widget.evaluationPackage.observations.join('\n');
      }
    }
    
    // Inicializar controllers de valores de exámenes
    if (examValueControllers.isEmpty) {
      for (var i = 0; i < widget.evaluationPackage.valuesByExam.length; i++) {
        final examResult = widget.evaluationPackage.valuesByExam[i];
        final controllers = <TextEditingController>[];
        final booleanValues = <int, bool>{};
        
        for (var j = 0; j < examResult.indicatorValues.length; j++) {
          final indicatorValue = examResult.indicatorValues[j];
          final indicator = indicatorValue.indicator;
          
          // Si es booleano, inicializar en el map de booleanos
          if (indicator?.valueType?.normalize() == ValueType.bOOLEAN) {
            // Parsear el valor string a booleano
            booleanValues[j] = indicatorValue.value.toLowerCase() == 'true';
            // Crear controller vacío para mantener índices sincronizados
            controllers.add(TextEditingController());
          } else {
            controllers.add(TextEditingController(text: indicatorValue.value));
          }
        }
        
        examValueControllers[i] = controllers;
        if (booleanValues.isNotEmpty) {
          examBooleanValues[i] = booleanValues;
        }
      }
    }
    
    // Inicializar estado de completitud
    allResultsCompleted = widget.evaluationPackage.status == ResultStatus.cOMPLETED;
  }
  
  @override
  void dispose() {
    observationController.dispose();
    for (var controllers in examValueControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    signatureController.dispose();
    super.dispose();
  }
  
  void _updateExamValues() {
    // Actualizar valuesByExam en el input con los valores de los controllers
    final examResults = <ExamResultInput>[];
    
    for (var i = 0; i < widget.evaluationPackage.valuesByExam.length; i++) {
      final examResult = widget.evaluationPackage.valuesByExam[i];
      final controllers = examValueControllers[i];
      final booleanValues = examBooleanValues[i];
      
      if (controllers != null) {
        final indicatorValues = <SetIndicatorValue>[];
        
        for (var j = 0; j < controllers.length; j++) {
          final indicator = examResult.indicatorValues[j].indicator;
          
          // ✅ Manejar indicadores booleanos
          if (indicator?.valueType?.normalize() == ValueType.bOOLEAN) {
            // Obtener valor del map de booleanos (si existe)
            if (booleanValues != null && booleanValues.containsKey(j)) {
              indicatorValues.add(SetIndicatorValue(
                indicatorIndex: j,
                value: booleanValues[j].toString(),
              ));
            }
          } else {
            // ✅ Manejar indicadores de texto/numéricos - Solo agregar si tiene valor no vacío
            final value = controllers[j].text.trim();
            if (value.isNotEmpty) {
              indicatorValues.add(SetIndicatorValue(
                indicatorIndex: j,
                value: value,
              ));
            }
          }
        }
        
        // ✅ Solo agregar ExamResult si tiene al menos un indicador con valor
        if (indicatorValues.isNotEmpty) {
          examResults.add(ExamResultInput(
            exam: examResult.exam?.id ?? '',
            indicatorValues: indicatorValues,
          ));
        }
      }
    }
    
    viewModel.input.valuesByExam = examResults;
  }
  
  Future<void> _pickAndUploadSignature(BuildContext context) async {
    try {
      debugPrint('🔧 Iniciando selección de archivo de firma... (kIsWeb: $kIsWeb)');
      
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

          final success = await viewModel.uploadSignature(
            fileBytes: fileBytes,
            fileName: fileName,
            evaluationPackageId: widget.evaluationPackage.id,
          );

          if (success && viewModel.signatureDisplayFileName != null) {
            setState(() {
              signatureController.text = viewModel.signatureDisplayFileName!;
            });
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
        return 'Pendiente';
      case ResultStatus.iNPROGRESS:
        return 'En Progreso';
      case ResultStatus.cOMPLETED:
        return 'Completado';
    }
  }
  
  String getValueTypeLabel(BuildContext context, ValueType? valueType) {
    final l10n = AppLocalizations.of(context)!;
    if (valueType == null) return l10n.valueTypeText;
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
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authNotifier = context.read<AuthNotifier>();
    final isBioanalyst = authNotifier.labRole == LabMemberRole.bIOANALYST;
    final isTechnician = authNotifier.labRole == LabMemberRole.tECHNICIAN;
    final isOwner = authNotifier.userIsLabOwner;
    final canEdit = (isOwner || isTechnician) && !isBioanalyst;
    
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
                  // Mensaje informativo para usuarios según su rol
                  if (!canEdit && !isBioanalyst) ...[
                    Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.viewOnlyMode,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  if (isBioanalyst) ...[  
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified_user,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.bioanalystViewMode,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Sección de información no editable
                  if (viewModel.currentEvaluationPackage != null) ...[
                    Card(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                                    
                                    // ✅ Si es booleano, mostrar checkbox
                                    if (indicator?.valueType?.normalize() == ValueType.bOOLEAN) {
                                      final booleanValues = examBooleanValues[examIndex] ?? {};
                                      final currentValue = booleanValues[indicatorIndex] ?? false;
                                      
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: indicator?.name ?? 'Indicador ${indicatorIndex + 1}',
                                            border: const OutlineInputBorder(),
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Checkbox(
                                                value: currentValue,
                                                onChanged: canEdit ? (bool? value) {
                                                  setState(() {
                                                    if (examBooleanValues[examIndex] == null) {
                                                      examBooleanValues[examIndex] = {};
                                                    }
                                                    examBooleanValues[examIndex]![indicatorIndex] = value ?? false;
                                                    _updateExamValues();
                                                  });
                                                } : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    
                                    // ✅ Para otros tipos, mostrar TextField
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: CustomTextFormField(
                                        labelText: '${indicator?.name ?? 'Indicador ${indicatorIndex + 1}'} ${indicator?.unit != null && indicator!.unit.isNotEmpty ? '(${indicator.unit})' : ''} - ${getValueTypeLabel(context, indicator?.valueType)}',
                                        controller: controllers[indicatorIndex],
                                        isDense: true,
                                        fieldLength: FormFieldLength.name,
                                        counterText: "",
                                        readOnly: !canEdit,
                                        onChange: (value) {
                                          _updateExamValues();
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
                  
                  // Switch de completitud - Solo para OWNER y TECHNICIAN
                  if (canEdit) ...[
                    SwitchListTile(
                      title: Text(l10n.allResultsCompleted),
                      subtitle: Text(l10n.markAsCompletedDescription),
                      value: allResultsCompleted,
                      onChanged: (bool value) {
                        setState(() {
                          allResultsCompleted = value;
                          viewModel.input.allResultsCompleted = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Sección de firma - Solo para bioanalistas cuando pueden aprobar
                  if (isBioanalyst && 
                      viewModel.currentEvaluationPackage?.isApproved == false &&
                      viewModel.currentEvaluationPackage?.status == ResultStatus.cOMPLETED) ...[
                    Text(
                      l10n.signature,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.draw,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            viewModel.hasSignature
                                ? viewModel.signatureDisplayFileName ?? ''
                                : '${l10n.signature} (${l10n.optional})',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: viewModel.hasSignature ? FontWeight.normal : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: viewModel.uploadingSignature
                              ? null
                              : () => _pickAndUploadSignature(context),
                          icon: viewModel.uploadingSignature
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.upload_file, size: 18),
                          label: Text(
                            viewModel.uploadingSignature
                                ? l10n.uploading
                                : (viewModel.hasSignature ? l10n.changeSignature : l10n.upload),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Sección de observaciones
                  Text(
                    l10n.observations,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
              
                  TextFormField(
                    controller: observationController,
                    maxLines: null,
                    minLines: 3,
                    readOnly: !canEdit,
                    decoration: InputDecoration(
                      labelText: l10n.observations,
                      hintText: l10n.writeObservationsHere,
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Dividir por líneas y filtrar vacías para mantener compatibilidad con lista
                      final observations = value.split('\n')
                          .where((line) => line.trim().isNotEmpty)
                          .toList();
                      viewModel.input.observations = observations;
                    },
                  ),
                  const SizedBox(height: 16),
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
                
                // Botón de aprobación - Solo visible para bioanalistas cuando el paquete está completado
                if (isBioanalyst && 
                    viewModel.currentEvaluationPackage?.isApproved == false &&
                    viewModel.currentEvaluationPackage?.status == ResultStatus.cOMPLETED) ...[
                  FilledButton.tonal(
                    onPressed: viewModel.loading
                      ? null
                      : () async {
                        // Mostrar diálogo de confirmación
                        final shouldApprove = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(l10n.approveEvaluationPackage),
                              content: Text(l10n.approveEvaluationPackageConfirmation),
                              actions: [
                                TextButton(
                                  child: Text(l10n.cancel),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                FilledButton(
                                  child: Text(l10n.approve),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ],
                            );
                          },
                        );
                        
                        if (shouldApprove == true) {
                          var isErr = await viewModel.approve();
                          
                          if (!isErr) {
                            if (!context.mounted) return;
                            context.pop(true);
                          }
                        }
                      },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.approve),
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
                          const Icon(Icons.verified, size: 18),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                
                // Botón de actualizar - Solo para técnicos y bioanalistas
                if (canEdit)
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
