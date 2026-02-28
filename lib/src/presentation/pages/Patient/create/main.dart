import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';

class PatientCreatePage extends StatefulWidget {
  const PatientCreatePage({super.key});

  @override
  State<PatientCreatePage> createState() => _PatientCreatePageState();
}

class _PatientCreatePageState extends State<PatientCreatePage> {
  late ViewModel viewModel;
  
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final speciesController = TextEditingController();
  final dniController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final birthDateController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Sex? selectedSex;
  PatientType? selectedPatientType;
  DateTime? selectedBirthDate;
  String? selectedLaboratoryID;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    speciesController.dispose();
    dniController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  String getSexLabel(BuildContext context, Sex sex) {
    final l10n = AppLocalizations.of(context)!;
    switch (sex) {
      case Sex.fEMALE: return l10n.sexFemale;
      case Sex.mALE: return l10n.sexMale;
      case Sex.iNTERSEX: return l10n.sexIntersex;
    }
  }

  String getPatientTypeLabel(BuildContext context, PatientType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case PatientType.hUMAN: return l10n.patientTypeHuman;
      case PatientType.aNIMAL: return l10n.patientTypeAnimal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.createThing(l10n.patient)),           
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSegmentedSelector(l10n, theme),
                      const SizedBox(height: 32),
                      _buildFormBody(l10n, theme),
                      const SizedBox(height: 40),
                      _buildFooterButtons(l10n, theme),
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

  Widget _buildSegmentedSelector(AppLocalizations l10n, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.patientType.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5), 
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: PatientType.values.map((type) {
              final isSelected = selectedPatientType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    selectedPatientType = type;
                    viewModel.input.patientType = type;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        getPatientTypeLabel(context, type),
                        style: TextStyle(
                          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFormBody(AppLocalizations l10n, ThemeData theme) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _inputWrapper(l10n.firstName, theme, CustomTextFormField(
              controller: firstNameController,
              isDense: true,
              fieldLength: FormFieldLength.name,
              counterText: "",
              onChange: (v) => viewModel.input.firstName = v,
            ))),
            const SizedBox(width: 16),
            Expanded(child: _inputWrapper(l10n.lastName, theme, CustomTextFormField(
              controller: lastNameController,
              isDense: true,
              fieldLength: FormFieldLength.name,
              counterText: "",
              onChange: (v) => viewModel.input.lastName = v,
            ))),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _inputWrapper(l10n.sex, theme, DropdownButtonFormField<Sex>(
              value: selectedSex,
              dropdownColor: theme.colorScheme.surface,
              style: theme.textTheme.bodyLarge,
              decoration: _inputDecoration(theme),
              items: Sex.values.map((s) => DropdownMenuItem(value: s, child: Text(getSexLabel(context, s)))).toList(),
              onChanged: (v) => setState(() { selectedSex = v; viewModel.input.sex = v!; }),
            ))),
            const SizedBox(width: 16),
            Expanded(child: _inputWrapper(l10n.birthDate, theme, CustomTextFormField(
              controller: birthDateController,
              isDense: true,
              fieldLength: FormFieldLength.name,
              readOnly: true,
              counterText: "",
              prefixIcon: Icon(Icons.calendar_today, size: 18, color: theme.colorScheme.onSurfaceVariant),
              onTap: _pickDate,
              onChange: (_) {},
            ))),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Divider(color: theme.colorScheme.outlineVariant.withOpacity(0.3)),
        ),
        if (selectedPatientType == PatientType.hUMAN) ...[
          _inputWrapper(l10n.dni, theme, CustomTextFormField(
            controller: dniController,
            isDense: true,
            fieldLength: FormFieldLength.name,
            counterText: "",
            onChange: (v) => viewModel.input.dni = v,
          )),
          const SizedBox(height: 20),
          _inputWrapper(l10n.email, theme, CustomTextFormField(
            controller: emailController,
            isDense: true,
            fieldLength: FormFieldLength.email,
            counterText: "",
            onChange: (v) => viewModel.input.email = v,
          )),
        ] else if (selectedPatientType == PatientType.aNIMAL) ...[
          _inputWrapper(l10n.species, theme, CustomTextFormField(
            controller: speciesController,
            isDense: true,
            fieldLength: FormFieldLength.name,
            counterText: "",
            onChange: (v) => viewModel.input.species = v,
          )),
        ],
        const SizedBox(height: 20),
        _inputWrapper(l10n.address, theme, CustomTextFormField(
          controller: addressController,
          isDense: true,
          fieldLength: FormFieldLength.email,
          counterText: "",
          onChange: (v) => viewModel.input.address = v,
        )),
      ],
    );
  }

  Widget _buildFooterButtons(AppLocalizations l10n, ThemeData theme) {
    return Row(
      children: [
        // Botón Cancelar (Ajustado a tus dimensiones/estilo)
        Expanded(
          child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(l10n.cancel),
                  ),
        ),
        const SizedBox(width: 16),
        // Botón Crear (Ajustado exactamente a tu código)
        Expanded(
          child: ElevatedButton.icon(
            onPressed: viewModel.loading ? null : _submit,
            icon: viewModel.loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, 
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                : const Icon(Icons.save, size: 18),
            label: Text(l10n.createThing(l10n.patient)),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 10,
              shadowColor: theme.primaryColor.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputWrapper(String label, ThemeData theme, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(ThemeData theme) {
    return InputDecoration(
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5))
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5))
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        final formatted = "${date.day}/${date.month}/${date.year}";
        birthDateController.text = formatted;
        viewModel.input.birthDate = '$formatted 00:00';
      });
    }
  }

  void _submit() async {
    if (formKey.currentState!.validate()) {
      bool isErr = await viewModel.create();
      if (!isErr && mounted) context.pop(true);
    }
  }
}