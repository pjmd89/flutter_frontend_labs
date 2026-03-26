import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' show HTMLInputElement, FileReader;
import 'dart:js_interop';

void main() => runApp(const LabApp());

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UserCreatePage(),
    );
  }
}

class UserCreatePage extends StatefulWidget {
  const UserCreatePage({super.key});

  @override
  State<UserCreatePage> createState() => _UserCreatePageState();
}

class _UserCreatePageState extends State<UserCreatePage> {
  late ViewModel viewModel;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _companyNameController;
  late TextEditingController _companyTaxIDController;
  late TextEditingController _laboratoryAddressController;
  late TextEditingController _laboratoryPhonesController;
  late TextEditingController _cutOffDateController;
  late TextEditingController _managementFeeController;

  bool _isAdmin = false;
  String _selectedRole = "tECHNICIAN";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _companyNameController = TextEditingController();
    _companyTaxIDController = TextEditingController();
    _laboratoryAddressController = TextEditingController();
    _laboratoryPhonesController = TextEditingController();
    _cutOffDateController = TextEditingController();
    _managementFeeController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _companyNameController.dispose();
    _companyTaxIDController.dispose();
    _laboratoryAddressController.dispose();
    _laboratoryPhonesController.dispose();
    _cutOffDateController.dispose();
    _managementFeeController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final String d = date.day.toString().padLeft(2, '0');
      final String m = date.month.toString().padLeft(2, '0');
      final String y = date.year.toString();
      
      final String formattedDate = "$d/$m/$y";
      final String formattedFull = "$formattedDate 00:00";

      setState(() {
        _cutOffDateController.text = formattedDate;
        viewModel.input.cutOffDate = formattedFull;
      });
    }
  }

  Future<void> _pickAndUploadLogo(BuildContext context) async {
    try {
      debugPrint('🔧 Iniciando selección de archivo... (kIsWeb: $kIsWeb)');
      
      if (kIsWeb) {
        debugPrint('🌐 Usando implementación web nativa');
        
        final uploadInput = HTMLInputElement();
        uploadInput.type = 'file';
        uploadInput.accept = 'image/jpeg,image/jpg,image/png,image/gif';
        uploadInput.click();

        await Future.delayed(const Duration(milliseconds: 100));
        
        final completer = Completer<void>();
        uploadInput.addEventListener('change', ((JSAny event) {
          completer.complete();
        }).toJS);
        
        await completer.future;

        final files = uploadInput.files;
        if (files != null && files.length > 0) {
          final file = files.item(0)!;
          final reader = FileReader();
          
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

          final extension = fileName.split('.').last.toLowerCase();
          if (!['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
            if (!context.mounted) return;
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.invalidFileFormat)),
            );
            return;
          }

          final success = await viewModel.uploadCompanyLogo(
            fileBytes: fileBytes,
            fileName: fileName,
            userId: 'user_create',
          );

          if (success) {
            setState(() {
              // Logo actualizado, el UI se refrescará automáticamente
            });
          }
        } else {
          debugPrint('ℹ️ Selección de archivo cancelada');
        }
      } else {
        debugPrint('⚠️ Esta ruta solo funciona en web');
        if (!context.mounted) return;
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.onlyAvailableOnWeb)),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.createThing(l10n.user)),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          body: CreateUserDrawer(
            isAdmin: _isAdmin,
            onAdminChanged: (value) => setState(() => _isAdmin = value),
            selectedRole: _selectedRole,
            onRoleChanged: (value) {
              setState(() {
                if (value != null) {
                  _selectedRole = value.toString().split('.').last;
                  viewModel.input.employeeRole = value;
                }
              });
            },
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            emailController: _emailController,
            companyNameController: _companyNameController,
            companyTaxIDController: _companyTaxIDController,
            laboratoryAddressController: _laboratoryAddressController,
            laboratoryPhonesController: _laboratoryPhonesController,
            cutOffDateController: _cutOffDateController,
            managementFeeController: _managementFeeController,
            viewModel: viewModel,
            formKey: formKey,
            onCutOffDateTap: _pickDate,
            onLogoUploadTap: () => _pickAndUploadLogo(context),
            onFirstNameChanged: (value) => viewModel.input.firstName = value,
            onLastNameChanged: (value) => viewModel.input.lastName = value,
            onEmailChanged: (value) => viewModel.input.email = value,
            onCompanyNameChanged: (value) {
              viewModel.input.companyInfo ??= CreateCompanyInput();
              viewModel.input.companyInfo?.name = value;
            },
            onCompanyTaxIDChanged: (value) {
              viewModel.input.companyInfo ??= CreateCompanyInput();
              viewModel.input.companyInfo?.taxID = value;
            },
            onLaboratoryAddressChanged: (value) {
              viewModel.input.companyInfo ??= CreateCompanyInput();
              viewModel.input.companyInfo?.laboratoryInfo.address = value;
            },
            onLaboratoryPhonesChanged: (value) {
              viewModel.input.companyInfo ??= CreateCompanyInput();
              viewModel.input.companyInfo?.laboratoryInfo.contactPhoneNumbers = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
            },
            onCutOffDateChanged: (value) => viewModel.input.cutOffDate = value,
            onManagementFeeChanged: (value) {
              viewModel.input.fee = num.tryParse(value);
            },
          ),
        );
      },
    );
  }
}

