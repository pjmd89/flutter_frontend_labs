import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';

class InvoiceCreatePage extends StatefulWidget {
  const InvoiceCreatePage({super.key});

  @override
  State<InvoiceCreatePage> createState() => _InvoiceCreatePageState();
}

class _InvoiceCreatePageState extends State<InvoiceCreatePage> {
  late ViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final dniSearchController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDateController = TextEditingController();
  final dniController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final referredController = TextEditingController();

  // Focus nodes para atajos de teclado
  final dniSearchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);

    // Focus automático en búsqueda al abrir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dniSearchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    dniSearchController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    dniController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    referredController.dispose();
    dniSearchFocus.dispose();
    super.dispose();
  }

  String getGenderLabel(BuildContext context, Sex sex) {
    final l10n = AppLocalizations.of(context)!;
    switch (sex) {
      case Sex.male:
        return l10n.genderMale;
      case Sex.female:
        return l10n.genderFemale;
      default:
        return sex.toString();
    }
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
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECCIÓN: Búsqueda de Paciente
                  Text(
                    '👤 ${l10n.patient.toUpperCase()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de búsqueda por DNI
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: l10n.searchByDNI,
                          controller: dniSearchController,
                          focusNode: dniSearchFocus,
                          isDense: true,
                          fieldLength: FormFieldLength.password,
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed:
                            viewModel.searching
                                ? null
                                : () {
                                  viewModel.searchPatientByDNI(
                                    dniSearchController.text,
                                  );
                                },
                        icon:
                            viewModel.searching
                                ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.search),
                        label: Text(l10n.search),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Resultado de búsqueda o formulario
                  if (viewModel.foundPatient != null) ...[
                    // Paciente encontrado
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.patientFound,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${viewModel.foundPatient!.firstName} ${viewModel.foundPatient!.lastName}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${l10n.dni}: ${viewModel.foundPatient!.dni}'),
                          if (viewModel.foundPatient!.birthDate.isNotEmpty)
                            Text(
                              '${l10n.birthDate}: ${viewModel.foundPatient!.birthDate}',
                            ),
                          if (viewModel.foundPatient!.phone.isNotEmpty)
                            Text(
                              '${l10n.phone}: ${viewModel.formatPhoneDisplay(viewModel.foundPatient!.phone)}',
                            ),
                        ],
                      ),
                    ),
                  ] else if (dniSearchController.text.isNotEmpty) ...[
                    // Paciente no encontrado - mostrar formulario
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text(
                                l10n.patientNotFound,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(l10n.completePatientData),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Formulario de nuevo paciente
                    _buildPatientForm(l10n),
                  ],

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // SECCIÓN: Exámenes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🧪 ${l10n.selectedExams.toUpperCase()}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => _showExamSelector(context, l10n),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.addExam),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Lista de exámenes seleccionados
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
                          leading: const Icon(Icons.science),
                          title: Text(exam.template?.name ?? ''),
                          subtitle: Text(exam.template?.description ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${exam.baseCost.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => viewModel.removeExam(exam.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 16),

                  // Total
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
                          '💰 ${l10n.totalAmount.toUpperCase()}:',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          viewModel.formattedTotal,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Referido por (opcional)
                  CustomTextFormField(
                    labelText: '${l10n.referred} (${l10n.optional})',
                    controller: referredController,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) {
                      viewModel.invoiceInput.referred = value;
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
                  onPressed: () => context.pop(),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed:
                      viewModel.loading
                          ? null
                          : () async {
                            if (formKey.currentState!.validate()) {
                              if (viewModel.selectedExams.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.noExamsSelected)),
                                );
                                return;
                              }

                              final isError = await viewModel.createInvoice();

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

  Widget _buildPatientForm(AppLocalizations l10n) {
    return Column(
      children: [
        CustomTextFormField(
          labelText: '${l10n.firstName} *',
          controller: firstNameController,
          isDense: true,
          fieldLength: FormFieldLength.name,
          counterText: "",
          onChange: (value) {
            viewModel.patientInput.firstName = value;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          labelText: l10n.lastName,
          controller: lastNameController,
          isDense: true,
          fieldLength: FormFieldLength.name,
          counterText: "",
          onChange: (value) {
            viewModel.patientInput.lastName = value;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          labelText: '${l10n.birthDate} *',
          controller: birthDateController,
          isDense: true,
          fieldLength: FormFieldLength.password,
          counterText: "",
          readOnly: true,
          suffixIcon: const Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              birthDateController.text = date.toString().split(' ')[0];
              viewModel.patientInput.birthDate = date.toString().split(' ')[0];
              setState(() {}); // Para actualizar validación de DNI
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          labelText: viewModel.isDNIRequired() ? '${l10n.dni} *' : l10n.dni,
          controller: dniController,
          isDense: true,
          fieldLength: FormFieldLength.password,
          counterText: "",
          onChange: (value) {
            viewModel.patientInput.dni = value;
          },
          validator: (value) {
            if (viewModel.isDNIRequired() && (value == null || value.isEmpty)) {
              return l10n.dniRequiredOver17;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<Sex>(
          value: viewModel.patientInput.sex,
          decoration: InputDecoration(
            labelText: '${l10n.gender} *',
            isDense: true,
            border: const OutlineInputBorder(),
          ),
          items:
              [Sex.male, Sex.female].map((sex) {
                return DropdownMenuItem<Sex>(
                  value: sex,
                  child: Text(getGenderLabel(context, sex)),
                );
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              viewModel.patientInput.sex = value;
            }
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: viewModel.patientInput.species,
          decoration: InputDecoration(
            labelText: '${l10n.species} *',
            isDense: true,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(value: 'Humano', child: Text(l10n.speciesHuman)),
            DropdownMenuItem(value: 'Canino', child: Text(l10n.speciesCanine)),
            DropdownMenuItem(value: 'Felino', child: Text(l10n.speciesFeline)),
            DropdownMenuItem(value: 'Equino', child: Text(l10n.speciesEquine)),
            DropdownMenuItem(value: 'Bovino', child: Text(l10n.speciesBovine)),
            DropdownMenuItem(value: 'Otro', child: Text(l10n.speciesOther)),
          ],
          onChanged: (value) {
            if (value != null) {
              viewModel.patientInput.species = value;
            }
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          labelText: l10n.phone,
          controller: phoneController,
          isDense: true,
          fieldLength: FormFieldLength.password,
          counterText: "",
          onChange: (value) {
            viewModel.patientInput.phone = value;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          labelText: l10n.email,
          controller: emailController,
          isDense: true,
          fieldLength: FormFieldLength.email,
          counterText: "",
          onChange: (value) {
            viewModel.patientInput.email = value;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          labelText: l10n.address,
          controller: addressController,
          isDense: true,
          fieldLength: FormFieldLength.description,
          counterText: "",
          onChange: (value) {
            viewModel.patientInput.address = value;
          },
        ),
      ],
    );
  }

  void _showExamSelector(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder:
          (dialogContext) =>
              _ExamSelectorDialog(viewModel: viewModel, l10n: l10n),
    );
  }
}

// Modal de selección de exámenes
class _ExamSelectorDialog extends StatefulWidget {
  final ViewModel viewModel;
  final AppLocalizations l10n;

  const _ExamSelectorDialog({required this.viewModel, required this.l10n});

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
        filteredExams =
            widget.viewModel.availableExams.where((exam) {
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
            // Campo de búsqueda
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: widget.l10n.searchExam,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: _filterExams,
            ),
            const SizedBox(height: 16),

            // Lista de exámenes
            Expanded(
              child: ListView.builder(
                itemCount: filteredExams.length,
                itemBuilder: (context, index) {
                  final exam = filteredExams[index];
                  final isSelected = widget.viewModel.selectedExams.any(
                    (e) => e.id == exam.id,
                  );

                  return CheckboxListTile(
                    title: Text(exam.template?.name ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exam.template?.description ?? ''),
                        Text(
                          '\$${exam.baseCost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
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
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.l10n.add),
        ),
      ],
    );
  }
}
