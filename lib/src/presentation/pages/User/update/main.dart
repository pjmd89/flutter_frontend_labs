import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';

class UserUpdatePage extends StatefulWidget {
  const UserUpdatePage({super.key, required this.id, this.user});
  final String id;
  final User? user;

  @override
  State<UserUpdatePage> createState() => _UserUpdatePageState();
}

class _UserUpdatePageState extends State<UserUpdatePage> {
  late ViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Controllers para campos editables
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  
  // Variables para campos opcionales
  Role? selectedRole;
  
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('\n🎯 ========== didChangeDependencies LLAMADO ==========');
    debugPrint('🎯 widget.id: "${widget.id}"');
    debugPrint('🎯 widget.user != null: ${widget.user != null}');
    
    if (widget.user != null) {
      debugPrint('✅ Usuario pasado directamente (Opción A)');
      debugPrint('   - ID: ${widget.user!.id}');
      debugPrint('   - Nombre: ${widget.user!.firstName} ${widget.user!.lastName}');
      viewModel = ViewModel(context: context, user: widget.user!);
      
      // ✅ Como los datos ya están disponibles, inicializar controllers inmediatamente
      debugPrint('\n🎮 Inicializando controllers inmediatamente (Opción A)');
      _initializeControllers();
    } else {
      debugPrint('⚠️ Solo ID disponible, cargando desde servidor (Opción B)');
      viewModel = ViewModel(context: context, userId: widget.id);
    }
    
    // Escuchar cambios del ViewModel para inicializar controllers (para Opción B)
    viewModel.addListener(_updateControllers);
    debugPrint('🎯 ViewModel creado y listener agregado');
    debugPrint('========================================\n');
  }
  
  void _initializeControllers() {
    if (viewModel.currentUser != null && !_controllersInitialized) {
      debugPrint('✅ Inicializando controllers...');
      debugPrint('   - firstName: ${viewModel.currentUser!.firstName}');
      debugPrint('   - lastName: ${viewModel.currentUser!.lastName}');
      debugPrint('   - email: ${viewModel.currentUser!.email}');
      debugPrint('   - role: ${viewModel.currentUser!.role}');
      
      setState(() {
        firstNameController = TextEditingController(
          text: viewModel.currentUser!.firstName
        );
        lastNameController = TextEditingController(
          text: viewModel.currentUser!.lastName
        );
        emailController = TextEditingController(
          text: viewModel.currentUser!.email
        );
        selectedRole = viewModel.currentUser!.role;
        _controllersInitialized = true;
      });
      
      debugPrint('✅ Controllers inicializados exitosamente');
    }
  }
  
  void _updateControllers() {
    debugPrint('\n🎮 ========== _updateControllers LLAMADO ==========');
    debugPrint('🎮 viewModel.currentUser != null: ${viewModel.currentUser != null}');
    debugPrint('🎮 viewModel.loading: ${viewModel.loading}');
    debugPrint('🎮 _controllersInitialized: $_controllersInitialized');
    
    // Inicializar controllers cuando los datos se carguen (solo para Opción B)
    if (viewModel.currentUser != null && !viewModel.loading && !_controllersInitialized) {
      debugPrint('\n✅ Condiciones cumplidas, inicializando...');
      _initializeControllers();
    } else {
      debugPrint('⏭️ Condiciones no cumplidas para inicializar controllers');
    }
    debugPrint('========================================\n');
  }

  @override
  void dispose() {
    viewModel.removeListener(_updateControllers);
    if (_controllersInitialized) {
      firstNameController.dispose();
      lastNameController.dispose();
      emailController.dispose();
    }
    super.dispose();
  }
  
  String getRoleLabel(BuildContext context, Role role) {
    final l10n = AppLocalizations.of(context)!;
    switch (role) {
      case Role.rOOT:
        return l10n.roleRoot;
      case Role.aDMIN:
        return l10n.roleAdmin;
      case Role.uSER:
        return l10n.roleUser;
    }
  }
  
  String formatTimestamp(num timestamp) {
    try {
      // Convertir timestamp Unix (segundos o milisegundos) a DateTime
      final date = timestamp > 9999999999 
        ? DateTime.fromMillisecondsSinceEpoch(timestamp.toInt())
        : DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
      
      // Formatear como: "27 de enero de 2026"
      final months = [
        'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
        'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
      ];
      
      return '${date.day} de ${months[date.month - 1]} de ${date.year}';
    } catch (e) {
      return timestamp.toString();
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
        if (!_controllersInitialized || viewModel.currentUser == null) {
          return ContentDialog(
            icon: Icons.person,
            title: l10n.updateThing(l10n.user),
            loading: true,
            form: Form(child: const Center(child: CircularProgressIndicator())),
            actions: [],
          );
        }
        
        // Formulario con datos prellenados
        return ContentDialog(
          icon: Icons.person,
          title: l10n.updateThing(l10n.user),
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
                  
                  // Campos de solo lectura (no están en UpdateUserInput)
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
                            l10n.role,
                            selectedRole != null 
                              ? getRoleLabel(context, selectedRole!)
                              : '-'
                          ),
                          const SizedBox(height: 8),
                          _buildReadOnlyField(
                            l10n.cutOffDate, 
                            formatTimestamp(viewModel.currentUser!.cutOffDate)
                          ),
                          const SizedBox(height: 8),
                          _buildReadOnlyField(
                            l10n.fee, 
                            viewModel.currentUser!.fee.toString()
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