class CreateUserDrawer extends StatelessWidget {
  final bool isAdmin;
  final Function(bool) onAdminChanged;
  final String selectedRole;
  final Function(LabMemberRole?) onRoleChanged;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController companyNameController;
  final TextEditingController companyTaxIDController;
  final TextEditingController laboratoryAddressController;
  final TextEditingController laboratoryPhonesController;
  final TextEditingController cutOffDateController;
  final TextEditingController managementFeeController;
  final ViewModel viewModel;
  final GlobalKey<FormState> formKey;
  final VoidCallback onCutOffDateTap;
  final VoidCallback onLogoUploadTap;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onCompanyNameChanged;
  final Function(String) onCompanyTaxIDChanged;
  final Function(String) onLaboratoryAddressChanged;
  final Function(String) onLaboratoryPhonesChanged;
  final Function(String) onCutOffDateChanged;
  final Function(String) onManagementFeeChanged;

  const CreateUserDrawer({
    super.key,
    required this.isAdmin,
    required this.onAdminChanged,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.companyNameController,
    required this.companyTaxIDController,
    required this.laboratoryAddressController,
    required this.laboratoryPhonesController,
    required this.cutOffDateController,
    required this.managementFeeController,
    required this.viewModel,
    required this.formKey,
    required this.onCutOffDateTap,
    required this.onLogoUploadTap,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onEmailChanged,
    required this.onCompanyNameChanged,
    required this.onCompanyTaxIDChanged,
    required this.onLaboratoryAddressChanged,
    required this.onLaboratoryPhonesChanged,
    required this.onCutOffDateChanged,
    required this.onManagementFeeChanged,
  });

  LabMemberRole? _getSelectedRole() {
    if (selectedRole.isEmpty) return LabMemberRole.tECHNICIAN;
    return LabMemberRole.values.firstWhere(
      (role) => role.toString().split('.').last.toLowerCase() == selectedRole.toLowerCase(),
      orElse: () => LabMemberRole.tECHNICIAN,
    );
  }

  bool _isUserAdminOrRoot(BuildContext context) {
    final authNotifier = context.read<AuthNotifier>();
    return authNotifier.role == Role.rOOT || authNotifier.role == Role.aDMIN;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fieldBg = theme.inputDecorationTheme.fillColor ?? (isDark ? theme.scaffoldBackgroundColor : theme.cardColor);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(l10n.user, Icons.person, context),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    l10n.createThing(l10n.firstName),
                    l10n.firstName,
                    fieldBg,
                    controller: firstNameController,
                    context: context,
                    onChanged: onFirstNameChanged,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    l10n.createThing(l10n.lastName),
                    l10n.lastName,
                    fieldBg,
                    controller: lastNameController,
                    context: context,
                    onChanged: onLastNameChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              l10n.createThing(l10n.email),
              l10n.email,
              fieldBg,
              icon: Icons.mail_outline,
              controller: emailController,
              context: context,
              onChanged: onEmailChanged,
            ),
            
            const SizedBox(height: 32),
            _sectionTitle(l10n.role, Icons.person_outline, context),
            const SizedBox(height: 16),
            _buildDropdown(l10n.role, fieldBg, context),

