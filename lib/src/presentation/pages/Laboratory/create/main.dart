import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import './view_model.dart';

class LaboratoryCreatePage extends StatefulWidget {
  const LaboratoryCreatePage({super.key});

  @override
  State<LaboratoryCreatePage> createState() => _LaboratoryCreatePageState();
}

class _LaboratoryCreatePageState extends State<LaboratoryCreatePage> {
  late ViewModel viewModel;

  final addressController = TextEditingController();
  final phoneController = TextEditingController(); 
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedCompanyID;
  List<String> addedPhones = []; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  @override
  void dispose() {
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE TELÉFONOS ---

  void _addPhone() {
    final phone = phoneController.text.trim();
    if (phone.isNotEmpty && !addedPhones.contains(phone)) {
      setState(() {
        addedPhones.add(phone);
        phoneController.clear();
        _updateViewModelPhones();
      });
    }
  }

  void _removePhone(String phone) {
    setState(() {
      addedPhones.remove(phone);
      _updateViewModelPhones();
    });
  }

  void _updateViewModelPhones() {
    viewModel.input.contactPhoneNumbers = addedPhones.isEmpty ? null : addedPhones;
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
          appBar: AppBar(
            title: Text(l10n.createThing(l10n.laboratory)),
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            foregroundColor: theme.textTheme.bodyLarge?.color,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Register a new laboratory facility into the system.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Empresa
                  _sectionTitle(l10n.company, Icons.business, context),
                  const SizedBox(height: 16),
                  viewModel.loadingCompanies
                      ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                      : _buildDropdownField<String>(
                          label: l10n.company,
                          hint: "",
                          context: context,
                          value: selectedCompanyID,
                          items: viewModel.companies.map((Company company) {
                            return DropdownMenuItem<String>(
                              value: company.id,
                              child: Text(company.name, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCompanyID = newValue;
                              viewModel.input.companyID = newValue;
                            });
                          },
                          validator: (value) => (value == null || value.isEmpty) ? l10n.emptyFieldError : null,
                        ),
                  const SizedBox(height: 32),

                  // Dirección
                  _sectionTitle(l10n.address, Icons.location_on, context),
                  const SizedBox(height: 16),
                  _buildTextField(
                    l10n.address,
                    l10n.address,
                    context,
                    controller: addressController,
                    maxLines: 2,
                    onChanged: (value) => viewModel.input.address = value,
                    validator: (value) => (value == null || value.isEmpty) ? l10n.emptyFieldError : null,
                  ),
                  const SizedBox(height: 32),

                  // --- SECCIÓN DE TELÉFONOS ---
                  _sectionTitle(l10n.phoneNumber, Icons.phone, context),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          l10n.phoneNumber,
                          '+58 123 456 7890',
                          context,
                          controller: phoneController,
                          onChanged: (_) {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Botón para agregar teléfono
                      Padding(
                        padding: const EdgeInsets.only(top: 22),
                        child: FilledButton.icon(
                          onPressed: _addPhone,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(l10n.add),
                        ),
                      ),
                    ],
                  ),
                  
                  // Chips de teléfonos agregados
                  if (addedPhones.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      "ADDED CONTACTS",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.hintColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: addedPhones.map((phone) => _buildPhoneChip(context, phone)).toList(),
                    ),
                  ],
                  
                  const SizedBox(height: 40),

                  // Botones de acción
                  Row(
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
                          onPressed: viewModel.loading ? null : _handleSave,
                          icon: viewModel.loading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.save, size: 18),
                          label: Text(l10n.createThing(l10n.laboratory)),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- COMPONENTES AUXILIARES ---

  Widget _buildPhoneChip(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.phone, size: 14, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.primary, 
              fontSize: 12, 
              fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () => _removePhone(label),
            child: Icon(Icons.close, size: 14, color: colorScheme.primary),
          ),
        ],
      ),
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
      int maxLines = 1,
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
          maxLines: maxLines,
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

  Future<void> _handleSave() async {
    if (formKey.currentState!.validate()) {
      var isErr = await viewModel.create();
      if (!isErr) {
        if (!mounted) return;
        context.pop(true);
      }
    }
  }
}