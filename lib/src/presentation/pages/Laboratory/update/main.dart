import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/custom_text_form_field.dart';
import 'package:labs/src/presentation/core/ui/custom_text_form_fields/utils/form_field_length/main.dart';
import './view_model.dart';

class LaboratoryUpdatePage extends StatefulWidget {
  const LaboratoryUpdatePage({super.key, required this.laboratory});
  final Laboratory laboratory;

  @override
  State<LaboratoryUpdatePage> createState() => _LaboratoryUpdatePageState();
}

class _LaboratoryUpdatePageState extends State<LaboratoryUpdatePage> {
  late ViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  late TextEditingController addressController;
  final List<TextEditingController> phoneControllers = [];
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, laboratory: widget.laboratory);
    
    // Inicializar controllers con datos existentes
    addressController = TextEditingController(text: widget.laboratory.address);
    
    // Inicializar controllers de teléfonos
    for (var phone in widget.laboratory.contactPhoneNumbers) {
      phoneControllers.add(TextEditingController(text: phone));
    }
    
    // Si no hay teléfonos, agregar uno vacío
    if (phoneControllers.isEmpty) {
      phoneControllers.add(TextEditingController());
    }
  }
  
  @override
  void dispose() {
    addressController.dispose();
    for (var controller in phoneControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  void _addPhoneField() {
    setState(() {
      phoneControllers.add(TextEditingController());
    });
  }
  
  void _removePhoneField(int index) {
    setState(() {
      phoneControllers[index].dispose();
      phoneControllers.removeAt(index);
      
      // Actualizar input
      viewModel.input.contactPhoneNumbers = phoneControllers
        .map((c) => c.text)
        .where((text) => text.isNotEmpty)
        .toList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.business,
          title: l10n.updateThing(l10n.laboratory),
          loading: viewModel.loading,
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de información no editable
                  Card(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.nonEditableInformation,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildReadOnlyField(
                            l10n.company,
                            widget.laboratory.company?.name ?? '-',
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Campos editables
                  Text(
                    l10n.laboratoryInformation,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.emptyFieldError;
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Teléfonos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.phoneNumber,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextButton.icon(
                        onPressed: _addPhoneField,
                        icon: const Icon(Icons.add),
                        label: Text(l10n.addPhoneNumber),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  ...List.generate(phoneControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              labelText: '${l10n.phoneNumber} ${index + 1}',
                              controller: phoneControllers[index],
                              isDense: true,
                              fieldLength: FormFieldLength.name,
                              counterText: "",
                              onChange: (value) {
                                viewModel.input.contactPhoneNumbers = phoneControllers
                                  .map((c) => c.text)
                                  .where((text) => text.isNotEmpty)
                                  .toList();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (phoneControllers.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removePhoneField(index),
                            ),
                        ],
                      ),
                    );
                  }),
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
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 12),
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
                      const SizedBox(width: 8),
                      if (viewModel.loading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else
                        const Icon(Icons.save, size: 18),
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
          width: 80,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
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
