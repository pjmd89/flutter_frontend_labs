import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';

class UserCreatePage extends StatefulWidget {
  const UserCreatePage({super.key});

  @override
  State<UserCreatePage> createState() => _UserCreatePageState();
}

class _UserCreatePageState extends State<UserCreatePage> {
  late ViewModel viewModel;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final cutOffDateController = TextEditingController();
  final feeController = TextEditingController();

  // Controllers para CreateCompanyInput
  final companyNameController = TextEditingController();
  final companyTaxIDController = TextEditingController();
  final companyLogoController = TextEditingController();
  final labAddressController = TextEditingController();
  final phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Role? selectedRole;
  DateTime? selectedCutOffDate;

  // Lista para teléfonos múltiples del laboratorio
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
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    cutOffDateController.dispose();
    feeController.dispose();
    companyNameController.dispose();
    companyTaxIDController.dispose();
    companyLogoController.dispose();
    labAddressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _addPhoneNumber() {
    final phoneText = phoneController.text.trim();
    debugPrint('Intentando agregar teléfono: "$phoneText"');

    if (phoneText.isNotEmpty) {
      setState(() {
        phoneNumbers.add(phoneText);
        phoneController.clear();

        // Inicializar companyInfo si no existe
        viewModel.input.companyInfo ??= CreateCompanyInput();

        // Actualizar la lista de teléfonos
        viewModel
            .input
            .companyInfo!
            .laboratoryInfo
            .contactPhoneNumbers = List<String>.from(phoneNumbers);

        debugPrint('Teléfono agregado. Total: ${phoneNumbers.length}');
      });
    } else {
      debugPrint('Campo de teléfono vacío');
    }
  }

  void _removePhoneNumber(int index) {
    setState(() {
      phoneNumbers.removeAt(index);

      if (viewModel.input.companyInfo != null) {
        viewModel
            .input
            .companyInfo!
            .laboratoryInfo
            .contactPhoneNumbers = List<String>.from(phoneNumbers);
      }
    });
  }

