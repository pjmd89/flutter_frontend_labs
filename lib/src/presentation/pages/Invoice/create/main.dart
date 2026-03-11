import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
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
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dniPersonController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final birthDateController = TextEditingController();

  InvoiceKind? selectedInvoiceKind;
  Sex? selectedSex;
  bool showPersonForm = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  @override
  void dispose() {
    dniSearchController.dispose();
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

  // --- MÉTODOS DE APOYO ---

  String _getPatientName(Patient patient) {
    if (patient.isPerson && patient.asPerson != null) {
      final person = patient.asPerson!;
      return '${person.firstName} ${person.lastName}';
    } else if (patient.isAnimal && patient.asAnimal != null) {
      final animal = patient.asAnimal!;
      return '${animal.firstName} ${animal.lastName}';
    }
    return 'ID: ${patient.id}';
  }

  String getSexLabel(BuildContext context, Sex sex) {
    final l10n = AppLocalizations.of(context)!;
    switch (sex) {
      case Sex.fEMALE: return l10n.sexFemale;
      case Sex.mALE: return l10n.sexMale;
      case Sex.iNTERSEX: return l10n.sexIntersex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: SelectionArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1300),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNavHeader(
                          title: l10n.createThing(l10n.invoice),
                          colorScheme: colorScheme,
                          onBack: () => context.pop(),
                          trailing: _buildInvoiceTypeSelector(l10n, colorScheme),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  _buildPatientSearchCard(l10n, colorScheme),
                                  const SizedBox(height: 24),
                                  _buildExamsCard(l10n, colorScheme),
                                  const SizedBox(height: 24),
                                  _buildBillingDetailsCard(l10n, colorScheme),
                                  const SizedBox(height: 24),
                                  _buildReferredCard(l10n, colorScheme),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              flex: 1,
                              child: _buildSummarySidebar(l10n, colorScheme),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildNavHeader({required String title, required ColorScheme colorScheme, required VoidCallback onBack, Widget? trailing}) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: kToolbarHeight, 
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), color: colorScheme.onSurface, onPressed: onBack),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: TextStyle(color: colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceTypeSelector(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10), border: Border.all(color: colorScheme.outlineVariant)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTypeToggle(l10n.invoiceTypeInvoice, (selectedInvoiceKind ?? InvoiceKind.iNVOICE) == InvoiceKind.iNVOICE, colorScheme, () {
            setState(() => selectedInvoiceKind = InvoiceKind.iNVOICE);
            viewModel.invoiceInput.kind = InvoiceKind.iNVOICE;
          }),
          _buildTypeToggle(l10n.invoiceTypeCreditNote, selectedInvoiceKind == InvoiceKind.cREDIT_NOTE, colorScheme, () {
            setState(() => selectedInvoiceKind = InvoiceKind.cREDIT_NOTE);
            viewModel.invoiceInput.kind = InvoiceKind.cREDIT_NOTE;
          }),
        ],
      ),
    );
  }

  Widget _buildTypeToggle(String label, bool active, ColorScheme colorScheme, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: active ? colorScheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(6)),
        child: Text(label, style: TextStyle(color: active ? colorScheme.onPrimary : colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPatientSearchCard(AppLocalizations l10n, ColorScheme colorScheme) {
    return _cardBase(
      colorScheme: colorScheme,
      title: l10n.patient,
      icon: Icons.person_search,
      child: Column(
        children: [
          _buildCustomTextField(
            colorScheme: colorScheme,
            label: l10n.searchByDNI,
            controller: dniSearchController,
            hint: "12345678...",
            icon: Icons.search,
            suffix: viewModel.searching 
              ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2))
              : IconButton(onPressed: () => viewModel.searchPatientByDNI(dniSearchController.text), icon: Icon(Icons.arrow_forward, color: colorScheme.onSurfaceVariant)),
          ),
          if (viewModel.foundPatient != null) ...[
            const SizedBox(height: 16),
            _buildFoundPatientIndicator(colorScheme),
          ]
        ],
      ),
    );
  }

  Widget _buildFoundPatientIndicator(ColorScheme colorScheme) {
    final successColor = Colors.green; 
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: successColor.withOpacity(0.05), border: Border.all(color: successColor.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: successColor),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_getPatientName(viewModel.foundPatient!), style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
              Text("Paciente verificado", style: TextStyle(color: successColor.withOpacity(0.7), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamsCard(AppLocalizations l10n, ColorScheme colorScheme) {
    return _cardBase(
      colorScheme: colorScheme,
      title: l10n.selectExams,
      icon: Icons.biotech,
      action: TextButton.icon(onPressed: () => _showExamSelector(context, l10n, colorScheme), icon: const Icon(Icons.add, size: 18), label: Text(l10n.addExam, style: const TextStyle(fontWeight: FontWeight.bold))),
      child: viewModel.selectedExams.isEmpty
          ? Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(l10n.noExamsSelected, style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.5)))))
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.selectedExams.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final exam = viewModel.selectedExams[index];
                return _buildExamListItem(exam, colorScheme, () => viewModel.removeExam(exam.id));
              },
            ),
    );
  }

  Widget _buildExamListItem(Exam exam, ColorScheme colorScheme, VoidCallback onDelete) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: colorScheme.outlineVariant)),
      child: Row(
        children: [
          Icon(Icons.science, color: colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(exam.template?.name ?? '', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600)), Text(exam.template?.description ?? '', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 11))])),
          Text("\$${exam.baseCost.toStringAsFixed(2)}", style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
          IconButton(onPressed: onDelete, icon: Icon(Icons.delete_outline, color: colorScheme.error, size: 20)),
        ],
      ),
    );
  }

  Widget _buildBillingDetailsCard(AppLocalizations l10n, ColorScheme colorScheme) {
    return _cardBase(
      colorScheme: colorScheme,
      title: l10n.billToInformation,
      icon: Icons.receipt_long,
      action: TextButton(onPressed: () => setState(() => showPersonForm = !showPersonForm), child: Text(showPersonForm ? "Ocultar" : "Mostrar")),
      child: !showPersonForm 
        ? Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: colorScheme.onSurface.withOpacity(0.03), borderRadius: BorderRadius.circular(8)), child: Row(children: [Icon(Icons.info_outline, size: 16, color: colorScheme.onSurfaceVariant), const SizedBox(width: 8), Text("Configura los datos de facturación", style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13))]))
        : Column(
            children: [
              Row(children: [
                Expanded(child: _buildCustomTextField(colorScheme: colorScheme, label: l10n.firstName, controller: firstNameController, onChange: (v) => viewModel.personInput.firstName = v)),
                const SizedBox(width: 16),
                Expanded(child: _buildCustomTextField(colorScheme: colorScheme, label: l10n.lastName, controller: lastNameController, onChange: (v) => viewModel.personInput.lastName = v)),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _buildCustomTextField(colorScheme: colorScheme, label: l10n.dni, controller: dniPersonController, onChange: (v) => viewModel.personInput.dni = v)),
                const SizedBox(width: 16),
                Expanded(child: _buildCustomTextField(colorScheme: colorScheme, label: l10n.phone, controller: phoneController, onChange: (v) => viewModel.personInput.phone = v)),
              ]),
              const SizedBox(height: 16),
              _buildCustomTextField(colorScheme: colorScheme, label: l10n.email, controller: emailController, onChange: (v) => viewModel.personInput.email = v),
              const SizedBox(height: 16),
              _buildCustomTextField(colorScheme: colorScheme, label: l10n.address, controller: addressController, onChange: (v) => viewModel.personInput.address = v),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _buildDatePickerField(l10n, colorScheme)),
                const SizedBox(width: 16),
                Expanded(child: _buildSexDropdown(l10n, colorScheme)),
              ]),
            ],
          ),
    );
  }

  Widget _buildReferredCard(AppLocalizations l10n, ColorScheme colorScheme) {
    return _cardBase(colorScheme: colorScheme, title: l10n.referred, icon: Icons.medical_services, child: _buildCustomTextField(colorScheme: colorScheme, label: l10n.referred, controller: referredController, hint: "Dr. Nombre...", onChange: (v) => viewModel.invoiceInput.referred = v));
  }

  Widget _buildSummarySidebar(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(20), border: Border.all(color: colorScheme.outlineVariant), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 40, offset: const Offset(0, 20))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("RESUMEN", style: TextStyle(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Cálculo automático", style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
          Divider(height: 40, color: colorScheme.outlineVariant),
          ...viewModel.selectedExams.map((e) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(e.template?.name ?? '', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13)), Text("\$${e.baseCost.toStringAsFixed(2)}", style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold))]))),
          const SizedBox(height: 16),
          Divider(height: 1, color: colorScheme.outlineVariant),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [Text("TOTAL", style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 12)), Text(viewModel.formattedTotal, style: TextStyle(color: colorScheme.primary, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1))]),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: viewModel.loading ? null : () async {
              if (formKey.currentState!.validate()) {
                if (viewModel.foundPatient == null) { _showToast(l10n.patientRequired, colorScheme); return; }
                final isError = await viewModel.createInvoice();
                if (!isError && mounted) context.pop(true);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: viewModel.loading ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2)) : Text(l10n.createThing(l10n.invoice), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE ATOMS ---

  Widget _cardBase({required ColorScheme colorScheme, required String title, required IconData icon, required Widget child, Widget? action}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16), border: Border.all(color: colorScheme.outlineVariant)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: colorScheme.primary, size: 20), const SizedBox(width: 12), Text(title, style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)), const Spacer(), if (action != null) action]),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildCustomTextField({required ColorScheme colorScheme, required String label, required TextEditingController controller, String? hint, IconData? icon, Widget? suffix, Function(String)? onChange}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChange,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.3)), prefixIcon: icon != null ? Icon(icon, color: colorScheme.onSurfaceVariant, size: 20) : null, suffixIcon: suffix, filled: true, fillColor: colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
        ),
      ],
    );
  }

  /// DATE PICKER FIELD - FORMATO: dd/mm/yyyy hh:mm
  Widget _buildDatePickerField(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.birthDate.toUpperCase(), style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 8),
        TextField(
          controller: birthDateController,
          readOnly: true, 
          style: TextStyle(color: colorScheme.onSurface),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: colorScheme), child: child!),
            );

            if (pickedDate != null) {
              // Formateo manual para asegurar ceros a la izquierda y el formato dd/mm/yyyy hh:mm
              final String d = pickedDate.day.toString().padLeft(2, '0');
              final String m = pickedDate.month.toString().padLeft(2, '0');
              final String y = pickedDate.year.toString();
              final String formatted = "$d/$m/$y 00:00";

              setState(() {
                birthDateController.text = formatted;
                viewModel.personInput.birthDate = formatted;
              });
            }
          },
          decoration: InputDecoration(hintText: "DD/MM/YYYY HH:MM", prefixIcon: Icon(Icons.calendar_today, color: colorScheme.onSurfaceVariant, size: 20), suffixIcon: Icon(Icons.expand_more, color: colorScheme.onSurfaceVariant), filled: true, fillColor: colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
        ),
      ],
    );
  }

  Widget _buildSexDropdown(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.sex.toUpperCase(), style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<Sex>(
          dropdownColor: colorScheme.surfaceContainerHighest,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(filled: true, fillColor: colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
          items: Sex.values.map((s) => DropdownMenuItem(value: s, child: Text(getSexLabel(context, s)))).toList(),
          onChanged: (v) => setState(() => viewModel.personInput.sex = v),
        ),
      ],
    );
  }

  void _showToast(String msg, ColorScheme colorScheme) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: colorScheme.primary));
  }

  void _showExamSelector(BuildContext context, AppLocalizations l10n, ColorScheme colorScheme) {
    showDialog(context: context, builder: (dialogContext) => _ExamSelectorDialog(viewModel: viewModel, l10n: l10n, colorScheme: colorScheme));
  }
}

