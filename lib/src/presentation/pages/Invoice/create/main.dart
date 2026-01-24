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
  final referredController = TextEditingController();
  
  // Estado para InvoiceKind
  InvoiceKind? selectedInvoiceKind;

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
    dniSearchController.dispose();
    referredController.dispose();
    super.dispose();
  }
  
  String getInvoiceKindLabel(BuildContext context, InvoiceKind kind) {
    final l10n = AppLocalizations.of(context)!;
    switch (kind) {
      case InvoiceKind.invoice:
        return l10n.invoiceTypeInvoice;
      case InvoiceKind.creditNote:
        return l10n.invoiceTypeCreditNote;
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
                  // Búsqueda de paciente (REQUERIDO)
                  Text(
                    '${l10n.patient} *',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: l10n.searchByDNI,
                          controller: dniSearchController,
                          isDense: true,
                          fieldLength: FormFieldLength.password,
                          prefixIcon: const Icon(Icons.search),
                          counterText: "",
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        icon: viewModel.searching
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.search),
                        onPressed: viewModel.searching
                            ? null
                            : () => viewModel.searchPatientByDNI(
                                  dniSearchController.text,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Resultado de búsqueda
                  if (viewModel.foundPatient != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${viewModel.foundPatient!.firstName} ${viewModel.foundPatient!.lastName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${l10n.dni}: ${viewModel.foundPatient!.dni}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (dniSearchController.text.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.patientNotFoundCreateFirst,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Exámenes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () => _showExamSelector(context, l10n),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l10n.addExam),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Lista de exámenes
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

                  // Referido (opcional)
                  CustomTextFormField(
                    labelText: '${l10n.referred} (${l10n.optional})',
                    controller: referredController,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) => viewModel.invoiceInput.referred = value,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tipo de Factura (REQUERIDO)
                  DropdownButtonFormField<InvoiceKind>(
                    value: selectedInvoiceKind ?? InvoiceKind.invoice,
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
                        viewModel.invoiceInput.kind = newValue ?? InvoiceKind.invoice;
                      });
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
                  onPressed: viewModel.loading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
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