  String getRoleLabel(BuildContext context, Role role) {
    final l10n = AppLocalizations.of(context)!;
    switch (role) {
      case Role.root:
        return l10n.roleRoot;
      case Role.admin:
        return l10n.roleAdmin;
      case Role.owner:
        return l10n.roleOwner;
      case Role.technician:
        return l10n.roleTechnician;
      case Role.billing:
        return l10n.roleBilling;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.person_add,
          title: l10n.createThing(l10n.user),
          loading: viewModel.loading,
          maxWidth: 700,
          minWidth: 700,
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                          onChange: (value) {
                            viewModel.input.firstName = value;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          labelText: l10n.lastName,
                          controller: lastNameController,
                          isDense: true,
                          fieldLength: FormFieldLength.name,
                          counterText: "",
                          onChange: (value) {
                            viewModel.input.lastName = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Email y Rol en la misma fila
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextFormField(
                          labelText: l10n.email,
                          controller: emailController,
                          isDense: true,
                          fieldLength: FormFieldLength.email,
                          counterText: "",
                          onChange: (value) {
                            viewModel.input.email = value;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<Role>(
                          value: selectedRole,
                          decoration: InputDecoration(
                            labelText: l10n.role,
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                          items:
                              Role.values.map((Role role) {
                                return DropdownMenuItem<Role>(
                                  value: role,
                                  child: Text(getRoleLabel(context, role)),
                                );
                              }).toList(),
                          onChanged: (Role? newValue) {
                            setState(() {
                              selectedRole = newValue;
                              viewModel.input.isAdmin = newValue == Role.admin;

                              // Inicializar companyInfo cuando se selecciona owner
                              if (newValue == Role.owner) {
                                viewModel.input.companyInfo ??=
                                    CreateCompanyInput();
                              } else {
                                // Limpiar companyInfo cuando no es owner
                                viewModel.input.companyInfo = null;
                                phoneNumbers.clear();
                                companyNameController.clear();
                                companyTaxIDController.clear();
                                companyLogoController.clear();
                                labAddressController.clear();
                                phoneController.clear();
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (selectedRole == Role.owner) ...[
                    const SizedBox(height: 16),
                    // CutOffDate y Fee en la misma fila
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            labelText: l10n.cutOffDate,
                            controller: cutOffDateController,
                            isDense: true,
                            fieldLength: FormFieldLength.password,
                            readOnly: true,
                            counterText: "",
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    selectedCutOffDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                // Asignar hora fija 00:00
                                final dateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  0,
                                  0,
                                );

                                setState(() {
                                  selectedCutOffDate = dateTime;
                                  // Formato: dd/MM/yyyy HH:mm
                                  final day = dateTime.day.toString().padLeft(
                                    2,
                                    '0',
                                  );
                                  final month = dateTime.month
                                      .toString()
                                      .padLeft(2, '0');
                                  final year = dateTime.year.toString();

                                  cutOffDateController.text =
                                      '$day/$month/$year 00:00';
                                });
                              }
                            },
                            onChange: (_) {}, // No hacer nada aquí
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextFormField(
                            labelText: l10n.fee,
                            controller: feeController,
                            isDense: true,
                            fieldLength: FormFieldLength.password,
                            counterText: "",
                            onChange: (value) {
                              viewModel.input.fee = num.tryParse(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sección: Información de la Empresa
                    Text(
                      l10n.companyInformation,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    // Nombre de empresa y TaxID en la misma fila
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomTextFormField(
                            labelText: l10n.name,
                            controller: companyNameController,
                            isDense: true,
                            fieldLength: FormFieldLength.name,
                            counterText: "",
                            onChange: (value) {
                              viewModel.input.companyInfo ??=
                                  CreateCompanyInput();
                              viewModel.input.companyInfo!.name = value;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: CustomTextFormField(
                            labelText: l10n.taxID,
                            controller: companyTaxIDController,
                            isDense: true,
                            fieldLength: FormFieldLength.name,
                            counterText: "",
                            onChange: (value) {
                              viewModel.input.companyInfo ??=
                                  CreateCompanyInput();
                              viewModel.input.companyInfo!.taxID = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Logo (opcional) - ancho completo
                    CustomTextFormField(
                      labelText: '${l10n.logo} (${l10n.optional})',
                      controller: companyLogoController,
                      isDense: true,
                      fieldLength: FormFieldLength.email,
                      counterText: "",
                      onChange: (value) {
                        viewModel.input.companyInfo ??= CreateCompanyInput();
                        viewModel.input.companyInfo!.logo = value;
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
                      controller: labAddressController,
                      isDense: true,
                      fieldLength: FormFieldLength.email,
                      counterText: "",
                      onChange: (value) {
                        viewModel.input.companyInfo ??= CreateCompanyInput();
                        viewModel.input.companyInfo!.laboratoryInfo.address =
                            value;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo para agregar teléfonos
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            labelText: l10n.phoneNumber,
                            controller: phoneController,
                            isDense: true,
                            fieldLength: FormFieldLength.name,
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: _addPhoneNumber,
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(l10n.addPhoneNumber),
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
                              // Asignar cutOffDate como string en formato dd/MM/yyyy HH:mm
                              if (selectedRole == Role.owner &&
                                  selectedCutOffDate != null) {
                                final day = selectedCutOffDate!.day
                                    .toString()
                                    .padLeft(2, '0');
                                final month = selectedCutOffDate!.month
                                    .toString()
                                    .padLeft(2, '0');
                                final year =
                                    selectedCutOffDate!.year.toString();

                                // Formato: dd/MM/yyyy 00:00
                                viewModel.input.cutOffDate =
                                    '$day/$month/$year 00:00';
                              } else if (selectedRole == Role.owner) {
                                viewModel.input.cutOffDate = null;
                              }
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
                      Text(l10n.createThing(l10n.user)),
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