// --- MODAL: SELECTOR DE EXAMENES ---

class _ExamSelectorDialog extends StatefulWidget {
  final ViewModel viewModel;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  const _ExamSelectorDialog({required this.viewModel, required this.l10n, required this.colorScheme});
  @override
  State<_ExamSelectorDialog> createState() => _ExamSelectorDialogState();
}

class _ExamSelectorDialogState extends State<_ExamSelectorDialog> {
  final searchController = TextEditingController();
  late List<Exam> filteredExams;

  @override
  void initState() {
    super.initState();
    filteredExams = widget.viewModel.availableExams;
  }

  void _filter(String q) => setState(() => filteredExams = widget.viewModel.availableExams.where((e) => (e.template?.name ?? '').toLowerCase().contains(q.toLowerCase())).toList());

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.colorScheme;
    return Dialog(
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600, height: 700, padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(children: [Text(widget.l10n.selectExams, style: TextStyle(color: colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)), const Spacer(), IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant))]),
            const SizedBox(height: 16),
            TextField(controller: searchController, onChanged: _filter, style: TextStyle(color: colorScheme.onSurface), decoration: InputDecoration(prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant), hintText: widget.l10n.searchExam, filled: true, fillColor: colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredExams.length,
                itemBuilder: (context, index) {
                  final exam = filteredExams[index];
                  final isSelected = widget.viewModel.selectedExams.any((e) => e.id == exam.id);
                  return Container(margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: isSelected ? colorScheme.primary.withOpacity(0.05) : Colors.transparent, borderRadius: BorderRadius.circular(10), border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.outlineVariant)), child: CheckboxListTile(activeColor: colorScheme.primary, checkColor: colorScheme.onPrimary, value: isSelected, onChanged: (_) => setState(() => widget.viewModel.toggleExam(exam)), title: Text(exam.template?.name ?? '', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)), subtitle: Text("\$${exam.baseCost.toStringAsFixed(2)}", style: TextStyle(color: colorScheme.primary, fontSize: 12))));
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary, minimumSize: const Size(double.infinity, 50)), child: const Text("Confirmar Selección", style: TextStyle(fontWeight: FontWeight.bold)))
          ],
        ),
      ),
    );
  }
}