import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';

class PatientUpdatePage extends StatefulWidget {
  const PatientUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<PatientUpdatePage> createState() => _PatientUpdatePageState();
}

class _PatientUpdatePageState extends State<PatientUpdatePage> {
  late ViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Controllers para campos editables
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController dniController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController birthDateController;
  
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, patientId: widget.id);
    
    // Escuchar cambios del ViewModel para inicializar controllers
    viewModel.addListener(_updateControllers);
  }
  
  void _updateControllers() {
    // Inicializar controllers cuando los datos se carguen
    if (viewModel.currentPatient != null && !viewModel.loading && !_controllersInitialized) {
      setState(() {
        firstNameController = TextEditingController(
          text: viewModel.currentPatient!.firstName
        );
        lastNameController = TextEditingController(
          text: viewModel.currentPatient!.lastName
        );
        dniController = TextEditingController(
          text: viewModel.currentPatient!.dni ?? ''
        );
        phoneController = TextEditingController(
          text: viewModel.currentPatient!.phone ?? ''
        );
        emailController = TextEditingController(
          text: viewModel.currentPatient!.email ?? ''
        );
        addressController = TextEditingController(
          text: viewModel.currentPatient!.address ?? ''
        );
        
        // Formatear birthDate (timestamp int a fecha legible)
        String formattedDate = '';
        if (viewModel.currentPatient!.birthDate != null && viewModel.currentPatient!.birthDate! > 0) {
          try {
            // Convertir timestamp (segundos) a DateTime
            final date = DateTime.fromMillisecondsSinceEpoch(viewModel.currentPatient!.birthDate! * 1000);
            formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          } catch (e) {
            formattedDate = '';
          }
        }
        birthDateController = TextEditingController(text: formattedDate);
        
        _controllersInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    viewModel.removeListener(_updateControllers);
    if (_controllersInitialized) {
      firstNameController.dispose();
      lastNameController.dispose();
      dniController.dispose();
      phoneController.dispose();
      emailController.dispose();
      addressController.dispose();
      birthDateController.dispose();
    }
    super.dispose();
  }
  
  String getSexLabel(BuildContext context, Sex? sex) {
    final l10n = AppLocalizations.of(context)!;
    if (sex == null) return '-';
    
    switch (sex) {
      case Sex.fEMALE:
        return l10n.sexFemale;
      case Sex.mALE:
        return l10n.sexMale;
      case Sex.iNTERSEX:
        return l10n.sexIntersex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        // Mostrar error si ocurrió
        if (viewModel.error && !viewModel.loading) {
          return ContentDialog(
            icon: Icons.error_outline,
            title: l10n.somethingWentWrong,
            loading: false,
            form: Form(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.somethingWentWrong),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.pop(false),
                      child: Text(l10n.cancel),
                    ),
                  ],
                ),
              ),
            ),
            actions: [],
          );
        }
        
        // Mostrar loading mientras carga datos iniciales
        if (!_controllersInitialized || viewModel.currentPatient == null) {
          return ContentDialog(
            icon: Icons.person,
            title: l10n.updateThing(l10n.patient),
            loading: true,
            form: Form(child: const Center(child: CircularProgressIndicator())),
            actions: [],
          );
        }
        
        // Formulario con datos prellenados
        return ContentDialog(
          icon: Icons.person,
          title: l10n.updateThing(l10n.patient),
          loading: viewModel.loading,
          maxWidth: 600,
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
                  
                  // DNI y Teléfono en la misma fila
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: l10n.dni,
                          controller: dniController,
                          isDense: true,
                          fieldLength: 20,
                          counterText: "",
                          onChange: (value) {
                            viewModel.input.dni = value;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextFormField(
                          labelText: l10n.phoneNumber,
                          controller: phoneController,
                          isDense: true,
                          fieldLength: 20,
                          counterText: "",
                          onChange: (value) {
                            viewModel.input.phone = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Email
                  CustomTextFormField(
                    labelText: l10n.email,
                    controller: emailController,
                    isDense: true,
                    fieldLength: FormFieldLength.email,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.email = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dirección
                  CustomTextFormField(
                    labelText: l10n.address,
                    controller: addressController,
                    isDense: true,
                    fieldLength: 100,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.address = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Fecha de Nacimiento
                  CustomTextFormField(
                    labelText: l10n.birthDate,
                    controller: birthDateController,
                    isDense: true,
                    fieldLength: 10,
                    counterText: "",
                    readOnly: true,
                    onTap: () async {
                      DateTime? initialDate;
                      try {
                        if (birthDateController.text.isNotEmpty) {
                          initialDate = DateTime.parse(birthDateController.text);
                        }
                      } catch (e) {
                        initialDate = DateTime.now();
                      }
                      
                      final date = await showDatePicker(
                        context: context,
                        initialDate: initialDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      
                      if (date != null) {
                        final formatted = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                        birthDateController.text = formatted;
                        // ✅ Formatear al formato esperado por el servidor (DD/MM/YYYY HH:MM)
                        // Solo se asigna cuando el usuario selecciona una fecha (validación diferencial)
                        final day = date.day.toString().padLeft(2, '0');
                        final month = date.month.toString().padLeft(2, '0');
                        final year = date.year.toString();
                        viewModel.input.birthDate = '$day/$month/$year 00:00';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Campos de solo lectura (no están en UpdatePatientInput)
                  Card(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información no editable',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 12),
                          _buildReadOnlyField(
                            l10n.sex,
                            getSexLabel(context, viewModel.currentPatient!.sex)
                          ),
                          const SizedBox(height: 8),
                          _buildReadOnlyField(
                            l10n.species, 
                            viewModel.currentPatient!.species.isNotEmpty
                              ? viewModel.currentPatient!.species
                              : '-'
                          ),
                        ],
                      ),
                    ),
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
                  child: Text(l10n.cancel),
                  onPressed: () => context.pop(false),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: viewModel.loading ? null : () async {
                    if (formKey.currentState!.validate()) {
                      var isErr = await viewModel.update();
                      
                      if (!isErr) {
                        if (!context.mounted) return;
                        context.pop(true);
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.save),
                      if (viewModel.loading) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ] else ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.save, size: 18),
                      ],
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
  
  Widget _buildReadOnlyField(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
