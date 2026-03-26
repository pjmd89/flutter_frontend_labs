import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
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
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            foregroundColor: theme.textTheme.bodyLarge?.color,
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
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
        _sectionTitle(l10n.patientType, Icons.category, context),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n.patient, Icons.person, context),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildTextField(
              l10n.firstName,
              l10n.firstName,
              context,
              controller: firstNameController,
              onChanged: (v) => viewModel.input.firstName = v,
            )),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(
              l10n.lastName,
              l10n.lastName,
              context,
              controller: lastNameController,
              onChanged: (v) => viewModel.input.lastName = v,
            )),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDropdownField<Sex>(
              label: l10n.sex,
              hint: "",
              context: context,
              value: selectedSex,
              items: Sex.values.map((s) => DropdownMenuItem(value: s, child: Text(getSexLabel(context, s)))).toList(),
              onChanged: (v) => setState(() { selectedSex = v; viewModel.input.sex = v!; }),
            )),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(
              l10n.birthDate,
              "DD/MM/YYYY",
              context,
              icon: Icons.calendar_today,
              controller: birthDateController,
              readOnly: true,
              onTap: _pickDate,
              onChanged: (_) {},
            )),
          ],
        ),
        const SizedBox(height: 32),
        Divider(color: theme.dividerColor),
        const SizedBox(height: 16),
        if (selectedPatientType == PatientType.hUMAN) ...[
          _sectionTitle(l10n.dni, Icons.badge, context),
          const SizedBox(height: 16),
          _buildTextField(
            l10n.dni,
            l10n.dni,
            context,
            controller: dniController,
            onChanged: (v) => viewModel.input.dni = v,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            l10n.email,
            l10n.email,
            context,
            icon: Icons.mail_outline,
            controller: emailController,
            onChanged: (v) => viewModel.input.email = v,
          ),
        ] else if (selectedPatientType == PatientType.aNIMAL) ...[
          _sectionTitle(l10n.species, Icons.pets, context),
          const SizedBox(height: 16),
          _buildTextField(
            l10n.species,
            l10n.species,
            context,
            controller: speciesController,
            onChanged: (v) => viewModel.input.species = v,
          ),
        ],
        const SizedBox(height: 16),
        _buildTextField(
          l10n.address,
          l10n.address,
          context,
          icon: Icons.location_on,
          controller: addressController,
          onChanged: (v) => viewModel.input.address = v,
        ),
      ],
    );
  }

  Widget _buildFooterButtons(AppLocalizations l10n, ThemeData theme) {
    return Row(
      children: [
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
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
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

  Widget _sectionTitle(String title, IconData icon, BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = theme.textTheme.bodyLarge?.color ?? theme.primaryColor;
    return Row(
      children: [
        Icon(icon, size: 16, color: titleColor),
        const SizedBox(width: 8),
        Text(title.toUpperCase(), 
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: titleColor, letterSpacing: 1.2)),
      ],
    );
  }

  Widget _buildTextField(
    String label, 
    String hint, 
    BuildContext context,
    {
      IconData? icon, 
      String? prefix, 
      TextEditingController? controller, 
      Function(String)? onChanged,
      String? Function(String?)? validator,
      bool readOnly = false,
      VoidCallback? onTap,
    }
  ) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fieldBg = theme.inputDecorationTheme.fillColor ?? (isDark ? theme.scaffoldBackgroundColor : theme.cardColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 18) : (prefix != null ? Padding(padding: const EdgeInsets.all(12), child: Text(prefix)) : null),
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: theme.dividerColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required String hint,
    required BuildContext context,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fieldBg = theme.inputDecorationTheme.fillColor ?? (isDark ? theme.scaffoldBackgroundColor : theme.cardColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            items: items,
            onChanged: onChanged,
            validator: validator,
          ),
        ),
        if (hint.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(hint, style: TextStyle(fontSize: 11, color: theme.hintColor)),
        ],
      ],
    );
  }

  /// PICKER ACTUALIZADO CON FORMATO ESTRICTO: dd/mm/yyyy hh:mm
  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      // Formateo manual para asegurar ceros a la izquierda (01, 02...)
      final String d = date.day.toString().padLeft(2, '0');
      final String m = date.month.toString().padLeft(2, '0');
      final String y = date.year.toString();
      
      final String formattedDate = "$d/$m/$y";
      final String formattedFull = "$formattedDate 00:00";

      setState(() {
        birthDateController.text = formattedDate; // Para mostrar al usuario (puedes mostrar el full si prefieres)
        viewModel.input.birthDate = formattedFull; // Para el servidor
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