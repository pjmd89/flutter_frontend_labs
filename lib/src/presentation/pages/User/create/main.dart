import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import './view_model.dart';

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
    _cutOffDateController.dispose();
    _managementFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Create New User"),
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
            cutOffDateController: _cutOffDateController,
            managementFeeController: _managementFeeController,
            viewModel: viewModel,
            formKey: formKey,
            onFirstNameChanged: (value) => viewModel.input.firstName = value,
            onLastNameChanged: (value) => viewModel.input.lastName = value,
            onEmailChanged: (value) => viewModel.input.email = value,
            onCompanyNameChanged: (value) {
              viewModel.input.companyInfo ??= CreateCompanyInput();
              viewModel.input.companyInfo?.name = value;
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
  final TextEditingController cutOffDateController;
  final TextEditingController managementFeeController;
  final ViewModel viewModel;
  final GlobalKey<FormState> formKey;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onCompanyNameChanged;
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
    required this.cutOffDateController,
    required this.managementFeeController,
    required this.viewModel,
    required this.formKey,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onEmailChanged,
    required this.onCompanyNameChanged,
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Basic Information", Icons.person, context),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "First Name",
                    "John",
                    fieldBg,
                    controller: firstNameController,
                    context: context,
                    onChanged: onFirstNameChanged,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    "Last Name",
                    "Doe",
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
              "Email Address",
              "john.doe@lablink.com",
              fieldBg,
              icon: Icons.mail_outline,
              controller: emailController,
              context: context,
              onChanged: onEmailChanged,
            ),
            
            const SizedBox(height: 32),
            _sectionTitle("Employee Role", Icons.person_outline, context),
            const SizedBox(height: 16),
            _buildDropdown("Role", fieldBg, context),

            if (_isUserAdminOrRoot(context)) ...[
              const SizedBox(height: 32),
              Divider(color: theme.dividerColor),
              const SizedBox(height: 16),
              _sectionTitle("Owner Configuration", Icons.business, context),
              const SizedBox(height: 16),
              _buildTextField(
                "Company Name",
                "Precision Labs Inc.",
                fieldBg,
                controller: companyNameController,
                context: context,
                onChanged: onCompanyNameChanged,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      "Cut-off Date",
                      "YYYY-MM-DD",
                      fieldBg,
                      icon: Icons.calendar_today,
                      controller: cutOffDateController,
                      context: context,
                      onChanged: onCutOffDateChanged,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      "Management Fee",
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
                    child: const Text("Cancel"),
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
                        : const Icon(Icons.save, size: 18, color: Colors.white),
                    label: const Text("Create User", style: TextStyle(color: Colors.white)),
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

  Widget _buildTextField(String label, String hint, Color bg, {IconData? icon, String? prefix, TextEditingController? controller, required BuildContext context, Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
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
                  child: Text("Technician", style: const TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: LabMemberRole.bIOANALYST,
                  child: Text("Bioanalyst", style: const TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: LabMemberRole.bILLING,
                  child: Text("Billing", style: const TextStyle(fontSize: 14)),
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