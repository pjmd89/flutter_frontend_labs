import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
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
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            title: Text(
              l10n.createThing('Laboratorio'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            bottom: viewModel.loading
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(2),
                    child: LinearProgressIndicator(minHeight: 2, backgroundColor: colorScheme.outlineVariant),
                  )
                : PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Divider(height: 1, color: colorScheme.outlineVariant),
                  ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register a new laboratory facility into the system.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                        ),
                        const SizedBox(height: 24),

                        // Empresa
                        _buildSectionLabel(context, l10n.company, required: true),
                        const SizedBox(height: 8),
                        viewModel.loadingCompanies
                            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                            : DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: selectedCompanyID,
                                decoration: _dropdownDecoration(context, prefixIcon: Icons.business),
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
                        const SizedBox(height: 24),

                        // Dirección
                        _buildSectionLabel(context, 'Dirección', required: true),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: addressController,
                          labelText: 'Dirección completa',
                          isDense: true,
                          maxLines: 2,
                          fieldLength: FormFieldLength.email,
                          onChange: (value) => viewModel.input.address = value,
                        ),
                        const SizedBox(height: 24),

                        // --- SECCIÓN DE TELÉFONOS ---
                        _buildSectionLabel(context, 'Contact Phone Numbers'),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: phoneController,
                                labelText: '+1 (555) 000-0000',
                                isDense: true,
                                fieldLength: FormFieldLength.name,
                                // Eliminamos onEditingComplete para evitar errores de sintaxis
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Botón para agregar teléfono
                            SizedBox(
                              height: 40, // Ajuste para alinear con CustomTextFormField
                              child: FilledButton(
                                onPressed: _addPhone,
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Icon(Icons.add, size: 20),
                              ),
                            ),
                          ],
                        ),
                        
                        // Chips de teléfonos agregados
                        if (addedPhones.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            "ADDED CONTACTS",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.hintColor,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: addedPhones.map((phone) => _buildPhoneChip(context, phone)).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
                ),
                child: Row(
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
                      child: FilledButton(
                        onPressed: viewModel.loading ? null : _handleSave,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: viewModel.loading
                            ? SizedBox(
                                width: 20, 
                                height: 20, 
                                child: CircularProgressIndicator(
                                  strokeWidth: 2, 
                                  color: colorScheme.onPrimary
                                ),
                              )
                            : Text(l10n.createThing('Laboratorio')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildSectionLabel(BuildContext context, String text, {bool required = false}) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        text: text,
        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        children: [
          if (required) TextSpan(text: ' *', style: TextStyle(color: theme.colorScheme.error)),
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration(BuildContext context, {IconData? prefixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : null,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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