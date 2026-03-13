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

  // Mapa para trackear qué empleados están marcados para remover
  // Key: employeeId, Value: true si debe ser removido
  Map<String, bool> employeeRemovalStatus = {};

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

    // Inicializar el estado de remoción de empleados (todos inicialmente NO removidos)
    if (widget.laboratory.employees != null) {
      for (var employee in widget.laboratory.employees!.edges) {
        employeeRemovalStatus[employee.id] = false;
      }
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
      // 1. Actualizar datos básicos del laboratorio
      var isErr = await viewModel.update();
      
      if (!isErr) {
        // 2. Gestionar empleados marcados para remover
        final employeesToRemove = employeeRemovalStatus.entries
            .where((entry) => entry.value == true)
            .map((entry) => entry.key)
            .toList();
        
        if (employeesToRemove.isNotEmpty) {
          await viewModel.manageEmployees(
            employeeIds: employeesToRemove,
            remove: true,
          );
        }
        
        if (mounted) {
          context.pop(true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: colorScheme.surfaceContainerLowest, // Fondo ligeramente gris/crema para resaltar las cards blancas
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text(l10n.updateThing(l10n.laboratory)),
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200), // Un poco más ancho para estilo screen
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //_buildBreadcrumbs(l10n, textTheme),
                      const SizedBox(height: 24),
                      
                      // Layout Principal
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 7, child: _buildMainForm(l10n, colorScheme, textTheme)),
                            const SizedBox(width: 24),
                            Expanded(flex: 3, child: _buildSidePanel(l10n, colorScheme, textTheme)),
                            const SizedBox(width: 24),
                            Expanded(flex: 5, child: _buildEmployeeInfo(l10n, colorScheme, textTheme)),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildMainForm(l10n, colorScheme, textTheme),
                            const SizedBox(height: 24),
                            _buildSidePanel(l10n, colorScheme, textTheme),
                            const SizedBox(height: 24), 
                            _buildEmployeeInfo(l10n, colorScheme, textTheme)
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:[    
                            OutlinedButton(
                              onPressed: () => context.pop(),
                              child: Text(l10n.cancel)),   
                              const SizedBox(width: 12),            
                          viewModel.loading
                          ? const Center(
                             child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2)
                              )
                            ) 
                            : FilledButton.icon(
                              onPressed: _handleSave,
                              icon: const Icon(Icons.save_outlined, size: 18),
                              label: Text(l10n.save))    
                    ]
                  )
                    ],
                  ),
                ),
              ),
            ),
          
          ),
        );
      },
    );
  }


  Widget _buildEmployeeCard({
  required String name,
  required String role,
  required AppLocalizations l10n,
  required ColorScheme colorScheme,
  required TextTheme textTheme,
  required bool isRemoved,
  required Function(bool) onChanged,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 8),
    elevation: 0,
    // Fondo oscuro profundo para replicar la imagen
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          // Avatar con borde sutil
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all( width: 1),
            ),
            child: const CircleAvatar(
              radius: 18,      
              child: Icon(Icons.person_outline, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          
          // Información de texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  role,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 11,                 
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Control de eliminación (Switch)
          Column(
            children: [
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: isRemoved,
                  onChanged: (bool value) {
                    onChanged(value);
                    setState(() {}); // Para actualizar el estado visual del switch y el texto
                  },                
                ),
              ),
              Text(
                l10n.remove,
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Información de Ubicación", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Actualice la dirección física y los métodos de contacto directo.", style: textTheme.bodyMedium),
            const Divider(height: 48),
            
            CustomTextFormField(
              labelText: l10n.address,
              controller: addressController,
              fieldLength: FormFieldLength.email,
              isDense: true,
              prefixIcon: const Icon(Icons.location_on_outlined),
              onChange: (value) => viewModel.input.address = value,
              validator: (value) => (value == null || value.isEmpty) ? l10n.emptyFieldError : null,
            ),
            
            const SizedBox(height: 40),
            
            Row(
              children: [
                Text("Números de contacto", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addPhoneField,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addPhoneNumber),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(phoneControllers.length, (index) => _buildPhoneItem(index, l10n, colorScheme)),
          ],
        ),
      ),
    );
  }

 Widget _buildEmployeeInfo(AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
  final employees = widget.laboratory.employees?.edges ?? [];
  
  return Card(
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
          _buildCustomTextField(
            colorScheme: colorScheme,
            label: "Información de Empleados",
            controller: TextEditingController(),
            hint: " Ej: Juan Perez",
            icon: Icons.search
          ),
          const SizedBox(height: 16),
          
          // Contenedor con scroll para empleados
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Mostrar empleados reales del laboratorio
                  if (employees.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "No hay empleados asignados a este laboratorio",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    )
                  else
                    ...employees.map((employee) {
                      return _buildEmployeeCard(
                        name: "${employee.firstName} ${employee.lastName}",
                        role: employee.email,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                        isRemoved: employeeRemovalStatus[employee.id] ?? false,
                        onChanged: (val) {
                          setState(() {
                            employeeRemovalStatus[employee.id] = val;
                          });
                        },
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCustomTextField({
  required ColorScheme colorScheme,
  required String label,
  required TextEditingController controller,
  String? hint,
  IconData? icon,
  Widget? suffix,
  Function(String)? onChange,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.toUpperCase(),
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 8),
      Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChange,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.3)),
            prefixIcon: icon != null ? Icon(icon, color: colorScheme.onSurfaceVariant, size: 20) : null,
            suffixIcon: suffix,
            filled: false,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Mismo padding que antes
          ),
        ),
      ),
    ],
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
                Text("Datos de Referencia", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _readOnlyInfo(l10n.company, widget.laboratory.company?.name ?? '-', textTheme, Icons.business),
                const SizedBox(height: 20),
                _readOnlyInfo("ID de Sucursal", "LAB-${widget.laboratory.id}", textTheme, Icons.fingerprint),
                const SizedBox(height: 20),
                _readOnlyInfo("Última Actualización", "Hace 2 días", textTheme, Icons.history),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Card de ayuda o estado rápida
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Los cambios realizados serán visibles para todos los operarios inmediatamente.",
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onPrimaryContainer),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneItem(int index, AppLocalizations l10n, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              labelText: '${l10n.phoneNumber} ${index + 1}',
              controller: phoneControllers[index],
              fieldLength: FormFieldLength.name,
              isDense: true,
              prefixIcon: const Icon(Icons.phone_outlined),
              onChange: (v) => _updateViewModelPhones(),
            ),
          ),
          if (phoneControllers.length > 1) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.delete_sweep_outlined, color: colorScheme.error),
              onPressed: () => _removePhoneField(index),
            ),
          ],
        ],
      ),
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