            if (_getSelectedRole() == LabMemberRole.oWNER) ...[
              const SizedBox(height: 32),
              Divider(color: theme.dividerColor),
              const SizedBox(height: 16),
              _sectionTitle(l10n.companyInfo, Icons.business, context),
              const SizedBox(height: 16),
              _buildTextField(
                l10n.companyName,
                l10n.companyName,
                fieldBg,
                controller: companyNameController, 
                context: context,
                onChanged: onCompanyNameChanged,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.image,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      viewModel.hasLogo
                          ? viewModel.displayFileName ?? ''
                          : l10n.logo,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            viewModel.hasLogo ? FontWeight.normal : FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: viewModel.uploading
                        ? null
                        : () => onLogoUploadTap(),
                    icon: viewModel.uploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.upload_file, size: 18),
                    label: Text(
                      viewModel.uploading
                          ? l10n.uploading
                          : (viewModel.hasLogo ? l10n.changeLogo : l10n.upload),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                l10n.taxIDRUC,
                l10n.taxID,
                fieldBg,
                icon: Icons.numbers,
                controller: companyTaxIDController,
                context: context,
                onChanged: onCompanyTaxIDChanged,
              ),
              const SizedBox(height: 32),
              Divider(color: theme.dividerColor),
              const SizedBox(height: 16),
              _sectionTitle(l10n.laboratoryInfo, Icons.science, context),
              const SizedBox(height: 16),
              _buildTextField(
                l10n.laboratoryAddress,
                l10n.address,
                fieldBg,
                icon: Icons.location_on,
                controller: laboratoryAddressController,
                context: context,
                onChanged: onLaboratoryAddressChanged,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                l10n.contactPhonesHint,
                l10n.contactPhonesPlaceholder,
                fieldBg,
                icon: Icons.phone,
                controller: laboratoryPhonesController,
                context: context,
                onChanged: onLaboratoryPhonesChanged,
              ),
              const SizedBox(height: 32),
              Divider(color: theme.dividerColor),
              const SizedBox(height: 16),
              _sectionTitle(l10n.billingInfo, Icons.payments, context),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      l10n.cutOffDate,
                      l10n.dateFormatShort,
                      fieldBg,
                      icon: Icons.calendar_today,
                      controller: cutOffDateController,
                      context: context,
                      readOnly: true,
                      onTap: onCutOffDateTap,
                      onChanged: onCutOffDateChanged,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      l10n.fee,
                      "0.00",
                      fieldBg,
                      prefix: "\$",
                      controller: managementFeeController,
                      context: context,
                      onChanged: onManagementFeeChanged,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 40),
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
                    onPressed: viewModel.loading ? null : () async {
                      if (formKey.currentState!.validate()) {
                        var isErr = await viewModel.create();
                        
                        if (!isErr) {
                          if (!context.mounted) return;
                          context.pop(true);
                        }
                      }
                    },
                    icon: viewModel.loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                          )
                        : const Icon(Icons.save, size: 18),
                    label: Text(l10n.createThing(l10n.user)),
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

  Widget _buildTextField(String label, String hint, Color bg, {IconData? icon, String? prefix, TextEditingController? controller, required BuildContext context, Function(String)? onChanged, bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 18) : (prefix != null ? Padding(padding: const EdgeInsets.all(12), child: Text(prefix)) : null),
            filled: true,
            fillColor: bg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).dividerColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, Color bg, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAdminOrRoot = _isUserAdminOrRoot(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<LabMemberRole>(
              value: _getSelectedRole(),
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: LabMemberRole.tECHNICIAN,
                  child: Text(l10n.roleTechnician, style: const TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: LabMemberRole.bIOANALYST,
                  child: Text(l10n.roleBioanalyst, style: const TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: LabMemberRole.bILLING,
                  child: Text(l10n.roleBilling, style: const TextStyle(fontSize: 14)),
                ),
                if (isAdminOrRoot)
                  DropdownMenuItem(
                    value: LabMemberRole.oWNER,
                    child: Text(l10n.roleOwner, style: const TextStyle(fontSize: 14)),
                  ),
              ],
              onChanged: onRoleChanged,
            ),
          ),
        ),
      ],
    );
  }
}