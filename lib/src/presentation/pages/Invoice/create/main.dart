import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';
import './patient_selector_dialog.dart';

class InvoiceCreatePage extends StatefulWidget {
  const InvoiceCreatePage({super.key});

  @override
  State<InvoiceCreatePage> createState() => _InvoiceCreatePageState();
}

class _InvoiceCreatePageState extends State<InvoiceCreatePage> {
  late ViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final referredController = TextEditingController();
  
  // Controllers para CreatePerson
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dniPersonController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final birthDateController = TextEditingController();
  
  // Estado para InvoiceKind
  InvoiceKind? selectedInvoiceKind;
  
  // Estado para Sex (CreatePerson)
  Sex? selectedSex;
  
  // Estado para expandir sección de Person
  bool showPersonForm = false;

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
    referredController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    dniPersonController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    birthDateController.dispose();
    super.dispose();
  }
  
  String getInvoiceKindLabel(BuildContext context, InvoiceKind kind) {
    final l10n = AppLocalizations.of(context)!;
    switch (kind) {
      case InvoiceKind.iNVOICE:
        return l10n.invoiceTypeInvoice;
      case InvoiceKind.cREDIT_NOTE:
        return l10n.invoiceTypeCreditNote;
    }
  }
  
  String getSexLabel(BuildContext context, Sex sex) {
    final l10n = AppLocalizations.of(context)!;
    switch (sex) {
      case Sex.fEMALE:
        return l10n.sexFemale;
      case Sex.mALE:
        return l10n.sexMale;
      case Sex.iNTERSEX:
        return l10n.sexIntersex;
    }
  }
  
  Widget _buildStepHeader(BuildContext context, String stepNumber, String title, IconData icon, bool required) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  String _getPatientName(Patient patient) {
    if (patient.isPerson && patient.asPerson != null) {
      final person = patient.asPerson!;
      return '${person.firstName} ${person.lastName}';
    } else if (patient.isAnimal && patient.asAnimal != null) {
      final animal = patient.asAnimal!;
      return '${animal.firstName} ${animal.lastName}';
    }
    return 'Paciente ${patient.id}';
  }
  
  String _getPatientInfo(Patient patient, AppLocalizations l10n) {
    if (patient.isPerson && patient.asPerson != null) {
      final person = patient.asPerson!;
      return '${l10n.dni}: ${person.dni}';
    } else if (patient.isAnimal && patient.asAnimal != null) {
      final animal = patient.asAnimal!;
      return animal.species;
    }
    
    // Traducir el tipo de paciente si no hay datos específicos
    if (patient.patientType != null) {
      switch (patient.patientType!) {
        case PatientType.hUMAN:
          return l10n.patientTypeHuman;
        case PatientType.aNIMAL:
          return l10n.patientTypeAnimal;
      }
    }
    
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.receipt_long,
          title: l10n.createThing(l10n.invoice),
          loading: viewModel.loading,
          maxWidth: 700,
          minWidth: 700,
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PASO 1: Seleccionar Paciente
                  _buildStepHeader(context, '1', l10n.patient, Icons.person, true),
                  const SizedBox(height: 12),
                  
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Botón para abrir selector de pacientes
                          FilledButton.tonalIcon(
                            onPressed: () async {
                              final selected = await showDialog<Patient>(
                                context: context,
                                builder: (context) => PatientSelectorDialog(
                                  patients: viewModel.allPatients,
                                ),
                              );
                              
                              if (selected != null) {
                                viewModel.foundPatient = selected;
                              }
                            },
                            icon: const Icon(Icons.person_search),
                            label: Text(l10n.selectFromList),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                          
                          if (viewModel.foundPatient != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    viewModel.foundPatient!.isPerson 
                                      ? Icons.person 
                                      : Icons.pets,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getPatientName(viewModel.foundPatient!),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _getPatientInfo(viewModel.foundPatient!, l10n),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      viewModel.foundPatient = null;
                                    },
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.1),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      l10n.selectPatientHint,
                                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // PASO 2: Seleccionar Exámenes
                  _buildStepHeader(context, '2', l10n.selectExams, Icons.science, true),
                  const SizedBox(height: 12),
                  
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => _showExamSelector(context, l10n),
                            icon: const Icon(Icons.add, size: 18),
                            label: Text(l10n.addExam),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          if (viewModel.selectedExams.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  l10n.noExamsSelected,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            )
                          else
                            ...viewModel.selectedExams.map((exam) {
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.science, size: 20),
                                  title: Text(
                                    exam.template?.name ?? '',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    exam.template?.description ?? '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '\$${exam.baseCost.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20),
                                        color: Colors.red,
                                        onPressed: () => viewModel.removeExam(exam.id),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          
                          if (viewModel.selectedExams.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${l10n.totalAmount}:',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    viewModel.formattedTotal,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 16),
                            
                            // Tipo de Factura
                            DropdownButtonFormField<InvoiceKind>(
                              value: selectedInvoiceKind ?? InvoiceKind.iNVOICE,
                              decoration: InputDecoration(
                                labelText: l10n.invoiceType,
                                isDense: true,
                                border: const OutlineInputBorder(),
                              ),
                              items: InvoiceKind.values.map((InvoiceKind kind) {
                                return DropdownMenuItem<InvoiceKind>(
                                  value: kind,
                                  child: Text(getInvoiceKindLabel(context, kind)),
                                );
                              }).toList(),
                              onChanged: (InvoiceKind? newValue) {
                                setState(() {
                                  selectedInvoiceKind = newValue;
                                  viewModel.invoiceInput.kind = newValue ?? InvoiceKind.iNVOICE;
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // PASO 3: Información de Facturación
                  _buildStepHeader(context, '3', l10n.billToInformation, Icons.receipt, true),
                  const SizedBox(height: 12),
                  
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () async {
                              final selected = await showDialog<Person>(
                                context: context,
                                builder: (context) => BillToSelectorDialog(
                                  l10n: l10n,
                                  persons: viewModel.billToCandidates,
                                ),
                              );

                              if (selected != null) {
                                viewModel.selectedBillTo = selected;
                                setState(() {
                                  showPersonForm = false;
                                });
                              }
                            },
                            icon: const Icon(Icons.person_search),
                            label: Text(l10n.selectExistingPerson),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),

                          const SizedBox(height: 12),

                          if (viewModel.selectedBillTo != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.08),
                                border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified_user, color: Colors.green),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${viewModel.selectedBillTo!.firstName} ${viewModel.selectedBillTo!.lastName}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text('${l10n.dni}: ${viewModel.selectedBillTo!.dni}'),
                                        if (viewModel.selectedBillTo!.address.isNotEmpty)
                                          Text(
                                            viewModel.selectedBillTo!.address,
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: l10n.remove,
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      viewModel.clearSelectedBillTo();
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              l10n.createNewPerson,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],

                          if (viewModel.selectedBillTo == null) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.personForBilling,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton.icon(
                                  icon: Icon(
                                    showPersonForm ? Icons.expand_less : Icons.expand_more,
                                    size: 20,
                                  ),
                                  label: Text(showPersonForm ? 'Ocultar' : 'Mostrar'),
                                  onPressed: () {
                                    setState(() {
                                      showPersonForm = !showPersonForm;
                                    });
                                  },
                                ),
                              ],
                            ),
                            
                            if (!showPersonForm) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.05),
                                  border: Border.all(
                                    color: Colors.blue.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Haga clic en "Mostrar" para ingresar los datos de facturación',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            
                            if (showPersonForm) ...[
                              const SizedBox(height: 16),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              
                              // Nombre y Apellido en la misma fila
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      labelText: l10n.firstName,
                                      controller: firstNameController,
                                      isDense: true,
                                      fieldLength: FormFieldLength.name,
                                      counterText: "",
                                      onChange: (value) => viewModel.personInput.firstName = value,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomTextFormField(
                                      labelText: l10n.lastName,
                                      controller: lastNameController,
                                      isDense: true,
                                      fieldLength: FormFieldLength.name,
                                      counterText: "",
                                      onChange: (value) => viewModel.personInput.lastName = value,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // DNI y Teléfono en la misma fila
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      labelText: l10n.dni,
                                      controller: dniPersonController,
                                      isDense: true,
                                      fieldLength: FormFieldLength.password,
                                      counterText: "",
                                      onChange: (value) => viewModel.personInput.dni = value,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomTextFormField(
                                      labelText: '${l10n.phone} (${l10n.optional})',
                                      controller: phoneController,
                                      isDense: true,
                                      fieldLength: FormFieldLength.password,
                                      counterText: "",
                                      onChange: (value) => viewModel.personInput.phone = value,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Email
                              CustomTextFormField(
                                labelText: '${l10n.email} (${l10n.optional})',
                                controller: emailController,
                                isDense: true,
                                fieldLength: FormFieldLength.email,
                                counterText: "",
                                onChange: (value) => viewModel.personInput.email = value,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Dirección
                              CustomTextFormField(
                                labelText: '${l10n.address} (${l10n.optional})',
                                controller: addressController,
                                isDense: true,
                                fieldLength: FormFieldLength.name,
                                counterText: "",
                                onChange: (value) => viewModel.personInput.address = value,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Fecha de nacimiento y Sexo en la misma fila
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      labelText: '${l10n.birthDate} (${l10n.optional})',
                                      controller: birthDateController,
                                      isDense: true,
                                      fieldLength: FormFieldLength.password,
                                      counterText: "",
                                      readOnly: true,
                                      suffixIcon: const Icon(Icons.calendar_today, size: 18),
                                      onTap: () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        if (date != null) {
                                          // Formato dd/mm/yyyy hh:mm requerido por el servidor
                                          final formattedDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} 00:00';
                                          birthDateController.text = formattedDate;
                                          viewModel.personInput.birthDate = formattedDate;
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: DropdownButtonFormField<Sex>(
                                      value: selectedSex,
                                      decoration: InputDecoration(
                                        labelText: '${l10n.sex} (${l10n.optional})',
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                      ),
                                      items: Sex.values.map((Sex sex) {
                                        return DropdownMenuItem<Sex>(
                                          value: sex,
                                          child: Text(getSexLabel(context, sex)),
                                        );
                                      }).toList(),
                                      onChanged: (Sex? newValue) {
                                        setState(() {
                                          selectedSex = newValue;
                                          viewModel.personInput.sex = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Referido (opcional)
                  _buildStepHeader(context, '4', l10n.referred, Icons.medical_services, false),
                  const SizedBox(height: 12),
                  
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomTextFormField(
                        labelText: '${l10n.referred} (${l10n.optional})',
                        controller: referredController,
                        isDense: true,
                        fieldLength: FormFieldLength.name,
                        counterText: "",
                        prefixIcon: const Icon(Icons.medical_services, size: 20),
                        onChange: (value) => viewModel.invoiceInput.referred = value,
                      ),
                    ),
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
                  onPressed: () => context.pop(),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: viewModel.loading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            final usingExistingBillTo = viewModel.selectedBillTo != null;

                            // Validar que se haya seleccionado un paciente
                            if (viewModel.foundPatient == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.patientRequired),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            // Validar que haya exámenes seleccionados
                            if (viewModel.selectedExams.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.noExamsSelected)),
                              );
                              return;
                            }
                            
                            // Validar que se haya seleccionado o se vayan a ingresar datos de facturación
                            if (viewModel.selectedBillTo == null &&
                                (viewModel.personInput.firstName.isEmpty ||
                                viewModel.personInput.lastName.isEmpty ||
                                viewModel.personInput.dni.isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${l10n.billToInformation}: ${l10n.firstName}, ${l10n.lastName} y ${l10n.dni} son requeridos'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              setState(() {
                                showPersonForm = true;
                              });
                              return;
                            }

                            final isError = await viewModel.createInvoice(
                              useExistingBillTo: usingExistingBillTo,
                            );

                            if (!isError) {
                              if (!context.mounted) return;
                              context.pop(true);
                            }
                          }
                        },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.createThing(l10n.invoice)),
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

  void _showExamSelector(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => _ExamSelectorDialog(
        viewModel: viewModel,
        l10n: l10n,
      ),
    );
  }
}

// Modal de selección de exámenes
class _ExamSelectorDialog extends StatefulWidget {
  final ViewModel viewModel;
  final AppLocalizations l10n;

  const _ExamSelectorDialog({
    required this.viewModel,
    required this.l10n,
  });

  @override
  State<_ExamSelectorDialog> createState() => _ExamSelectorDialogState();
}

class _ExamSelectorDialogState extends State<_ExamSelectorDialog> {
  final searchController = TextEditingController();
  List<Exam> filteredExams = [];

  @override
  void initState() {
    super.initState();
    filteredExams = widget.viewModel.availableExams;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterExams(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredExams = widget.viewModel.availableExams;
      } else {
        filteredExams = widget.viewModel.availableExams.where((exam) {
          final name = exam.template?.name.toLowerCase() ?? '';
          final desc = exam.template?.description.toLowerCase() ?? '';
          final q = query.toLowerCase();
          return name.contains(q) || desc.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.selectExams),
      content: SizedBox(
        width: 500,
        height: 600,
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: widget.l10n.searchExam,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: _filterExams,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredExams.length,
                itemBuilder: (context, index) {
                  final exam = filteredExams[index];
                  final isSelected = widget.viewModel.selectedExams.any(
                    (e) => e.id == exam.id,
                  );

                  return CheckboxListTile(
                    dense: true,
                    title: Text(exam.template?.name ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.template?.description ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          '\$${exam.baseCost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        widget.viewModel.toggleExam(exam);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.l10n.cancel),
        ),
      ],
    );
  }
}

// Selector de pagadores existentes
class BillToSelectorDialog extends StatefulWidget {
  final List<Person> persons;
  final AppLocalizations l10n;

  const BillToSelectorDialog({
    required this.persons,
    required this.l10n,
  });

  @override
  State<BillToSelectorDialog> createState() => _BillToSelectorDialogState();
}

class _BillToSelectorDialogState extends State<BillToSelectorDialog> {
  final searchController = TextEditingController();
  late List<Person> filteredPersons;

  @override
  void initState() {
    super.initState();
    filteredPersons = widget.persons;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterPersons(String query) {
    final q = query.toLowerCase().trim();

    setState(() {
      if (q.isEmpty) {
        filteredPersons = widget.persons;
      } else {
        filteredPersons = widget.persons.where((person) {
          final fullName = '${person.firstName} ${person.lastName}'.toLowerCase();
          return person.dni.toLowerCase().contains(q) || fullName.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.selectExistingPerson),
      content: SizedBox(
        width: 520,
        height: 520,
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: widget.l10n.searchByDNI,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: _filterPersons,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredPersons.isEmpty
                  ? Center(
                      child: Text(widget.l10n.billToNotFound),
                    )
                  : ListView.builder(
                      itemCount: filteredPersons.length,
                      itemBuilder: (context, index) {
                        final person = filteredPersons[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.badge_outlined),
                            title: Text('${person.firstName} ${person.lastName}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${widget.l10n.dni}: ${person.dni}'),
                                if (person.address.isNotEmpty)
                                  Text(
                                    person.address,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).pop(person),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.l10n.cancel),
        ),
      ],
    );
  }
}
