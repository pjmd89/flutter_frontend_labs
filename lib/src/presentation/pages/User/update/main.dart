import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
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
  bool _viewModelInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Solo inicializar el ViewModel una vez
    if (!_viewModelInitialized) {
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
      
      _viewModelInitialized = true;
    } else if (_controllersInitialized) {
      // Si el ViewModel ya está inicializado y los controllers también,
      // forzar actualización cuando cambie el idioma
      setState(() {
        // Esto forzará que formatTimestamp se ejecute de nuevo con el nuevo idioma
      });
    }
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
        title: Text(l10n.updateThing(l10n.user)),
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
          if (!_controllersInitialized || viewModel.currentUser == null) {
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
              Text("Información Personal", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Actualice los datos personales del usuario.", style: textTheme.bodyMedium),
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
                Text("Datos de Referencia", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _readOnlyInfo(l10n.user, viewModel.currentUser?.id ?? '-', textTheme, Icons.fingerprint),
                const SizedBox(height: 20),
                _readOnlyInfo("Email", viewModel.currentUser?.email ?? '-', textTheme, Icons.email_outlined),
                const SizedBox(height: 20),
                _readOnlyInfo(
                  l10n.role,
                  selectedRole != null ? getRoleLabel(context, selectedRole!) : '-',
                  textTheme,
                  Icons.admin_panel_settings_outlined
                ),
                const SizedBox(height: 20),
                _readOnlyInfo(
                  l10n.cutOffDate,
                  formatTimestamp(viewModel.currentUser!.cutOffDate),
                  textTheme,
                  Icons.calendar_today_outlined
                ),
                const SizedBox(height: 20),
                _readOnlyInfo(
                  l10n.fee,
                  viewModel.currentUser!.fee.toString(),
                  textTheme,
                  Icons.attach_money_outlined
                ),
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
              
              const SizedBox(width: 12), // Espaciado horizontal
              
              // Botón Guardar o Loader
              viewModel.loading
                  ? const SizedBox(
                      width: 40, // Un ancho fijo similar al botón ayuda a evitar saltos visuales
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
