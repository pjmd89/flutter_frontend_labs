import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';

class LaboratoryCreatePage extends StatefulWidget {
  const LaboratoryCreatePage({super.key});

  @override
  State<LaboratoryCreatePage> createState() => _LaboratoryCreatePageState();
}

class _LaboratoryCreatePageState extends State<LaboratoryCreatePage> {
  late ViewModel viewModel;
  
  // Controllers para cada campo del formulario
  final addressController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Estado para el selector de empresa
  String? selectedCompanyID;

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
    addressController.dispose();
    phone1Controller.dispose();
    phone2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.science_outlined,
          title: l10n.createThing('Laboratorio'),
          loading: viewModel.loading,
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(
                    labelText: 'Dirección',
                    controller: addressController,
                    isDense: true,
                    fieldLength: FormFieldLength.email,
                    counterText: "",
                    maxLines: 2,
                    onChange: (value) {
                      viewModel.input.address = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  viewModel.loadingCompanies
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : DropdownButtonFormField<String>(
                        value: selectedCompanyID,
                        decoration: InputDecoration(
                          labelText: l10n.company,
                          isDense: true,
                          border: const OutlineInputBorder(),
                        ),
                        items: viewModel.companies.map((Company company) {
                          return DropdownMenuItem<String>(
                            value: company.id,
                            child: Text(company.name),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCompanyID = newValue;
                            viewModel.input.companyID = newValue;
                          });
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
                    labelText: 'Teléfono 1',
                    controller: phone1Controller,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) {
                      // Actualizar lista de teléfonos
                      _updatePhones();
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    labelText: 'Teléfono 2 (opcional)',
                    controller: phone2Controller,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) {
                      // Actualizar lista de teléfonos
                      _updatePhones();
                    },
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
                  onPressed: () {
                    context.pop();
                  },
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: viewModel.loading ? null : () async {
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
                      Text(l10n.createThing('Laboratorio')),
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

  void _updatePhones() {
    List<String> phones = [];
    
    if (phone1Controller.text.isNotEmpty) {
      phones.add(phone1Controller.text);
    }
    
    if (phone2Controller.text.isNotEmpty) {
      phones.add(phone2Controller.text);
    }
    
    viewModel.input.contactPhoneNumbers = phones.isEmpty ? null : phones;
  }
}