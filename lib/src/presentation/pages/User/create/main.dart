import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import 'package:provider/provider.dart';
import './view_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Importación para web (package:web reemplaza dart:html)
import 'package:web/web.dart' show HTMLInputElement, FileReader;
import 'dart:js_interop';

// Clase wrapper para combinar Role y LabMemberRole
class UserRoleOption {
  final String id;
  final String label;
  final bool isAdmin;
  final LabMemberRole? employeeRole;
  
  UserRoleOption({
    required this.id,
    required this.label,
    required this.isAdmin,
    this.employeeRole,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleOption &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}

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

  UserRoleOption? selectedRole;
  DateTime? selectedCutOffDate;
  // selectedLaboratoryID se eliminó porque CreateUserInput no tiene ese campo

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
    if (phoneText.isNotEmpty) {
      setState(() {
        phoneNumbers.add(phoneText);
        phoneController.clear();

        viewModel.input.companyInfo ??= CreateCompanyInput();
        viewModel.input.companyInfo!.laboratoryInfo.contactPhoneNumbers = 
            List<String>.from(phoneNumbers);
      });
    }
  }

  void _removePhoneNumber(int index) {
    setState(() {
      phoneNumbers.removeAt(index);
      if (viewModel.input.companyInfo != null) {
        viewModel.input.companyInfo!.laboratoryInfo.contactPhoneNumbers = 
            List<String>.from(phoneNumbers);
      }
    });
  }

