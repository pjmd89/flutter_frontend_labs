import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
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
      case Sex.fEMALE:
        return l10n.sexFemale;
      case Sex.mALE:
        return l10n.sexMale;
      case Sex.iNTERSEX:
        return l10n.sexIntersex;
    }
  }

  String getPatientTypeLabel(BuildContext context, PatientType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case PatientType.hUMAN:
        return l10n.patientTypeHuman;
      case PatientType.aNIMAL:
        return l10n.patientTypeAnimal;
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
          title: l10n.createThing(l10n.patient),
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
                  // Tipo de Paciente y Fecha de Nacimiento en la misma fila
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<PatientType>(
                          value: selectedPatientType,
                          decoration: InputDecoration(
                            labelText: l10n.patientType,
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                          items: PatientType.values.map((PatientType type) {
                            return DropdownMenuItem<PatientType>(
                              value: type,
                              child: Text(getPatientTypeLabel(context, type)),
                            );
                          }).toList(),
                          onChanged: (PatientType? newValue) {
                            setState(() {
                              selectedPatientType = newValue;
                              viewModel.input.patientType = newValue ?? PatientType.hUMAN;
                              
                              // Si cambia a HUMAN, limpiar campo species
                              if (newValue == PatientType.hUMAN) {
                                speciesController.clear();
                                viewModel.input.species = null;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          labelText: l10n.birthDate,
                          controller: birthDateController,
                          isDense: true,
                          fieldLength: FormFieldLength.name,
                          readOnly: true,
                          counterText: "",
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedBirthDate ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              final dateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                0,
                                0,
                              );

                              setState(() {
                                selectedBirthDate = dateTime;
                                final day = dateTime.day.toString().padLeft(2, '0');
                                final month = dateTime.month.toString().padLeft(2, '0');
                                final year = dateTime.year.toString();

                                birthDateController.text = '$day/$month/$year';
                                viewModel.input.birthDate = '$day/$month/$year 00:00';
                              });
                            }
                          },
                          onChange: (_) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sexo
                  DropdownButtonFormField<Sex>(
                    value: selectedSex,
                    decoration: InputDecoration(
                      labelText: l10n.sex,
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
                        viewModel.input.sex = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return l10n.emptyFieldError;
                      }
                      return null;
                    },
                  ),
                  
                  // Campos condicionales según tipo de paciente
                  if (selectedPatientType == PatientType.hUMAN) ...[
                    const SizedBox(height: 16),
                    // DNI, Teléfono, Email para HUMAN
                    CustomTextFormField(
                      labelText: l10n.dni,
                      controller: dniController,
                      isDense: true,
                      fieldLength: FormFieldLength.name,
                      counterText: "",
                      onChange: (value) {
                        viewModel.input.dni = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            labelText: l10n.phone,
                            controller: phoneController,
                            isDense: true,
                            fieldLength: FormFieldLength.name,
                            counterText: "",
                            onChange: (value) {
                              viewModel.input.phone = value;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      labelText: l10n.address,
                      controller: addressController,
                      isDense: true,
                      fieldLength: FormFieldLength.email,
                      counterText: "",
                      onChange: (value) {
                        viewModel.input.address = value;
                      },
                    ),
                  ] else if (selectedPatientType == PatientType.aNIMAL) ...[
                    const SizedBox(height: 16),
                    // Species para ANIMAL
                    CustomTextFormField(
                      labelText: l10n.species,
                      controller: speciesController,
                      isDense: true,
                      fieldLength: FormFieldLength.name,
                      counterText: "",
                      onChange: (value) {
                        viewModel.input.species = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.emptyFieldError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      labelText: l10n.address,
                      controller: addressController,
                      isDense: true,
                      fieldLength: FormFieldLength.email,
                      counterText: "",
                      onChange: (value) {
                        viewModel.input.address = value;
                      },
                    ),
                  ],
                  
                  // Laboratory is taken from current context; no manual selection needed
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
                  onPressed: viewModel.loading
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
                      Text(l10n.createThing(l10n.patient)),
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
