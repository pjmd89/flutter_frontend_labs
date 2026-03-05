import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
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
    
    addressController = TextEditingController(text: widget.laboratory.address);
    for (var phone in widget.laboratory.contactPhoneNumbers) {
      phoneControllers.add(TextEditingController(text: phone));
    }
    
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
    setState(() => phoneControllers.add(TextEditingController()));
  }

  void _removePhoneField(int index) {
    setState(() {
      phoneControllers[index].dispose();
      phoneControllers.removeAt(index);
      _updateViewModelPhones();
    });
  }

  void _updateViewModelPhones() {
    viewModel.input.contactPhoneNumbers = phoneControllers
        .map((c) => c.text)
        .where((text) => text.isNotEmpty)
        .toList();
  }

  Future<void> _handleSave() async {
    if (formKey.currentState!.validate()) {
      var isErr = await viewModel.update();
      if (!isErr && mounted) {
        context.pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Dialog(
          backgroundColor: colorScheme.surface,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header del Dialog
                    _buildHeader(l10n, colorScheme),
                    const Divider(height: 32),
                    
                    // Contenido Scrolleable
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleSection(l10n, textTheme),
                            const SizedBox(height: 24),
                            _buildResponsiveGrid(l10n, colorScheme, textTheme),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    
                    // Footer / Acciones
                    const SizedBox(height: 8),
                    _buildFooterActionCard(l10n, colorScheme, textTheme),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(Icons.biotech, color: colorScheme.primary, size: 28),
        const SizedBox(width: 12),
        Text(
          l10n.updateThing(l10n.laboratory),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
          tooltip: l10n.cancel,
        ),
      ],
    );
  }

  Widget _buildTitleSection(AppLocalizations l10n, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.laboratoryInformation,
          style: textTheme.titleMedium?.copyWith(
            color: textTheme.bodySmall?.color?.withOpacity(0.7),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveGrid(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    // En un diálogo solemos preferir una columna si el ancho es limitado
    bool isWide = MediaQuery.of(context).size.width > 900;

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        SizedBox(
          width: isWide ? 580 : double.infinity,
          child: _buildMainFormCard(l10n, colorScheme),
        ),
        SizedBox(
          width: isWide ? 350 : double.infinity,
          child: _buildSideInfoCard(l10n, colorScheme, textTheme),
        ),
      ],
    );
  }

  Widget _buildMainFormCard(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            labelText: l10n.address,
            controller: addressController,
            isDense: true,
            fieldLength: FormFieldLength.email,
            onChange: (value) => viewModel.input.address = value,
            validator: (value) => (value == null || value.isEmpty) ? l10n.emptyFieldError : null,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.phoneNumber.toUpperCase(), 
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              TextButton.icon(
                onPressed: _addPhoneField,
                icon: const Icon(Icons.add, size: 16),
                label: Text(l10n.addPhoneNumber),
              ),
            ],
          ),
          ...List.generate(phoneControllers.length, (index) => _buildPhoneItem(index, l10n, colorScheme)),
        ],
      ),
    );
  }

  Widget _buildSideInfoCard(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _readOnlyInfo(l10n.company, widget.laboratory.company?.name ?? '-', textTheme),
          const SizedBox(height: 16),
          _readOnlyInfo("ID Interno", "LAB-${widget.laboratory.id}", textTheme),
        ],
      ),
    );
  }

  Widget _buildFooterActionCard(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(l10n.cancel),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: viewModel.loading ? null : _handleSave,
          child: viewModel.loading
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2))
              : Text(l10n.save, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildPhoneItem(int index, AppLocalizations l10n, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              labelText: '${l10n.phoneNumber} ${index + 1}',
              controller: phoneControllers[index],
              isDense: true,
              fieldLength: FormFieldLength.name,
              onChange: (v) => _updateViewModelPhones(),
            ),
          ),
          if (phoneControllers.length > 1) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
              onPressed: () => _removePhoneField(index),
            ),
          ],
        ],
      ),
    );
  }

  Widget _readOnlyInfo(String label, String value, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}