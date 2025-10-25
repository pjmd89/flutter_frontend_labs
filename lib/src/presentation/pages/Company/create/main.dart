import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';

class CompanyCreatePage extends StatefulWidget {
  const CompanyCreatePage({super.key});

  @override
  State<CompanyCreatePage> createState() => _CompanyCreatePageState();
}

class _CompanyCreatePageState extends State<CompanyCreatePage> {
  late ViewModel viewModel;

  // Controllers para cada campo del formulario
  final nameController = TextEditingController();
  final logoController = TextEditingController();
  final taxIDController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Lista para teléfonos múltiples
  List<String> phoneNumbers = [];

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
    nameController.dispose();
    logoController.dispose();
    taxIDController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _addPhoneNumber() {
    if (phoneController.text.isNotEmpty) {
      setState(() {
        phoneNumbers.add(phoneController.text);
        viewModel.input.laboratoryInfo.contactPhoneNumbers = phoneNumbers;
        phoneController.clear();
      });
    }
  }

  void _removePhoneNumber(int index) {
    setState(() {
      phoneNumbers.removeAt(index);
      viewModel.input.laboratoryInfo.contactPhoneNumbers = phoneNumbers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.business_outlined,
          title: l10n.createThing(l10n.company),
          loading: viewModel.loading,
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección: Información de la Empresa
                  Text(
                    l10n.companyInformation,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    labelText: l10n.name,
                    controller: nameController,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.name = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    labelText: l10n.taxID,
                    controller: taxIDController,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.taxID = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    labelText: '${l10n.logo} (${l10n.optional})',
                    controller: logoController,
                    isDense: true,
                    fieldLength: FormFieldLength.email,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.logo = value;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Sección: Información del Laboratorio
                  Text(
                    l10n.laboratoryInformation,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    labelText: l10n.address,
                    controller: addressController,
                    isDense: true,
                    fieldLength: FormFieldLength.email,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.laboratoryInfo.address = value;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo para agregar teléfonos
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: l10n.phoneNumber,
                          controller: phoneController,
                          isDense: true,
                          fieldLength: FormFieldLength.name,
                          counterText: "",
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: _addPhoneNumber,
                        tooltip: l10n.addPhoneNumber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Lista de teléfonos agregados
                  if (phoneNumbers.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          phoneNumbers.asMap().entries.map((entry) {
                            return Chip(
                              label: Text(entry.value),
                              onDeleted: () => _removePhoneNumber(entry.key),
                              deleteIcon: const Icon(Icons.close, size: 18),
                            );
                          }).toList(),
                    ),
                  ],
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
                  onPressed: () {
                    context.pop();
                  },
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed:
                      viewModel.loading
                          ? null
                          : () async {
                            if (formKey.currentState!.validate()) {
                              var isErr = await viewModel.create();

                              if (!isErr) {
                                if (!context.mounted) return;
                                context.pop(true);
                              }
                            }
                          },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.createThing(l10n.company)),
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
}