  Future<void> _pickAndUploadLogo(BuildContext context) async {
    try {
      debugPrint('🔧 Iniciando selección de archivo... (kIsWeb: $kIsWeb)');
      
      if (kIsWeb) {
        // Implementación específica para web usando dart:html (importado condicionalmente)
        debugPrint('🌐 Usando implementación web nativa');
        
        final uploadInput = HTMLInputElement();
        uploadInput.type = 'file';
        uploadInput.accept = 'image/jpeg,image/jpg,image/png,image/gif';
        uploadInput.click();

        // Esperar a que se seleccione un archivo
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Usar completer para manejar el evento de cambio
        final completer = Completer<void>();
        uploadInput.addEventListener('change', ((JSAny event) {
          completer.complete();
        }).toJS);
        
        await completer.future;

        final files = uploadInput.files;
        if (files != null && files.length > 0) {
          final file = files.item(0)!;
          final reader = FileReader();
          
          // Usar completer para el evento onload
          final loadCompleter = Completer<void>();
          reader.addEventListener('load', ((JSAny event) {
            loadCompleter.complete();
          }).toJS);
          
          reader.readAsArrayBuffer(file);
          await loadCompleter.future;

          final result = reader.result;
          final Uint8List fileBytes = (result as JSArrayBuffer).toDart.asUint8List();
          final String fileName = file.name;

          debugPrint('📄 Archivo web: $fileName, Bytes: ${fileBytes.length}');

          // Validar extensión
          final extension = fileName.split('.').last.toLowerCase();
          if (!['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Formato no válido. Usa JPG, JPEG, PNG o GIF')),
            );
            return;
          }

          // Subir archivo
          final success = await viewModel.uploadCompanyLogo(
            fileBytes: fileBytes,
            fileName: fileName,
            userId: 'user_create',
          );

          // Actualizar controller con el nombre original del archivo
          if (success && viewModel.displayFileName != null) {
            setState(() {
              companyLogoController.text = viewModel.displayFileName!;
            });
          }
        } else {
          debugPrint('ℹ️ Selección de archivo cancelada');
        }
      } else {
        // Para plataformas nativas (mobile/desktop) - no debería llegar aquí en web
        debugPrint('⚠️ Esta ruta solo funciona en web');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionalidad solo disponible en web')),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al seleccionar archivo: $e');
      debugPrint('💥 Tipo de error: ${e.runtimeType}');
      debugPrint('📍 StackTrace: $stackTrace');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Obtener roles permitidos según el rol del usuario loggeado
  List<UserRoleOption> getAvailableRoles(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authNotifier = context.read<AuthNotifier>();
    final currentUserRole = authNotifier.role;

    List<UserRoleOption> options = [];
    
    // Solo ROOT puede crear ADMIN
    if (currentUserRole == Role.rOOT) {
      options.add(UserRoleOption(
        id: 'admin',
        label: l10n.roleAdmin,
        isAdmin: true,
      ));
    }
    
    // Todos pueden crear roles de laboratorio (excepto ROOT)
    options.addAll([
      UserRoleOption(
        id: 'owner',
        label: l10n.roleOwner,
        isAdmin: false,
        employeeRole: LabMemberRole.oWNER,
      ),
      UserRoleOption(
        id: 'technician',
        label: l10n.roleTechnician,
        isAdmin: false,
        employeeRole: LabMemberRole.tECHNICIAN,
      ),
      UserRoleOption(
        id: 'billing',
        label: l10n.roleBilling,
        isAdmin: false,
        employeeRole: LabMemberRole.bILLING,
      ),
      UserRoleOption(
        id: 'bioanalyst',
        label: l10n.roleBioanalyst,
        isAdmin: false,
        employeeRole: LabMemberRole.bIOANALYST,
      ),
    ]);
    
    return options;
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
                        child: DropdownButtonFormField<UserRoleOption>(
                          value: selectedRole,
                          decoration: InputDecoration(
                            labelText: l10n.role,
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                          items: getAvailableRoles(context).map((UserRoleOption option) {
                            return DropdownMenuItem<UserRoleOption>(
                              value: option,
                              child: Text(option.label),
                            );
                          }).toList(),
                          onChanged: (UserRoleOption? newValue) {
                            setState(() {
                              selectedRole = newValue;
                              
                              if (newValue != null) {
                                // Asignar isAdmin y employeeRole según el rol seleccionado
                                viewModel.input.isAdmin = newValue.isAdmin;
                                viewModel.input.employeeRole = newValue.employeeRole;
                                
                                // Limpiar campos según el rol
                                if (newValue.id == 'owner') {
                                  // Owner: inicializar companyInfo
                                  viewModel.input.companyInfo ??= CreateCompanyInput();
                                } else if (newValue.id == 'technician' || newValue.id == 'billing' || newValue.id == 'bioanalyst') {
                                  // Employee roles: limpiar companyInfo, cutOffDate y fee
                                  viewModel.input.companyInfo = null;
                                  viewModel.input.cutOffDate = null;
                                  viewModel.input.fee = null;
                                  phoneNumbers.clear();
                                  companyNameController.clear();
                                  companyTaxIDController.clear();
                                  companyLogoController.clear();
                                  labAddressController.clear();
                                  phoneController.clear();
                                  cutOffDateController.clear();
                                  feeController.clear();
                                } else {
                                  // Admin: limpiar todo
                                  viewModel.input.companyInfo = null;
                                  viewModel.input.cutOffDate = null;
                                  viewModel.input.fee = null;
                                  viewModel.input.employeeRole = null;
                                  phoneNumbers.clear();
                                  companyNameController.clear();
                                  companyTaxIDController.clear();
                                  companyLogoController.clear();
                                  labAddressController.clear();
                                  phoneController.clear();
                                  cutOffDateController.clear();
                                  feeController.clear();
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (selectedRole?.id == 'owner') ...[
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.fieldRequired;
                              }
                              return null;
                            },
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.fieldRequired;
                              }
                              if (num.tryParse(value) == null) {
                                return l10n.invalidNumber;
                              }
                              return null;
                            },
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.fieldRequired;
                              }
                              return null;
                            },
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.fieldRequired;
                              }
                              return null;
                            },
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
                    // Logo con botón de upload
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            labelText: '${l10n.logo} (${l10n.optional})',
                            controller: companyLogoController,
                            isDense: true,
                            fieldLength: FormFieldLength.email,
                            counterText: "",
                            readOnly: true,
                            onTap: viewModel.uploading
                                ? null
                                : () => _pickAndUploadLogo(context),
                            suffixIcon: viewModel.uploading
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.upload_file),
                            onChange: (value) {
                              viewModel.input.companyInfo ??= CreateCompanyInput();
                              viewModel.input.companyInfo!.logo = value;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: FilledButton.icon(
                            onPressed:
                                viewModel.uploading
                                    ? null
                                    : () => _pickAndUploadLogo(context),
                            icon: viewModel.uploading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.upload_file),
                            label: Text(
                              viewModel.uploading
                                  ? 'Subiendo...'
                                  : 'Subir',
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Información del logo
                    if (viewModel.hasLogo)
                      const SizedBox(height: 12),
                    if (viewModel.hasLogo)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Logo seleccionado',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    viewModel.displayFileName ?? '',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.fieldRequired;
                        }
                        return null;
                      },
                      onChange: (value) {
                        viewModel.input.companyInfo ??= CreateCompanyInput();
                        viewModel.input.companyInfo!.laboratoryInfo.address = value;
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
                        children: phoneNumbers.asMap().entries.map((entry) {
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
                              // Validar teléfonos para Owner
                              if (selectedRole?.id == 'owner' && phoneNumbers.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.atLeastOnePhoneRequired),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // Asignar cutOffDate como string en formato dd/MM/yyyy HH:mm
                              if (selectedRole?.id == 'owner' &&
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
                              } else if (selectedRole?.id == 'owner') {
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
