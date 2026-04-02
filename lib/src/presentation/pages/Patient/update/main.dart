import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
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
        // Extraer datos del objeto Person o Animal
        String firstName = '';
        String lastName = '';
        int? birthDate;
        String dni = '';
        String phone = '';
        String email = '';
        String address = '';
        
        if (viewModel.currentPatient!.isPerson) {
          final person = viewModel.currentPatient!.asPerson!;
          firstName = person.firstName;
          lastName = person.lastName;
          birthDate = person.birthDate;
          dni = person.dni;
          phone = person.phone;
          email = person.email;
          address = person.address;
        } else if (viewModel.currentPatient!.isAnimal) {
          final animal = viewModel.currentPatient!.asAnimal!;
          firstName = animal.firstName;
          lastName = animal.lastName;
          birthDate = animal.birthDate;
          // Animal no tiene dni, phone, email, address - dejar vacíos
        }
        
        firstNameController = TextEditingController(text: firstName);
        lastNameController = TextEditingController(text: lastName);
        dniController = TextEditingController(text: dni);
        phoneController = TextEditingController(text: phone);
        emailController = TextEditingController(text: email);
        addressController = TextEditingController(text: address);
        
        // Formatear birthDate
        String formattedDate = '';
        if (birthDate != null && birthDate > 0) {
          try {
            final date = DateTime.fromMillisecondsSinceEpoch(birthDate * 1000);
            formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
    if (viewModel.currentPatient?.patientData == null) {
      return null;
    }
    
    try {
      if (viewModel.currentPatient!.isPerson) {
        return viewModel.currentPatient!.asPerson!.sex;
      } else if (viewModel.currentPatient!.isAnimal) {
        return viewModel.currentPatient!.asAnimal!.sex;
      }
      
      return null;
    } catch (e) {
      debugPrint('⚠️ Error obteniendo sex: $e');
      return null;
    }
  }
  
  // Método auxiliar para obtener la especie
  String _getSpecies() {
    if (viewModel.currentPatient?.patientData == null) {
      return '-';
    }
    
    try {
      // Solo los animales tienen species
      if (viewModel.currentPatient!.isAnimal) {
        final species = viewModel.currentPatient!.asAnimal!.species;
        return species.isNotEmpty ? species : '-';
      }
      
      return '-';
    } catch (e) {
      debugPrint('⚠️ Error obteniendo species: $e');
      return '-';
    }
  }

  String formatTimestamp(num timestamp) {
    try {
      // Convertir timestamp Unix (segundos o milisegundos) a DateTime
      final date = timestamp > 9999999999 
        ? DateTime.fromMillisecondsSinceEpoch(timestamp.toInt())
        : DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
      
      // Obtener l10n actual del context
      final l10n = AppLocalizations.of(context)!;
      
      // Obtener mes traducido según el idioma actual
      final months = [
        l10n.january, l10n.february, l10n.march, l10n.april, 
        l10n.may, l10n.june, l10n.july, l10n.august, 
        l10n.september, l10n.october, l10n.november, l10n.december
      ];
      
      // Detectar idioma actual
      final locale = Localizations.localeOf(context).languageCode;
      
      // Formatear según el idioma
      if (locale == 'es') {
        // Español: "27 de enero de 2026"
        return '${date.day} de ${months[date.month - 1]} de ${date.year}';
      } else {
        // Inglés: "January 27, 2026"
        return '${months[date.month - 1]} ${date.day}, ${date.year}';
      }
    } catch (e) {
      return timestamp.toString();
    }
  }

  Future<void> _handleSave() async {
    if (formKey.currentState!.validate()) {
      final isErr = await viewModel.update();
      if (!isErr && context.mounted) {
        context.pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(l10n.updateThing(l10n.patient)),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          // Mostrar error si ocurrió
          if (viewModel.error && !viewModel.loading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.somethingWentWrong,
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.pop(false),
                    child: Text(l10n.cancel),
                  ),
                ],
              ),
            );
          }
          
          // Mostrar loading mientras carga datos iniciales
          if (!_controllersInitialized || viewModel.currentPatient == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Formulario con datos prellenados
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 9, child: _buildMainForm(l10n, colorScheme, textTheme)),
                        const SizedBox(width: 24),
                        Expanded(flex: 5, child: _buildSidePanel(l10n, colorScheme, textTheme)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildMainForm(l10n, colorScheme, textTheme),
                        const SizedBox(height: 24),
                        _buildSidePanel(l10n, colorScheme, textTheme),
                      ],
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainForm(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.patientInformation, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l10n.updatePatientData, style: textTheme.bodyMedium),
              const Divider(height: 48),
              
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
                            if (viewModel.currentPatient!.isPerson) {
                              viewModel.inputPerson.firstName = value;
                            } else if (viewModel.currentPatient!.isAnimal) {
                              viewModel.inputPatient.animalData?.firstName = value;
                            }
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
                            if (viewModel.currentPatient!.isPerson) {
                              viewModel.inputPerson.lastName = value;
                            } else if (viewModel.currentPatient!.isAnimal) {
                              viewModel.inputPatient.animalData?.lastName = value;
                            }
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
                          isEnabled: viewModel.currentPatient?.isPerson ?? true,
                          onChange: (value) {
                            if (viewModel.currentPatient!.isPerson) {
                              viewModel.inputPerson.dni = value;
                            }
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
                          isEnabled: viewModel.currentPatient?.isPerson ?? true,
                          onChange: (value) {
                            if (viewModel.currentPatient!.isPerson) {
                              viewModel.inputPerson.phone = value;
                            }
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
                    isEnabled: viewModel.currentPatient?.isPerson ?? true,
                    onChange: (value) {
                      if (viewModel.currentPatient!.isPerson) {
                        viewModel.inputPerson.email = value;
                      }
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
                    isEnabled: viewModel.currentPatient?.isPerson ?? true,
                    onChange: (value) {
                      if (viewModel.currentPatient!.isPerson) {
                        viewModel.inputPerson.address = value;
                      }
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
                        final formattedDate = '$day/$month/$year 00:00';
                        
                        if (viewModel.currentPatient!.isPerson) {
                          viewModel.inputPerson.birthDate = formattedDate;
                        } else if (viewModel.currentPatient!.isAnimal) {
                          viewModel.inputPatient.animalData?.birthDate = formattedDate;
                        }
                      }
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidePanel(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        Card(
          elevation: 0,
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.referenceData, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _readOnlyInfo(l10n.sex, getSexLabel(context, _getPatientSex()), textTheme, Icons.wc_outlined),
                const SizedBox(height: 20),
                _readOnlyInfo(l10n.species, _getSpecies(), textTheme, Icons.pets_outlined),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Botones de acción
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Botón Cancelar
              OutlinedButton(
                onPressed: () => context.pop(),
                child: Text(l10n.cancel),
              ),
              
              const SizedBox(width: 12),
              
              // Botón Guardar o Loader
              viewModel.loading
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: _handleSave,
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: Text(l10n.save),
                    ),
            ],
          ),
        )
      ],
    );
  }

  Widget _readOnlyInfo(String label, String value, TextTheme textTheme, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: textTheme.bodySmall?.color?.withOpacity(0.6)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: textTheme.labelMedium?.copyWith(color: textTheme.bodySmall?.color)),
              Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
