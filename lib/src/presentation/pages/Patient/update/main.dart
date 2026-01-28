import 'dart:convert';
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
        // Parsear patientData desde JSON string
        Map<String, dynamic>? patientDataMap;
        try {
          if (viewModel.currentPatient!.patientData.isNotEmpty) {
            patientDataMap = Map<String, dynamic>.from(
              const JsonDecoder().convert(viewModel.currentPatient!.patientData)
            );
          }
        } catch (e) {
          debugPrint('⚠️ Error parseando patientData: $e');
        }
        
        // Acceder a propiedades del JSON según el tipo
        String firstName = '';
        String lastName = '';
        String? birthDate;
        String dni = '';
        String phone = '';
        String email = '';
        String address = '';
        
        if (patientDataMap != null) {
          firstName = patientDataMap['firstName']?.toString() ?? '';
          lastName = patientDataMap['lastName']?.toString() ?? '';
          
          // Manejar birthDate (puede ser int o string)
          var birthDateValue = patientDataMap['birthDate'];
          if (birthDateValue is int) {
            birthDate = birthDateValue.toString();
          } else if (birthDateValue is String) {
            birthDate = birthDateValue;
          }
          
          // Campos solo en Person (no en Animal)
          dni = patientDataMap['dni']?.toString() ?? '';
          phone = patientDataMap['phone']?.toString() ?? '';
          email = patientDataMap['email']?.toString() ?? '';
          address = patientDataMap['address']?.toString() ?? '';
        }
        
        firstNameController = TextEditingController(text: firstName);
        lastNameController = TextEditingController(text: lastName);
        dniController = TextEditingController(text: dni);
        phoneController = TextEditingController(text: phone);
        emailController = TextEditingController(text: email);
        addressController = TextEditingController(text: address);
        
        // Formatear birthDate
        String formattedDate = '';
        if (birthDate != null && birthDate.isNotEmpty) {
          try {
            // Si es timestamp (número), convertir
            if (int.tryParse(birthDate) != null) {
              final timestamp = int.parse(birthDate);
              final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
              formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            } else {
              // Si es string de fecha, intentar parsear
              final date = DateTime.parse(birthDate);
              formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            }
          } catch (e) {
            debugPrint('⚠️ Error formateando birthDate: $e');
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
  
  // Método auxiliar para obtener el sex del patientData
  Sex? _getPatientSex() {
    if (viewModel.currentPatient?.patientData == null || viewModel.currentPatient!.patientData.isEmpty) {
      return null;
    }
    
    try {
      final patientDataMap = Map<String, dynamic>.from(
        const JsonDecoder().convert(viewModel.currentPatient!.patientData)
      );
      
      final sexValue = patientDataMap['sex'];
      if (sexValue == null) return null;
      
      // Convertir string a enum Sex
      if (sexValue == 'FEMALE') return Sex.fEMALE;
      if (sexValue == 'MALE') return Sex.mALE;
      if (sexValue == 'INTERSEX') return Sex.iNTERSEX;
      
      return null;
    } catch (e) {
      debugPrint('⚠️ Error obteniendo sex: $e');
      return null;
    }
  }
  
  // Método auxiliar para obtener la especie
  String _getSpecies() {
    if (viewModel.currentPatient?.patientData == null || viewModel.currentPatient!.patientData.isEmpty) {
      return '-';
    }
    
    try {
      final patientDataMap = Map<String, dynamic>.from(
        const JsonDecoder().convert(viewModel.currentPatient!.patientData)
      );
      
      final species = patientDataMap['species']?.toString() ?? '';
      return species.isNotEmpty ? species : '-';
    } catch (e) {
      debugPrint('⚠️ Error obteniendo species: $e');
      return '-';
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
                            getSexLabel(context, _getPatientSex())
                          ),
                          const SizedBox(height: 8),
                          _buildReadOnlyField(
                            l10n.species, 
                            _getSpecies()
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
