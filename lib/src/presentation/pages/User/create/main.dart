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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Role? selectedRole;

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
    super.dispose();
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
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(
                    labelText: l10n.firstName,
                    controller: firstNameController,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.firstName = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    labelText: l10n.lastName,
                    controller: lastNameController,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.lastName = value;
                    },
                  ),
                  const SizedBox(height: 16),
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
                  DropdownButtonFormField<Role>(
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
                      });
                    },
                  ),
                  if (selectedRole == Role.owner) ...[
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      labelText: l10n.cutOffDate,
                      controller: cutOffDateController,
                      isDense: true,
                      fieldLength: FormFieldLength.password,
                      counterText: "",
                      onChange: (value) {
                        viewModel.input.cutOffDate = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      labelText: l10n.fee,
                      controller: feeController,
                      isDense: true,
                      fieldLength: FormFieldLength.password,
                      counterText: "",
                      onChange: (value) {
                        viewModel.input.fee = num.tryParse(value);
                      },
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
