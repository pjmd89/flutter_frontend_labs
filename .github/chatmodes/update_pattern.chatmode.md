# ````chatagent
# Patrón de Arquitectura Modular Flutter - UPDATE (Actualización con Formulario)

Este chatmode documenta el patrón completo para implementar módulos de **actualización** con formularios prellenados en Flutter usando agile_front framework y GraphQL.

**Alcance:** Operación UPDATE (PUT/PATCH)  
**Otros patrones:** CREATE, READ, DELETE se documentan en chatmodes separados

## Principios Fundamentales

### 1. Separación de Responsabilidades
Cada archivo tiene una única responsabilidad clara:
- El archivo principal (`main.dart`) solo orquesta el diálogo y el formulario
- La lógica de negocio está en el `view_model.dart`
- Los inputs/entidades manejan los datos del formulario
- La mutation GraphQL maneja la operación de actualización

### 2. Nombres Genéricos y Reutilizables
Usa nombres estándar para facilitar la clonación de módulos y mantener consistencia.

### 3. Diálogo Modal para Editar
La actualización usa `ContentDialog` (modal) en lugar de página completa, con:
- Formulario prellenado con datos existentes
- Botones de acción (Cancelar/Actualizar)
- Loading state durante la carga inicial y la operación
- Cierre automático al completar

### 4. Diferencias Clave con CREATE
- ✅ Recibe objeto completo o ID como parámetro
- ✅ Carga datos existentes antes de mostrar formulario
- ✅ `Update{Feature}Input` tiene campo `_id` obligatorio
- ✅ `Update{Feature}Input` tiene MENOS campos (solo editables)
- ✅ Campos no editables se muestran como solo lectura
- ✅ Optimización: enviar solo campos modificados (opcional)

## Estructura de Archivos para UPDATE

```
/pages/{Feature}/update/
  ├── main.dart              # Widget principal con diálogo - 80-110 líneas
  └── view_model.dart        # Lógica de negocio con GraphQL mutation

/domain/
  /usecases/{Feature}/
    └── update_{feature}_usecase.dart      # UseCase con execute()
  /operation/
    /mutations/update{Feature}/
      └── update{feature}_mutation.dart    # Mutation GraphQL
  /extensions/
    └── {feature}_fields_builder_extension.dart  # ⚠️ Extension REQUERIDA
  /entities/
    /types/{feature}/inputs/
      └── update{feature}input_input.dart       # Input para el formulario UPDATE
```

### Ejemplo Real: Módulo User/update

**Presentación:**
```
/pages/User/update/
  ├── main.dart              # UserUpdatePage con ContentDialog
  └── view_model.dart        # ViewModel con loadData(), update(), input
```

**Dominio:**
```
/domain/
  /usecases/User/
    └── update_user_usecase.dart           # UpdateUserUsecase
  /operation/
    /mutations/updateUser/
      └── updateuser_mutation.dart         # UpdateUserMutation
  /extensions/
    └── user_fields_builder_extension.dart # ⚠️ Extension con defaultValues()
  /entities/
    /types/user/inputs/
      └── updateuserinput_input.dart       # UpdateUserInput con campo _id
```

## ⚠️ Análisis del UpdateInput: Campos Editables vs Solo Lectura

**REGLA CRÍTICA:** Compara la entidad completa con el `Update{Feature}Input` para identificar:

### Campos en UpdateInput = Editables
Los campos que están en `Update{Feature}Input` son editables en el formulario.

### Campos NO en UpdateInput = Solo Lectura
Los campos que existen en la entidad pero NO en `Update{Feature}Input` son inmutables:
- Se pueden mostrar como información contextual
- Usar `TextFormField(enabled: false)` con estilo distintivo
- O mostrar en sección separada de "Información no editable"

### Ejemplo: Patient

**Entidad Patient completa:**
```dart
class Patient {
  String id;
  String firstName;
  String lastName;
  Sex sex;                // ⚠️ NO editable
  String? birthDate;
  String? species;        // ⚠️ NO editable
  String? dni;
  String? phone;
  String? email;
  String? address;
  String laboratory;      // ⚠️ NO editable (referencia)
}
```

**UpdatePatientInput (solo campos editables):**
```dart
@JsonSerializable(includeIfNull: false)
class UpdatePatientInput {
  @JsonKey(name: "_id")
  String _id = "";        // ✅ Campo _id OBLIGATORIO
  
  String? _firstName;     // ✅ Editable
  String? _lastName;      // ✅ Editable
  // ❌ sex NO está → Solo lectura
  String? _birthDate;     // ✅ Editable
  // ❌ species NO está → Solo lectura
  String? _dni;           // ✅ Editable
  String? _phone;         // ✅ Editable
  String? _email;         // ✅ Editable
  String? _address;       // ✅ Editable
  // ❌ laboratory NO está → Solo lectura
}
```

### Mostrar Campos Solo Lectura

**Opción 1: TextField deshabilitado con estilo distintivo**
```dart
CustomTextFormField(
  labelText: l10n.sex,
  controller: TextEditingController(text: getSexLabel(context, widget.patient.sex)),
  enabled: false,
  filled: true,  // Estilo definido en theme
)
```

**Opción 2: Sección informativa separada**
```dart
Card(
  // Color y padding definidos en theme
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.nonEditableInformation,
        style: Theme.of(context).textTheme.titleSmall,  // Usar theme
      ),
      _buildReadOnlyField(l10n.sex, getSexLabel(context, widget.patient.sex)),
      _buildReadOnlyField(l10n.species, widget.patient.species ?? '-'),
      _buildReadOnlyField(l10n.laboratory, widget.patient.laboratoryName ?? '-'),
    ],
  ),
)

Widget _buildReadOnlyField(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$label:',
        style: Theme.of(context).textTheme.bodyMedium,  // Usar theme
      ),
      Expanded(
        child: Text(value),
      ),
    ],
  );
}
```

## Convención de Nombres para UPDATE

### Archivos Genéricos (mismo nombre en todos los módulos UPDATE)
- ✅ `main.dart` - Widget principal con ContentDialog (80-110 líneas)
- ✅ `view_model.dart` - Lógica de negocio con GraphQL mutation

### Clases y Archivos del Dominio
- ✅ `Update{Feature}Usecase` - UseCase de actualización
  - Ejemplos: `UpdateUserUsecase`, `UpdatePatientUsecase`, `UpdateProductUsecase`
- ✅ `Update{Feature}Mutation` - Mutation GraphQL
  - Ejemplos: `UpdateUserMutation`, `UpdatePatientMutation`, `UpdateProductMutation`
- ✅ `Update{Feature}Input` - Input para el formulario UPDATE
  - Ejemplos: `UpdateUserInput`, `UpdatePatientInput`, `UpdateProductInput`
  - ⚠️ **SIEMPRE tiene campo `_id` con `@JsonKey(name: "_id")`**

### Funciones y Métodos Estándar
- ✅ `loadData()` - Método en ViewModel que carga datos existentes (si se usa ID)
- ✅ `update()` - Método en ViewModel que ejecuta la actualización
- ✅ `execute()` - Método en UseCase que ejecuta la mutation

### Nombres de carpetas
- ✅ `/mutations/update{Feature}/` - Carpeta de mutation
  - Ejemplos: `updateUser/`, `updatePatient/`, `updateLaboratory/`

## Carga de Datos Existentes

**DIFERENCIA CRÍTICA CON CREATE:** El patrón UPDATE requiere **cargar los datos existentes** antes de mostrar el formulario.

### Opción A: Pasar Objeto Completo via Navegación [RECOMENDADA]

**Ventajas:**
- ✅ No requiere query adicional al servidor
- ✅ Más rápido (datos ya están disponibles)
- ✅ Menos complejidad en el código
- ✅ Evita race conditions
- ✅ Funciona offline si los datos ya están en memoria

**Desventajas:**
- ⚠️ Los datos pueden estar desactualizados si otro usuario los modificó

**Implementación:**

**1. Navegación desde la página de listado:**
```dart
// En user_item.dart o donde esté el botón "Editar"
IconButton(
  icon: const Icon(Icons.edit),
  onPressed: () async {
    final result = await context.push('/users/update', extra: user);
    
    if (result == true) {
      // Recargar lista si hubo cambios
      viewModel.getUsers();
    }
  },
)
```

**2. Widget recibe objeto completo:**
```dart
// En UserUpdatePage
class UserUpdatePage extends StatefulWidget {
  const UserUpdatePage({super.key, required this.user});
  final User user;  // ✅ Recibe objeto completo

  @override
  State<UserUpdatePage> createState() => _UserUpdatePageState();
}
```

**3. ViewModel se inicializa con datos:**
```dart
class _UserUpdatePageState extends State<UserUpdatePage> {
  late ViewModel viewModel;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pasar el objeto al ViewModel
    viewModel = ViewModel(context: context, user: widget.user);
  }
}
```

**4. ViewModel prellenado con datos:**
```dart
class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;
  
  final UpdateUserInput input = UpdateUserInput();
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  bool get loading => _loading;
  
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }
  
  ViewModel({
    required BuildContext context,
    required User user,  // ✅ Recibe usuario
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _currentUser = user;
    
    // ✅ Prellenar input con datos existentes
    input.id = user.id;
    input.firstName = user.firstName;
    input.lastName = user.lastName;
    input.email = user.email;
    // ... resto de campos
  }
}
```

### Opción B: Query get{Feature}ById

**Ventajas:**
- ✅ Datos siempre actualizados del servidor
- ✅ Detecta si el registro fue eliminado

**Desventajas:**
- ⚠️ Requiere query adicional (más latencia)
- ⚠️ Requiere implementar query getById en GraphQL
- ⚠️ Más complejo de implementar

**Implementación:**

**1. Widget recibe solo ID:**
```dart
class UserUpdatePage extends StatefulWidget {
  const UserUpdatePage({super.key, required this.userId});
  final String userId;  // ✅ Solo recibe ID

  @override
  State<UserUpdatePage> createState() => _UserUpdatePageState();
}
```

**2. ViewModel carga datos en constructor:**
```dart
class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  bool _error = false;
  
  final UpdateUserInput input = UpdateUserInput();
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  bool get loading => _loading;
  bool get error => _error;
  
  ViewModel({
    required BuildContext context,
    required String userId,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    loadData(userId);  // ✅ Carga automática
  }
  
  Future<void> loadData(String id) async {
    loading = true;
    _error = false;
    
    try {
      // Query getUserById
      GetUserByIdUsecase useCase = GetUserByIdUsecase(
        operation: GetUserByIdQuery(builder: UserFieldsBuilder().defaultValues()),
        conn: _gqlConn,
      );
      
      var response = await useCase.execute(id: id);
      
      if (response is User) {
        _currentUser = response;
        
        // ✅ Prellenar input con datos cargados
        input.id = response.id;
        input.firstName = response.firstName;
        input.lastName = response.lastName;
        input.email = response.email;
        
      } else {
        _error = true;
        _errorService.showError(
          message: l10n.recordNotFound,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en loadData: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      _error = true;
      
      _errorService.showError(
        message: 'Error al cargar usuario: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }
}
```

### Opción C: Query Lista con Filtro por ID

**Ventajas:**
- ✅ Reutiliza query existente (getUsers)
- ✅ No requiere crear query nueva

**Desventajas:**
- ⚠️ Menos eficiente (query de lista para un solo item)
- ⚠️ Puede ser confuso para otros desarrolladores

**Implementación:**
```dart
Future<void> loadData(String id) async {
  loading = true;
  _error = false;
  
  try {
    ReadUserUsecase useCase = ReadUserUsecase(
      operation: GetUsersQuery(builder: EdgeUserFieldsBuilder().defaultValues()),
      conn: _gqlConn,
    );
    
    // Buscar por ID usando SearchInput
    final searchInputs = [
      SearchInput(field: '_id', op: 'eq', value: id)
    ];
    
    var response = await useCase.search(searchInputs, null);
    
    if (response is EdgeUser && response.edges.isNotEmpty) {
      _currentUser = response.edges.first;
      
      // Prellenar input
      input.id = _currentUser!.id;
      input.firstName = _currentUser!.firstName;
      // ... resto de campos
      
    } else {
      _error = true;
      _errorService.showError(message: l10n.recordNotFound);
    }
  } catch (e, stackTrace) {
    debugPrint('💥 Error en loadData: $e');
    debugPrint('📍 StackTrace: $stackTrace');
    _error = true;
    
    _errorService.showError(
      message: 'Error al cargar usuario: ${e.toString()}',
    );
  } finally {
    loading = false;
  }
}
```

### Recomendación

**Usa Opción A (pasar objeto completo)** en la mayoría de casos:
- Es más simple y rápido
- Los datos ya están disponibles en la lista
- Si necesitas datos frescos, refresca la lista antes de editar

**Usa Opción B o C solo si:**
- El formulario de edición es accesible desde múltiples lugares
- Los datos pueden cambiar frecuentemente
- Necesitas validación estricta de que el registro existe

## ⚠️ Prellenado de Campos Especiales UPDATE

### 1. TextEditingController - Inicialización con Valores Existentes

**CRÍTICO:** Los controllers deben inicializarse **DESPUÉS** de cargar los datos.

**Con Opción A (objeto completo disponible):**
```dart
class _UserUpdatePageState extends State<UserUpdatePage> {
  late ViewModel viewModel;
  
  // ✅ Controllers se inicializan con datos existentes
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, user: widget.user);
    
    // ✅ Inicializar controllers DESPUÉS de tener los datos
    firstNameController = TextEditingController(
      text: widget.user.firstName ?? ''
    );
    lastNameController = TextEditingController(
      text: widget.user.lastName ?? ''
    );
    emailController = TextEditingController(
      text: widget.user.email ?? ''
    );
  }
  
  @override
  void dispose() {
    // ✅ Limpiar controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
```

**Con Opción B/C (carga asíncrona):**
```dart
class _UserUpdatePageState extends State<UserUpdatePage> {
  late ViewModel viewModel;
  
  // Controllers se crean vacíos
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, userId: widget.userId);
    
    // Escuchar cambios del ViewModel
    viewModel.addListener(_updateControllers);
  }
  
  void _updateControllers() {
    // ✅ Actualizar controllers cuando los datos se carguen
    if (viewModel.currentUser != null && !viewModel.loading) {
      firstNameController.text = viewModel.currentUser!.firstName ?? '';
      lastNameController.text = viewModel.currentUser!.lastName ?? '';
      emailController.text = viewModel.currentUser!.email ?? '';
    }
  }
  
  @override
  void dispose() {
    viewModel.removeListener(_updateControllers);
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
```

### 2. Enums → DropdownButtonFormField Prellenado

**Implementación con valor inicial:**
```dart
class _UserUpdatePageState extends State<UserUpdatePage> {
  Role? selectedRole;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, user: widget.user);
    
    // ✅ Inicializar con valor existente
    selectedRole = widget.user.role;
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
          // ... otros parámetros
          form: Form(
            key: formKey,
            child: Column(
              children: [
                // ... otros campos
                DropdownButtonFormField<Role>(
                  value: selectedRole,  // ✅ Valor prellenado
                  decoration: InputDecoration(
                    labelText: l10n.role,
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  items: Role.values.map((Role role) {
                    return DropdownMenuItem<Role>(
                      value: role,
                      child: Text(getRoleLabel(context, role)),
                    );
                  }).toList(),
                  onChanged: (Role? newValue) {
                    setState(() {
                      selectedRole = newValue;
                      viewModel.input.role = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

### 3. Fechas → DatePicker Prellenado

**Implementación:**
```dart
late TextEditingController birthDateController;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  viewModel = ViewModel(context: context, user: widget.user);
  
  // ✅ Formatear fecha existente
  String formattedDate = '';
  if (widget.user.birthDate != null) {
    try {
      final date = DateTime.parse(widget.user.birthDate!);
      formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      formattedDate = widget.user.birthDate ?? '';
    }
  }
  
  birthDateController = TextEditingController(text: formattedDate);
}

// En el formulario
CustomTextFormField(
  labelText: l10n.birthDate,
  controller: birthDateController,
  readOnly: true,
  onTap: () async {
    DateTime? initialDate;
    try {
      initialDate = DateTime.parse(birthDateController.text);
    } catch (e) {
      initialDate = DateTime.now();
    }
    
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,  // ✅ Fecha inicial prellenada
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      final formatted = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      birthDateController.text = formatted;
      viewModel.input.birthDate = date.toIso8601String();
    }
  },
)
```

### 4. Booleanos → Switch/Checkbox Prellenado

**Implementación:**
```dart
SwitchListTile(
  title: Text(l10n.isActive),
  value: viewModel.input.isActive ?? widget.user.isActive ?? false,  // ✅ Valor prellenado
  onChanged: (bool value) {
    setState(() {
      viewModel.input.isActive = value;
    });
  },
)

// O con Checkbox
CheckboxListTile(
  title: Text(l10n.acceptTerms),
  value: viewModel.input.acceptTerms ?? widget.user.acceptTerms ?? false,
  onChanged: (bool? value) {
    setState(() {
      viewModel.input.acceptTerms = value ?? false;
    });
  },
)
```

### 5. Checklist de Prellenado

- [ ] Controllers inicializados con valores existentes
- [ ] Variables de estado para Enums prellenadas
- [ ] DatePickers muestran fecha existente
- [ ] Switches/Checkboxes con valores booleanos correctos
- [ ] Disposal de todos los controllers en dispose()
- [ ] Prellenado ocurre DESPUÉS de cargar datos (si es asíncrono)
- [ ] Input del ViewModel tiene _id asignado
- [ ] Todos los campos editables están prellenados

## Validación Diferencial (Opcional pero Recomendada)

La validación diferencial permite enviar **solo los campos modificados** al servidor, optimizando la operación de actualización.

### Ventajas

- ✅ **Optimización de red** - Menos datos enviados
- ✅ **Menor carga del servidor** - Solo procesa campos cambiados
- ✅ **Mejor logging** - Registro claro de qué cambió
- ✅ **Detección de cambios** - Saber si el usuario modificó algo
- ✅ **Validación condicional** - Validar solo campos editados

### Concepto

GraphQL con `@JsonSerializable(includeIfNull: false)` ignora campos `null`, permitiendo enviar solo los campos modificados al servidor.

### Implementación Completa

**1. Tracking de campos modificados:**
```dart
class _UserUpdatePageState extends State<UserUpdatePage> {
  late ViewModel viewModel;
  
  // ✅ Set para registrar campos modificados
  final Set<String> _changedFields = {};
  
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  Role? selectedRole;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, user: widget.user);
    
    // Inicializar controllers
    firstNameController = TextEditingController(text: widget.user.firstName ?? '');
    lastNameController = TextEditingController(text: widget.user.lastName ?? '');
    emailController = TextEditingController(text: widget.user.email ?? '');
    selectedRole = widget.user.role;
  }
  
  // ✅ Método helper para detectar cambios
  bool hasChanges() => _changedFields.isNotEmpty;
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.person,
          title: l10n.updateThing(l10n.user),
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
                      // ✅ Registrar cambio
                      setState(() => _changedFields.add('firstName'));
                      viewModel.input.firstName = value;
                    },
                  ),
                  // Espaciado definido en theme
                  CustomTextFormField(
                    labelText: l10n.lastName,
                    controller: lastNameController,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) {
                      setState(() => _changedFields.add('lastName'));
                      viewModel.input.lastName = value;
                    },
                  ),
                  // Espaciado definido en theme
                  CustomTextFormField(
                    labelText: l10n.email,
                    controller: emailController,
                    isDense: true,
                    fieldLength: FormFieldLength.email,
                    counterText: "",
                    onChange: (value) {
                      setState(() => _changedFields.add('email'));
                      viewModel.input.email = value;
                    },
                  ),
                  // Espaciado definido en theme
                  DropdownButtonFormField<Role>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      labelText: l10n.role,
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                    items: Role.values.map((Role role) {
                      return DropdownMenuItem<Role>(
                        value: role,
                        child: Text(getRoleLabel(context, role)),
                      );
                    }).toList(),
                    onChanged: (Role? newValue) {
                      setState(() {
                        _changedFields.add('role');
                        selectedRole = newValue;
                        viewModel.input.role = newValue;
                      });
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
                    // ✅ Preguntar si hay cambios sin guardar (opcional)
                    if (hasChanges()) {
                      // Mostrar diálogo de confirmación
                    } else {
                      context.pop();
                    }
                  },
                ),
                // Espaciado definido en theme
                FilledButton(
                  onPressed: viewModel.loading ? null : () async {
                    if (formKey.currentState!.validate()) {
                      // ✅ Solo actualizar si hay cambios
                      if (hasChanges()) {
                        var isErr = await viewModel.update();
                        
                        if (!isErr) {
                          if (!context.mounted) return;
                          context.pop(true);
                        }
                      } else {
                        // Sin cambios, solo cerrar
                        context.pop(false);
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.updateThing(l10n.user)),
                      // Espaciado e indicador definidos en theme
                      if (viewModel.loading)
                        CircularProgressIndicator()  // Tamaño definido en theme
                      else
                        Icon(Icons.save),
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
```

**2. UpdateInput con includeIfNull: false:**
```dart
@JsonSerializable(includeIfNull: false)  // ✅ Clave para validación diferencial
class UpdateUserInput extends ChangeNotifier {
  String _id = "";
  
  @JsonKey(name: "_id")
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }
  
  // ✅ Todos los campos opcionales (null por defecto)
  String? _firstName;
  String? get firstName => _firstName;
  set firstName(String? value) {
    _firstName = value;
    notifyListeners();
  }
  
  String? _lastName;
  String? get lastName => _lastName;
  set lastName(String? value) {
    _lastName = value;
    notifyListeners();
  }
  
  // Al llamar toJson(), solo se incluyen campos no-null
  factory UpdateUserInput.fromJson(Map<String, dynamic> json) => 
      _$UpdateUserInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserInputToJson(this);
}
```

**3. Optimización avanzada - Reset a null:**
```dart
// En ViewModel, antes de update()
Future<bool> update() async {
  bool isError = true;
  loading = true;

  // ✅ Resetear campos no modificados a null
  // Esto asegura que solo se envíen los campos editados
  if (!_changedFields.contains('firstName')) {
    input.firstName = null;
  }
  if (!_changedFields.contains('lastName')) {
    input.lastName = null;
  }
  if (!_changedFields.contains('email')) {
    input.email = null;
  }

  UpdateUserUsecase useCase = UpdateUserUsecase(
    operation: UpdateUserMutation(builder: UserFieldsBuilder()),
    conn: _gqlConn,
  );

  try {
    var response = await useCase.execute(input: input);
    
    if (response is User) {
      isError = false;
      _errorService.showError(
        message: l10n.thingUpdatedSuccessfully(l10n.user),
        type: ErrorType.success,
      );
    }
  } catch (e, stackTrace) {
    debugPrint('💥 Error en updateUser: $e');
    debugPrint('📍 StackTrace: $stackTrace');
    isError = true;
    
    _errorService.showError(
      message: 'Error al actualizar usuario: ${e.toString()}',
    );
  } finally {
    loading = false;
  }

  return isError;
}
```

### Validación: Solo Campos Modificados vs Todo el Formulario

**Opción 1: Validar solo campos modificados**
```dart
bool _validateChangedFields() {
  bool isValid = true;
  
  if (_changedFields.contains('email')) {
    // Validar formato de email
    if (!_isValidEmail(emailController.text)) {
      _errorService.showError(message: l10n.invalidEmail);
      isValid = false;
    }
  }
  
  if (_changedFields.contains('phone')) {
    // Validar formato de teléfono
    if (!_isValidPhone(phoneController.text)) {
      _errorService.showError(message: l10n.invalidPhone);
      isValid = false;
    }
  }
  
  return isValid;
}
```

**Opción 2: Validar todo el formulario (recomendada)**
```dart
// Usar validators en los campos
CustomTextFormField(
  labelText: l10n.email,
  controller: emailController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return l10n.fieldRequired;
    }
    if (!_isValidEmail(value)) {
      return l10n.invalidEmail;
    }
    return null;
  },
  onChange: (value) {
    setState(() => _changedFields.add('email'));
    viewModel.input.email = value;
  },
)

// En el botón de actualizar
if (formKey.currentState!.validate()) {
  // Validación completa pasó
  await viewModel.update();
}
```

## Campos Dependientes en Formularios UPDATE

Los campos dependientes son aquellos cuyo comportamiento (visibilidad, habilitación, valores) depende del valor de otros campos.

### 1. Campos que se Habilitan/Deshabilitan según otros

**Ejemplo: Tipo de examen habilita campos específicos**
```dart
class _ExamUpdatePageState extends State<ExamUpdatePage> {
  late ViewModel viewModel;
  ExamType? selectedType;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, exam: widget.exam);
    selectedType = widget.exam.type;
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          form: Form(
            child: Column(
              children: [
                // Campo principal
                DropdownButtonFormField<ExamType>(
                  value: selectedType,
                  decoration: InputDecoration(labelText: l10n.examType),
                  items: ExamType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(getExamTypeLabel(context, type)),
                    );
                  }).toList(),
                  onChanged: (ExamType? newValue) {
                    setState(() {
                      _changedFields.add('type');
                      selectedType = newValue;
                      viewModel.input.type = newValue;
                      
                      // ✅ Resetear campos dependientes si cambia el tipo
                      if (newValue != ExamType.blood) {
                        bloodTypeController.clear();
                        viewModel.input.bloodType = null;
                      }
                    });
                  },
                ),
                // Espaciado definido en theme
                
                // ✅ Campo dependiente - Solo visible si es examen de sangre
                if (selectedType == ExamType.blood)
                  CustomTextFormField(
                    labelText: l10n.bloodType,
                    controller: bloodTypeController,
                    enabled: selectedType == ExamType.blood,  // ✅ Habilitado condicionalmente
                    onChange: (value) {
                      setState(() => _changedFields.add('bloodType'));
                      viewModel.input.bloodType = value;
                    },
                  ),
                
                // ✅ Campo dependiente - Solo visible si es examen de orina
                if (selectedType == ExamType.urine)
                  CustomTextFormField(
                    labelText: l10n.urineColor,
                    controller: urineColorController,
                    enabled: selectedType == ExamType.urine,
                    onChange: (value) {
                      setState(() => _changedFields.add('urineColor'));
                      viewModel.input.urineColor = value;
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

### 2. Valores que se Recalculan Automáticamente

**Ejemplo: Total = Subtotal + Tax**
```dart
class _InvoiceUpdatePageState extends State<InvoiceUpdatePage> {
  late ViewModel viewModel;
  late TextEditingController subtotalController;
  late TextEditingController taxController;
  late TextEditingController totalController;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, invoice: widget.invoice);
    
    subtotalController = TextEditingController(
      text: widget.invoice.subtotal?.toString() ?? ''
    );
    taxController = TextEditingController(
      text: widget.invoice.tax?.toString() ?? ''
    );
    totalController = TextEditingController(
      text: widget.invoice.total?.toString() ?? ''
    );
    
    // ✅ Listeners para recalcular automáticamente
    subtotalController.addListener(_recalculateTotal);
    taxController.addListener(_recalculateTotal);
  }
  
  void _recalculateTotal() {
    final subtotal = num.tryParse(subtotalController.text) ?? 0;
    final tax = num.tryParse(taxController.text) ?? 0;
    final total = subtotal + tax;
    
    setState(() {
      totalController.text = total.toStringAsFixed(2);
      viewModel.input.total = total;
      _changedFields.add('total');
    });
  }
  
  @override
  void dispose() {
    subtotalController.removeListener(_recalculateTotal);
    taxController.removeListener(_recalculateTotal);
    subtotalController.dispose();
    taxController.dispose();
    totalController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      form: Form(
        child: Column(
          children: [
            CustomTextFormField(
              labelText: l10n.subtotal,
              controller: subtotalController,
              onChange: (value) {
                setState(() => _changedFields.add('subtotal'));
                viewModel.input.subtotal = num.tryParse(value);
                // _recalculateTotal() se llama automáticamente por el listener
              },
            ),
            // Espaciado definido en theme
            CustomTextFormField(
              labelText: l10n.tax,
              controller: taxController,
              onChange: (value) {
                setState(() => _changedFields.add('tax'));
                viewModel.input.tax = num.tryParse(value);
                // _recalculateTotal() se llama automáticamente
              },
            ),
            // Espaciado definido en theme
            CustomTextFormField(
              labelText: l10n.total,
              controller: totalController,
              enabled: false,  // ✅ Campo calculado, no editable
              filled: true,  // Estilo definido en theme
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3. Campos que Resetean Otros

**Ejemplo: Cambiar categoría limpia subcategoría**
```dart
class _ProductUpdatePageState extends State<ProductUpdatePage> {
  late ViewModel viewModel;
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  List<SubCategory> availableSubCategories = [];
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, product: widget.product);
    
    // ✅ Inicializar con valores existentes
    selectedCategory = widget.product.category;
    selectedSubCategory = widget.product.subCategory;
    _loadSubCategories(selectedCategory);
  }
  
  void _loadSubCategories(Category? category) {
    if (category != null) {
      // Cargar subcategorías disponibles para la categoría seleccionada
      availableSubCategories = getSubCategoriesForCategory(category);
    } else {
      availableSubCategories = [];
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      form: Form(
        child: Column(
          children: [
            // Campo principal
            DropdownButtonFormField<Category>(
              value: selectedCategory,
              decoration: InputDecoration(labelText: l10n.category),
              items: Category.values.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(getCategoryLabel(context, cat)),
                );
              }).toList(),
              onChanged: (Category? newValue) {
                setState(() {
                  _changedFields.add('category');
                  selectedCategory = newValue;
                  viewModel.input.category = newValue;
                  
                  // ✅ Resetear subcategoría cuando cambia la categoría
                  selectedSubCategory = null;
                  viewModel.input.subCategory = null;
                  _changedFields.add('subCategory');
                  
                  // Cargar nuevas subcategorías
                  _loadSubCategories(newValue);
                });
              },
            ),
            // Espaciado definido en theme
            
            // Campo dependiente
            DropdownButtonFormField<SubCategory>(
              value: selectedSubCategory,
              decoration: InputDecoration(labelText: l10n.subCategory),
              items: availableSubCategories.map((subCat) {
                return DropdownMenuItem(
                  value: subCat,
                  child: Text(getSubCategoryLabel(context, subCat)),
                );
              }).toList(),
              onChanged: selectedCategory == null ? null : (SubCategory? newValue) {
                setState(() {
                  _changedFields.add('subCategory');
                  selectedSubCategory = newValue;
                  viewModel.input.subCategory = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

### 4. Prellenado Condicional Complejo

**Ejemplo: Valor inicial depende de múltiples campos**
```dart
class _ExamTemplateUpdatePageState extends State<ExamTemplateUpdatePage> {
  late ViewModel viewModel;
  late TextEditingController priceController;
  bool _priceInitialized = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, template: widget.template);
    
    // ✅ Calcular precio inicial basado en múltiples factores
    if (!_priceInitialized) {
      final basePrice = widget.template.basePrice ?? 0;
      final complexity = widget.template.complexity ?? 1;
      final category = widget.template.category;
      
      // Cálculo condicional del precio
      num calculatedPrice = basePrice;
      if (category == ExamCategory.specialized) {
        calculatedPrice = basePrice * complexity * 1.5;
      } else {
        calculatedPrice = basePrice * complexity;
      }
      
      priceController = TextEditingController(
        text: calculatedPrice.toStringAsFixed(2)
      );
      viewModel.input.price = calculatedPrice;
      _priceInitialized = true;
    }
  }
}
```

### 5. Sección Completa Condicional

**Ejemplo: Enum controla visibilidad de sección**
```dart
class _UserUpdatePageState extends State<UserUpdatePage> {
  late ViewModel viewModel;
  bool _showAdvancedFields = false;
  Role? selectedRole;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, user: widget.user);
    
    selectedRole = widget.user.role;
    // ✅ Mostrar campos avanzados si es admin o root
    _showAdvancedFields = (selectedRole == Role.admin || selectedRole == Role.root);
  }
  
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      form: Form(
        child: Column(
          children: [
            // Campos básicos
            CustomTextFormField(
              labelText: l10n.firstName,
              controller: firstNameController,
              onChange: (value) {
                setState(() => _changedFields.add('firstName'));
                viewModel.input.firstName = value;
              },
            ),
            
            DropdownButtonFormField<Role>(
              value: selectedRole,
              decoration: InputDecoration(labelText: l10n.role),
              onChanged: (Role? newValue) {
                setState(() {
                  _changedFields.add('role');
                  selectedRole = newValue;
                  viewModel.input.role = newValue;
                  
                  // ✅ Actualizar visibilidad de sección avanzada
                  _showAdvancedFields = (newValue == Role.admin || newValue == Role.root);
                  
                  // Resetear campos avanzados si ya no son aplicables
                  if (!_showAdvancedFields) {
                    viewModel.input.systemAccess = null;
                    viewModel.input.apiKey = null;
                  }
                });
              },
            ),
            
            // ✅ Sección condicional completa
            if (_showAdvancedFields) ...[
              // Espaciado y divider definidos en theme
              Divider(),
              Text(
                l10n.advancedSettings,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // Espaciado definido en theme
              
              SwitchListTile(
                title: Text(l10n.systemAccess),
                value: viewModel.input.systemAccess ?? widget.user.systemAccess ?? false,
                onChanged: (bool value) {
                  setState(() {
                    _changedFields.add('systemAccess');
                    viewModel.input.systemAccess = value;
                  });
                },
              ),
              
              CustomTextFormField(
                labelText: l10n.apiKey,
                controller: apiKeyController,
                onChange: (value) {
                  setState(() => _changedFields.add('apiKey'));
                  viewModel.input.apiKey = value;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Notas Importantes sobre Campos Dependientes

1. **Inicialización correcta**: Evaluar dependencias en `didChangeDependencies` con datos ya cargados
2. **setState()**: Siempre llamar `setState` cuando cambies el estado de dependencias
3. **Reset de dependientes**: Limpiar campos dependientes cuando cambia el campo principal
4. **Validación condicional**: Validar campos dependientes solo si están visibles/habilitados
5. **Prellenado consistente**: Asegurar que los cálculos de prellenado sean determinísticos

## Características Opcionales UPDATE

Estas características son opcionales y **la IA debe preguntar al usuario** antes de implementarlas.

### [OPCIONAL A] Confirmación de Cambios sin Guardar

**Cuándo usar:**
- ✅ Formularios complejos con más de 5 campos editables
- ✅ Operaciones donde el usuario invierte tiempo significativo
- ✅ Datos críticos donde perder cambios sería problemático

**Cuándo NO usar:**
- ❌ Formularios simples con 2-3 campos
- ❌ Updates rápidos (toggles, cambios menores)
- ❌ Aplicaciones móviles donde el espacio es limitado

**Implementación con PopScope (Flutter 3.12+):**

```dart
class _UserUpdatePageState extends State<UserUpdatePage> {
  late ViewModel viewModel;
  final Set<String> _changedFields = {};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  bool get _hasUnsavedChanges => _changedFields.isNotEmpty;
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return PopScope(
      canPop: !_hasUnsavedChanges,  // ✅ Permitir cerrar si no hay cambios
      onPopInvoked: (bool didPop) async {
        // Si ya hizo pop, no hacer nada
        if (didPop) return;
        
        // ✅ Mostrar diálogo de confirmación
        final shouldDiscard = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(l10n.unsavedChanges),
              content: Text(l10n.unsavedChangesMessage),
              actions: [
                TextButton(
                  child: Text(l10n.cancel),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text(l10n.discardChanges),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                FilledButton(
                  child: Text(l10n.saveChanges),
                  onPressed: () async {
                    // ✅ Guardar antes de cerrar
                    if (formKey.currentState!.validate()) {
                      final isErr = await viewModel.update();
                      if (!isErr) {
                        if (!context.mounted) return;
                        Navigator.of(context).pop(true);
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
        
        // Si decidió descartar, cerrar el diálogo
        if (shouldDiscard == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return ContentDialog(
            icon: Icons.person,
            title: l10n.updateThing(l10n.user),
            loading: viewModel.loading,
            form: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    labelText: l10n.firstName,
                    controller: firstNameController,
                    onChange: (value) {
                      setState(() => _changedFields.add('firstName'));
                      viewModel.input.firstName = value;
                    },
                  ),
                  // ... resto de campos
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(l10n.cancel),
                    onPressed: () {
                      // PopScope manejará la confirmación
                      Navigator.of(context).pop();
                    },
                  ),
                  // Espaciado definido en theme
                  FilledButton(
                    onPressed: viewModel.loading ? null : () async {
                      if (formKey.currentState!.validate()) {
                        if (_hasUnsavedChanges) {
                          var isErr = await viewModel.update();
                          if (!isErr) {
                            if (!context.mounted) return;
                            Navigator.of(context).pop(true);
                          }
                        } else {
                          Navigator.of(context).pop(false);
                        }
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.updateThing(l10n.user)),
                        // Espaciado e indicador definidos en theme
                        if (viewModel.loading)
                          CircularProgressIndicator()  // Tamaño definido en theme
                        else
                          Icon(Icons.save),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
```

**Implementación con WillPopScope (Flutter < 3.12):**

```dart
return WillPopScope(
  onWillPop: () async {
    if (!_hasUnsavedChanges) {
      return true;  // Permitir cerrar sin confirmar
    }
    
    // Mostrar diálogo de confirmación
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.unsavedChanges),
          content: Text(l10n.unsavedChangesMessage),
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(l10n.discardChanges),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    
    return shouldPop ?? false;
  },
  child: ContentDialog(
    // ... resto del widget
  ),
);
```

### [OPCIONAL B] Optimistic UI Updates

**Cuándo usar:**
- ✅ Updates frecuentes (toggles, switches)
- ✅ UX fluida sin bloqueos perceptibles
- ✅ Operaciones que típicamente son rápidas (<2 segundos)
- ✅ Conexión estable al servidor

**Cuándo NO usar:**
- ❌ Operaciones críticas donde la confirmación es esencial
- ❌ Updates complejos con alta probabilidad de fallo
- ❌ Conexiones inestables o lentas
- ❌ Datos financieros o sensibles

**Implementación Completa:**

**1. ViewModel con Optimistic Updates:**

```dart
class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  bool _saving = false;  // ✅ Estado separado para "guardando en background"
  
  final UpdateUserInput input = UpdateUserInput();
  User? _currentUser;
  User? _previousUser;  // ✅ Backup para rollback
  
  User? get currentUser => _currentUser;
  bool get loading => _loading;
  bool get saving => _saving;  // ✅ Para mostrar indicador sutil
  
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }
  
  set saving(bool newSaving) {
    _saving = newSaving;
    notifyListeners();
  }
  
  ViewModel({
    required BuildContext context,
    required User user,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    _currentUser = user;
    
    // Prellenar input
    input.id = user.id;
    input.firstName = user.firstName;
    input.lastName = user.lastName;
    input.email = user.email;
  }
  
  // ✅ Update optimista - NO bloquea UI
  Future<bool> updateOptimistic({
    String? firstName,
    String? lastName,
    String? email,
    bool? isActive,
  }) async {
    bool isError = false;
    
    // ✅ 1. Guardar estado anterior para rollback
    _previousUser = User(
      id: _currentUser!.id,
      firstName: _currentUser!.firstName,
      lastName: _currentUser!.lastName,
      email: _currentUser!.email,
      isActive: _currentUser!.isActive,
    );
    
    // ✅ 2. Aplicar cambios inmediatamente a la UI
    _applyOptimisticUpdate(
      firstName: firstName,
      lastName: lastName,
      email: email,
      isActive: isActive,
    );
    
    // ✅ 3. Mostrar indicador sutil "guardando..."
    saving = true;
    
    // ✅ 4. Enviar update al servidor en background
    try {
      UpdateUserUsecase useCase = UpdateUserUsecase(
        operation: UpdateUserMutation(builder: UserFieldsBuilder()),
        conn: _gqlConn,
      );
      
      // Actualizar input solo con campos modificados
      if (firstName != null) input.firstName = firstName;
      if (lastName != null) input.lastName = lastName;
      if (email != null) input.email = email;
      if (isActive != null) input.isActive = isActive;
      
      var response = await useCase.execute(input: input);
      
      if (response is User) {
        // ✅ 5a. Éxito: actualizar con datos del servidor
        _currentUser = response;
        isError = false;
        
        // Mostrar feedback sutil de éxito
        _errorService.showError(
          message: l10n.changesSaved,
          type: ErrorType.success,
          duration: Duration(seconds: 2),
        );
      } else {
        isError = true;
        _rollbackUpdate();
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en updateOptimistic: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      // ✅ 5b. Error: revertir cambios
      _rollbackUpdate();
      
      _errorService.showError(
        message: 'Error al actualizar: ${e.toString()}',
        type: ErrorType.error,
      );
    } finally {
      saving = false;
    }
    
    return isError;
  }
  
  // ✅ Aplicar cambios optimistamente
  void _applyOptimisticUpdate({
    String? firstName,
    String? lastName,
    String? email,
    bool? isActive,
  }) {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        firstName: firstName ?? _currentUser!.firstName,
        lastName: lastName ?? _currentUser!.lastName,
        email: email ?? _currentUser!.email,
        isActive: isActive ?? _currentUser!.isActive,
      );
      notifyListeners();
    }
  }
  
  // ✅ Revertir a estado anterior si falla
  void _rollbackUpdate() {
    if (_previousUser != null) {
      _currentUser = _previousUser;
      _previousUser = null;
      notifyListeners();
    }
  }
}
```

**2. UI con Optimistic Updates:**

```dart
class _UserUpdatePageState extends State<UserUpdatePage> {
  late ViewModel viewModel;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, user: widget.user);
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.person,
          title: Row(
            children: [
              Text(l10n.updateThing(l10n.user)),
              // ✅ Indicador sutil "guardando..."
              if (viewModel.saving) ...[
                // Espaciado, tamaño y color definidos en theme
                CircularProgressIndicator(),  // Tamaño definido en theme
                Text(
                  l10n.saving,
                  style: Theme.of(context).textTheme.bodySmall,  // Usar theme
                ),
              ],
            ],
          ),
          loading: viewModel.loading,
          form: Form(
            child: Column(
              children: [
                // ✅ Switch con update optimista
                SwitchListTile(
                  title: Text(l10n.isActive),
                  subtitle: viewModel.saving 
                    ? Text(l10n.saving, style: Theme.of(context).textTheme.bodySmall)  // Usar theme
                    : null,
                  value: viewModel.currentUser?.isActive ?? false,
                  onChanged: (bool value) async {
                    // ✅ Update inmediato sin esperar
                    await viewModel.updateOptimistic(isActive: value);
                  },
                ),
                
                // Campos de texto normales
                CustomTextFormField(
                  labelText: l10n.firstName,
                  controller: TextEditingController(
                    text: viewModel.currentUser?.firstName ?? ''
                  ),
                  onChange: (value) {
                    viewModel.input.firstName = value;
                  },
                ),
              ],
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
                // Espaciado definido en theme
                FilledButton(
                  onPressed: viewModel.loading || viewModel.saving 
                    ? null 
                    : () async {
                      // Update normal de campos de texto
                      var isErr = await viewModel.update();
                      if (!isErr) {
                        if (!context.mounted) return;
                        context.pop(true);
                      }
                    },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.save),
                      // Espaciado e indicador definidos en theme
                      if (viewModel.loading)
                        CircularProgressIndicator()  // Tamaño definido en theme
                      else
                        Icon(Icons.save),
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
```

**3. Ejemplo de uso específico - Toggle rápido:**

```dart
// Toggle de estado activo/inactivo con optimistic update
IconButton(
  icon: Icon(
    user.isActive ? Icons.check_circle : Icons.cancel,
    // Color definido en theme
  ),
  onPressed: () async {
    // ✅ UI se actualiza inmediatamente
    // Servidor se actualiza en background
    await userViewModel.updateOptimistic(
      isActive: !user.isActive,
    );
    // Si falla, se revierte automáticamente
  },
)
```

### Comparación: Update Normal vs Optimistic

| Aspecto | Update Normal | Optimistic Update |
|---------|---------------|-------------------|
| **UX** | Bloquea UI con loading | UI responde inmediatamente |
| **Feedback** | Espera confirmación servidor | Asume éxito, revierte si falla |
| **Casos de uso** | Updates críticos, formularios | Toggles, switches, cambios rápidos |
| **Complejidad** | Más simple | Requiere rollback logic |
| **Confiabilidad** | Más seguro | Requiere conexión estable |
| **Loading state** | Bloquea toda la UI | Indicador sutil en background |

## Manejo de Errores Específicos UPDATE

### Errores Comunes y su Manejo

#### 1. Registro No Encontrado (404)

**Cuándo ocurre:**
- El registro fue eliminado por otro usuario
- ID inválido o corrupto
- Problema de sincronización de datos

**Implementación:**
```dart
Future<bool> update() async {
  bool isError = true;
  loading = true;

  UpdateUserUsecase useCase = UpdateUserUsecase(
    operation: UpdateUserMutation(builder: UserFieldsBuilder()),
    conn: _gqlConn,
  );

  try {
    var response = await useCase.execute(input: input);
    
    if (response is User) {
      isError = false;
      _errorService.showError(
        message: l10n.thingUpdatedSuccessfully(l10n.user),
        type: ErrorType.success,
      );
    }
  } on NotFoundException catch (e, stackTrace) {
    debugPrint('💥 Registro no encontrado: $e');
    debugPrint('📍 StackTrace: $stackTrace');
    isError = true;
    
    _errorService.showError(
      message: l10n.recordNotFound,
      type: ErrorType.error,
    );
    
    // ✅ Redirigir a la lista después de mostrar error
    Future.delayed(Duration(seconds: 2), () {
      if (_context.mounted) {
        _context.pop(false);  // Cerrar diálogo y volver a lista
      }
    });
  } catch (e, stackTrace) {
    debugPrint('💥 Error en updateUser: $e');
    debugPrint('📍 StackTrace: $stackTrace');
    isError = true;
    
    _errorService.showError(
      message: 'Error al actualizar usuario: ${e.toString()}',
    );
  } finally {
    loading = false;
  }

  return isError;
}
```

#### 2. Conflicto de Versión / Concurrencia Optimista

**Cuándo ocurre:**
- Otro usuario modificó el registro simultáneamente
- Versión de datos desactualizada

**Implementación:**
```dart
} on ConflictException catch (e, stackTrace) {
  debugPrint('💥 Conflicto de versión: $e');
  debugPrint('📍 StackTrace: $stackTrace');
  isError = true;
  
  // ✅ Mostrar diálogo con opciones
  final action = await showDialog<String>(
    context: _context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.conflictError),
        content: Text(l10n.conflictErrorMessage),
        actions: [
          TextButton(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.of(context).pop('cancel'),
          ),
          TextButton(
            child: Text(l10n.reloadData),
            onPressed: () => Navigator.of(context).pop('reload'),
          ),
          FilledButton(
            child: Text(l10n.overwrite),
            onPressed: () => Navigator.of(context).pop('overwrite'),
          ),
        ],
      );
    },
  );
  
  if (action == 'reload') {
    // Recargar datos frescos del servidor
    await loadData(input.id);
  } else if (action == 'overwrite') {
    // Forzar actualización (si el servidor lo permite)
    input.forceUpdate = true;
    return await update();  // Reintentar
  }
}
```

#### 3. Permisos Insuficientes

**Cuándo ocurre:**
- Usuario sin permisos para modificar el registro
- Intento de modificar campos protegidos
- Cambio de permisos durante la sesión

**Implementación:**
```dart
} on PermissionException catch (e, stackTrace) {
  debugPrint('💥 Permisos insuficientes: $e');
  debugPrint('📍 StackTrace: $stackTrace');
  isError = true;
  
  _errorService.showError(
    message: l10n.permissionDenied,
    type: ErrorType.error,
  );
  
  // Opcional: cerrar diálogo automáticamente
  Future.delayed(Duration(seconds: 2), () {
    if (_context.mounted) {
      _context.pop(false);
    }
  });
}
```

#### 4. Validaciones de Negocio del Servidor

**Cuándo ocurre:**
- Reglas de negocio no se cumplen
- Datos inconsistentes o inválidos
- Restricciones específicas del dominio

**Implementación:**
```dart
} on ValidationException catch (e, stackTrace) {
  debugPrint('💥 Error de validación: $e');
  debugPrint('📍 StackTrace: $stackTrace');
  isError = true;
  
  // ✅ Parsear mensaje de error del servidor
  String errorMessage = l10n.validationError;
  
  if (e.errors != null && e.errors!.isNotEmpty) {
    // Mostrar errores específicos por campo
    final fieldErrors = e.errors!.map((err) {
      return '• ${err.field}: ${err.message}';
    }).join('\n');
    
    errorMessage = '${l10n.validationErrors}:\n$fieldErrors';
  }
  
  _errorService.showError(
    message: errorMessage,
    type: ErrorType.error,
    duration: Duration(seconds: 5),  // Más tiempo para leer
  );
}
```

#### 5. Timeout de Operación

**Cuándo ocurre:**
- Conexión lenta o inestable
- Servidor sobrecargado
- Operación muy compleja

**Implementación:**
```dart
} on TimeoutException catch (e, stackTrace) {
  debugPrint('💥 Timeout en update: $e');
  debugPrint('📍 StackTrace: $stackTrace');
  isError = true;
  
  // ✅ Ofrecer reintentar
  final shouldRetry = await showDialog<bool>(
    context: _context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.timeoutError),
        content: Text(l10n.timeoutErrorMessage),
        actions: [
          TextButton(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FilledButton(
            child: Text(l10n.retry),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );
  
  if (shouldRetry == true) {
    // ✅ Reintentar operación
    return await update();
  }
}
```

### ViewModel Completo con Manejo de Errores

```dart
import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/updateUser/updateuser_mutation.dart';
import 'package:labs/src/domain/usecases/User/update_user_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  
  final UpdateUserInput input = UpdateUserInput();
  User? _currentUser;

  bool get loading => _loading;
  User? get currentUser => _currentUser;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({
    required BuildContext context,
    required User user,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<GQLNotifier>().errorService;
    _currentUser = user;
    
    // Prellenar input
    input.id = user.id;
    input.firstName = user.firstName;
    input.lastName = user.lastName;
    input.email = user.email;
  }

  Future<bool> update() async {
    bool isError = true;
    loading = true;

    UpdateUserUsecase useCase = UpdateUserUsecase(
      operation: UpdateUserMutation(builder: UserFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute(input: input);
      
      if (response is User) {
        isError = false;
        _currentUser = response;
        
        _errorService.showError(
          message: l10n.thingUpdatedSuccessfully(l10n.user),
          type: ErrorType.success,
        );
      }
    } on NotFoundException catch (e, stackTrace) {
      debugPrint('💥 Registro no encontrado: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: l10n.recordNotFound,
        type: ErrorType.error,
      );
      
      Future.delayed(Duration(seconds: 2), () {
        if (_context.mounted) _context.pop(false);
      });
      
    } on ConflictException catch (e, stackTrace) {
      debugPrint('💥 Conflicto de versión: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: l10n.conflictError,
        type: ErrorType.error,
      );
      
    } on PermissionException catch (e, stackTrace) {
      debugPrint('💥 Permisos insuficientes: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: l10n.permissionDenied,
        type: ErrorType.error,
      );
      
    } on ValidationException catch (e, stackTrace) {
      debugPrint('💥 Error de validación: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: e.message ?? l10n.validationError,
        type: ErrorType.error,
      );
      
    } on TimeoutException catch (e, stackTrace) {
      debugPrint('💥 Timeout: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: l10n.timeoutError,
        type: ErrorType.error,
      );
      
    } catch (e, stackTrace) {
      debugPrint('💥 Error desconocido en updateUser: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: 'Error al actualizar usuario: ${e.toString()}',
        type: ErrorType.error,
      );
    } finally {
      loading = false;
    }

    return isError;
  }
}
```

## Internacionalización para UPDATE

Siguiendo las convenciones de CREATE, todas las cadenas de texto deben estar internacionalizadas usando `AppLocalizations`.

### Keys i18n Requeridas

**app_es.arb:**
```json
{
  "updateThing": "Actualizar {0}",
  "thingUpdatedSuccessfully": "Se actualizó {0} correctamente",
  "errorUpdating": "Error al actualizar",
  "loadingData": "Cargando datos...",
  "save": "Guardar",
  "saving": "Guardando...",
  "changesSaved": "Cambios guardados",
  
  "recordNotFound": "Registro no encontrado",
  "recordNotFoundMessage": "El registro que intentas editar ya no existe. Puede haber sido eliminado por otro usuario.",
  
  "conflictError": "Conflicto de versión",
  "conflictErrorMessage": "Otro usuario modificó este registro. ¿Qué deseas hacer?",
  "reloadData": "Recargar datos",
  "overwrite": "Sobrescribir",
  
  "permissionDenied": "Sin permisos",
  "permissionDeniedMessage": "No tienes permisos para modificar este registro.",
  
  "validationError": "Error de validación",
  "validationErrors": "Errores de validación",
  
  "timeoutError": "Tiempo de espera agotado",
  "timeoutErrorMessage": "La operación tardó demasiado tiempo. ¿Deseas reintentar?",
  "retry": "Reintentar",
  
  "unsavedChanges": "Cambios sin guardar",
  "unsavedChangesMessage": "Tienes cambios sin guardar. ¿Qué deseas hacer?",
  "discardChanges": "Descartar cambios",
  "saveChanges": "Guardar cambios",
  
  "nonEditableInformation": "Información no editable",
  "advancedSettings": "Configuración avanzada"
}
```

**app_en.arb:**
```json
{
  "updateThing": "Update {0}",
  "thingUpdatedSuccessfully": "{0} updated successfully",
  "errorUpdating": "Error updating",
  "loadingData": "Loading data...",
  "save": "Save",
  "saving": "Saving...",
  "changesSaved": "Changes saved",
  
  "recordNotFound": "Record not found",
  "recordNotFoundMessage": "The record you're trying to edit no longer exists. It may have been deleted by another user.",
  
  "conflictError": "Version conflict",
  "conflictErrorMessage": "Another user modified this record. What would you like to do?",
  "reloadData": "Reload data",
  "overwrite": "Overwrite",
  
  "permissionDenied": "Permission denied",
  "permissionDeniedMessage": "You don't have permission to modify this record.",
  
  "validationError": "Validation error",
  "validationErrors": "Validation errors",
  
  "timeoutError": "Timeout",
  "timeoutErrorMessage": "The operation took too long. Would you like to retry?",
  "retry": "Retry",
  
  "unsavedChanges": "Unsaved changes",
  "unsavedChangesMessage": "You have unsaved changes. What would you like to do?",
  "discardChanges": "Discard changes",
  "saveChanges": "Save changes",
  
  "nonEditableInformation": "Non-editable information",
  "advancedSettings": "Advanced settings"
}
```

### Ejemplos de Uso en Código

**En el título del ContentDialog:**
```dart
ContentDialog(
  icon: Icons.person,
  title: l10n.updateThing(l10n.user),  // "Actualizar Usuario"
  // ...
)
```

**En el botón de actualizar:**
```dart
FilledButton(
  child: Row(
    children: [
      Text(l10n.updateThing(l10n.user)),  // "Actualizar Usuario"
      // Espaciado e indicador definidos en theme
      if (viewModel.loading)
        CircularProgressIndicator()
      else
        Icon(Icons.save),
    ],
  ),
  onPressed: () async {
    // ...
  },
)
```

**En mensajes de éxito:**
```dart
_errorService.showError(
  message: l10n.thingUpdatedSuccessfully(l10n.user),  // "Se actualizó Usuario correctamente"
  type: ErrorType.success,
);
```

**En helper functions para Enums (reutilizar de CREATE):**
```dart
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
```

### Regla de Oro

**❌ NUNCA hardcodear textos:**
```dart
// MAL ❌
Text("Actualizar Usuario")
```

**✅ SIEMPRE usar l10n:**
```dart
// BIEN ✅
Text(l10n.updateThing(l10n.user))
```

## Flujo Completo UPDATE

```
1. Usuario hace clic en botón "Editar" desde lista
   ↓
2. Navegación pasa objeto completo (Opción A recomendada)
   context.push('/users/update', extra: user)
   ↓
3. UserUpdatePage recibe objeto en constructor
   ↓
4. didChangeDependencies() crea ViewModel con datos
   viewModel = ViewModel(context: context, user: widget.user)
   ↓
5. ViewModel prellenado inmediatamente en constructor
   input.id = user.id
   input.firstName = user.firstName
   // ... resto de campos
   ↓
6. Controllers y dropdowns inicializados con valores existentes
   firstNameController = TextEditingController(text: user.firstName)
   selectedRole = user.role
   ↓
7. UI muestra formulario prellenado (sin loading inicial)
   ↓
8. Usuario modifica campos
   - onChange actualiza viewModel.input
   - Se registra en _changedFields (si hay validación diferencial)
   ↓
9. Usuario hace clic "Actualizar {Feature}"
   ↓
10. Validación de formulario
    formKey.currentState!.validate()
    ↓
11. ViewModel.update() inicia
    loading = true, notifyListeners()
    ↓
12. UseCase ejecuta mutation
    UpdateUserUsecase.execute(input: input)
    ↓
13. UseCase crea nueva mutation con declarativeArgs
    opArgs: {"input": GqlVar("name")}
    ↓
14. GraphQL mutation enviada al servidor
    mutation updateUser($name: UpdateUserInput!) { ... }
    ↓
15. Response transformada a entidad User
    Mutation.result(data) → User.fromJson()
    ↓
16. Verificación en ViewModel
    if (response is User) → Éxito
    else → Error
    ↓
17. Manejo de errores específicos
    - NotFoundException → Redirigir
    - ConflictException → Diálogo opciones
    - PermissionException → Mensaje error
    - ValidationException → Errores por campo
    - TimeoutException → Reintentar
    ↓
18. Si éxito:
    - loading = false
    - Mostrar success message
    - context.pop(true)
    ↓
19. Padre (READ) detecta pop(true)
    ↓
20. Refresca lista automáticamente
    if (result == true) viewModel.getUsers()
```

## Clonación Rápida para Nuevos Módulos UPDATE

Para crear un nuevo módulo de actualización (ej: Product):

### 1. ⚠️ PRIMERO: Verificar Update{Feature}Input

**Verificar archivo existe:**
- Buscar: `/src/domain/entities/types/product/inputs/updateproductinput_input.dart`
- ✅ Verificar tiene campo `_id` con `@JsonKey(name: "_id")`
- ✅ Verificar solo tiene campos editables (comparar con entidad completa)

### 2. ⚠️ SEGUNDO: Verificar FieldsBuilder Extension

- Buscar: `/src/domain/extensions/product_fields_builder_extension.dart`
- Si NO existe → Crear con método `defaultValues()`
- Incluir todos los campos que necesitas del servidor

### 3. Identificar Campos Solo Lectura

**Comparar entidad vs UpdateInput:**
- Leer entidad completa: `/src/domain/entities/types/product/product_model.dart`
- Leer UpdateInput: `/src/domain/entities/types/product/inputs/updateproductinput_input.dart`
- Listar campos que están en entidad pero NO en UpdateInput
- Estos serán campos de solo lectura en el formulario

### 4. Copiar Estructura

**Copiar de User/update → Product/update:**
```bash
cp -r /pages/User/update /pages/Product/update
```

### 5. Buscar y Reemplazar

**En todos los archivos copiados:**
- `User` → `Product`
- `user` → `product`
- `Usuario` → `Producto`
- `UserUpdatePage` → `ProductUpdatePage`
- `UpdateUserInput` → `UpdateProductInput`
- `UpdateUserUsecase` → `UpdateProductUsecase`
- `UpdateUserMutation` → `UpdateProductMutation`

**Ejemplo con sed:**
```bash
find /pages/Product/update -type f -exec sed -i 's/User/Product/g' {} \;
find /pages/Product/update -type f -exec sed -i 's/user/product/g' {} \;
find /pages/Product/update -type f -exec sed -i 's/Usuario/Producto/g' {} \;
```

### 6. Archivos Genéricos Mantienen Nombre

- ✅ `main.dart` (mismo nombre en todos los módulos)
- ✅ `view_model.dart` (mismo nombre en todos los módulos)

### 7. Implementar loadData() en ViewModel

**Con Opción A (objeto completo - recomendado):**
```dart
ViewModel({
  required BuildContext context,
  required Product product,  // ✅ Cambiar tipo
}) : _context = context {
  _gqlConn = _context.read<GQLNotifier>().gqlConn;
  _errorService = _context.read<ErrorService>();
  _currentProduct = product;
  
  // Prellenar input
  input.id = product.id;
  input.name = product.name;
  input.price = product.price;
  // ... resto de campos editables
}
```

### 8. Implementar update() en ViewModel

**Similar a create() del patrón CREATE:**
```dart
Future<bool> update() async {
  bool isError = true;
  loading = true;

  UpdateProductUsecase useCase = UpdateProductUsecase(
    operation: UpdateProductMutation(builder: ProductFieldsBuilder()),
    conn: _gqlConn,
  );

  try {
    var response = await useCase.execute(input: input);
    
    if (response is Product) {
      isError = false;
      _errorService.showError(
        message: l10n.thingUpdatedSuccessfully(l10n.product),
        type: ErrorType.success,
      );
    }
  } catch (e, stackTrace) {
    debugPrint('💥 Error en updateProduct: $e');
    debugPrint('📍 StackTrace: $stackTrace');
    isError = true;
    
    _errorService.showError(
      message: 'Error al actualizar producto: ${e.toString()}',
    );
  } finally {
    loading = false;
  }

  return isError;
}
```

### 9. Ajustar Formulario en main.dart

**Inicializar controllers con datos existentes:**
```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  viewModel = ViewModel(context: context, product: widget.product);
  
  // ✅ Ajustar campos específicos del Product
  nameController = TextEditingController(text: widget.product.name ?? '');
  priceController = TextEditingController(text: widget.product.price?.toString() ?? '');
  // ... resto de campos
}
```

**Ajustar campos del formulario:**
```dart
CustomTextFormField(
  labelText: l10n.productName,  // ✅ Cambiar label
  controller: nameController,
  onChange: (value) {
    setState(() => _changedFields.add('name'));
    viewModel.input.name = value;
  },
),
```

### 10. Configurar Navegación

**En la página de listado (product_item.dart o similar):**
```dart
IconButton(
  icon: const Icon(Icons.edit),
  onPressed: () async {
    // ✅ Pasar objeto completo (Opción A)
    final result = await context.push('/products/update', extra: product);
    
    if (result == true) {
      // Recargar lista
      viewModel.getProducts();
    }
  },
)
```

### 11. Añadir Campos Solo Lectura (si es necesario)

**Si hay campos solo lectura:**
```dart
// Sección de información no editable
Card(
  // Color y padding definidos en theme
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.nonEditableInformation,
        style: Theme.of(context).textTheme.titleSmall,  // Usar theme
      ),
      _buildReadOnlyField(l10n.createdAt, widget.product.createdAt),
      _buildReadOnlyField(l10n.category, widget.product.category),
    ],
  ),
)
```

### Checklist de Clonación

- [ ] Update{Feature}Input existe con campo `_id`
- [ ] {Feature}FieldsBuilder extension con `defaultValues()`
- [ ] Campos solo lectura identificados (entidad vs UpdateInput)
- [ ] Estructura copiada desde User/update
- [ ] Búsqueda y reemplazo de nombres completada
- [ ] loadData() implementado (si usa Opción B/C) o constructor prellenado (Opción A)
- [ ] update() implementado con manejo de errores
- [ ] Formulario ajustado con campos específicos
- [ ] Controllers inicializados con datos existentes
- [ ] Navegación configurada con objeto completo
- [ ] Keys i18n agregadas para el nuevo feature
- [ ] Campos solo lectura añadidos si es necesario

## Checklist de Verificación UPDATE

### Presentación (/pages/{Feature}/update/)

**main.dart:**
- [ ] Usa `ContentDialog` con icon, title, loading, form, actions
- [ ] Recibe objeto completo (`final {Feature} {feature};`) o ID como parámetro
- [ ] Tiene `GlobalKey<FormState>` para validación
- [ ] Controllers inicializados con datos existentes en `didChangeDependencies`
- [ ] Campos solo lectura mostrados con `enabled: false` y `filled: true`
- [ ] `ListenableBuilder` para reactivity
- [ ] Obtiene `l10n` con `AppLocalizations.of(context)!`
- [ ] Usa `l10n.updateThing(l10n.{feature})` en título y botón
- [ ] Usa `l10n` para labels de todos los campos
- [ ] `onChange` actualiza `viewModel.input.{field}`
- [ ] Registra cambios en `_changedFields` (si hay validación diferencial)
- [ ] Botón "Cancelar" hace `context.pop()` sin argumentos
- [ ] Botón "Actualizar" valida antes de llamar `viewModel.update()`
- [ ] Botón "Actualizar" muestra `CircularProgressIndicator` cuando loading
- [ ] Botón "Actualizar" deshabilitado cuando loading
- [ ] Verifica `context.mounted` antes de `context.pop(true)`
- [ ] Retorna `true` en `context.pop()` para indicar éxito
- [ ] Disposal de todos los controllers en `dispose()`
- [ ] Sin strings hardcodeados

**view_model.dart:**
- [ ] Extiende `ChangeNotifier`
- [ ] Estado `_loading` con getter y setter
- [ ] Setter de `loading` llama `notifyListeners()`
- [ ] Field `input` del tipo `Update{Feature}Input`
- [ ] Field `_currentUser` (o current{Feature}) para almacenar datos cargados
- [ ] Inicializa `GqlConn` y `ErrorService` en constructor
- [ ] Constructor recibe objeto completo (Opción A) o ID (Opción B/C)
- [ ] Método `loadData()` si usa Opción B/C con carga asíncrona
- [ ] Input prellenado con datos existentes en constructor o loadData()
- [ ] Campo `input.id` asignado con `_id` del registro
- [ ] Método `update()` retorna `Future<bool>`
- [ ] `update()` crea UseCase con Mutation y FieldsBuilder
- [ ] `update()` llama `useCase.execute(input: input)`
- [ ] Type checking: `response is {Feature}`
- [ ] ⚠️ **Error handling con try-catch-finally**
- [ ] ⚠️ **catch incluye stackTrace: `catch (e, stackTrace)`**
- [ ] ⚠️ **debugPrint con emoji 💥 para error y 📍 para stackTrace**
- [ ] ⚠️ **ErrorService.showError() para feedback al usuario**
- [ ] ⚠️ **Import `package:flutter/foundation.dart` para debugPrint**
- [ ] ⚠️ **Manejo específico de errores: NotFoundException, ConflictException, etc.**
- [ ] finally apaga loading siempre
- [ ] Retorna `false` si éxito, `true` si error

### Dominio

**UpdateInput:**
- [ ] `Update{Feature}Input` existe en `/domain/entities/types/{feature}/inputs/`
- [ ] Tiene campo `_id` con `@JsonKey(name: "_id")`
- [ ] Campo `_id` es obligatorio (no nullable)
- [ ] Tiene MENOS campos que `Create{Feature}Input`
- [ ] Solo incluye campos editables (no campos inmutables)
- [ ] Usa `@JsonSerializable(includeIfNull: false)`
- [ ] Tiene `toJson()` y `fromJson()`

**Mutation y UseCase:**
- [ ] `Update{Feature}Mutation` implementada en `/operation/mutations/update{Feature}/`
- [ ] `Update{Feature}Usecase` con método `execute()` en `/usecases/{Feature}/`
- [ ] UseCase usa `{Feature}FieldsBuilder().defaultValues()` en execute()
- [ ] UseCase crea nueva mutation dentro de execute() (NO modifica la del constructor)
- [ ] UseCase usa `GqlVar("name")` en opArgs
- [ ] UseCase pasa input directo en variables (NO serializado)
- [ ] Mutation retorna entidad {Feature}

**FieldsBuilder Extension:**
- [ ] `{Feature}FieldsBuilderExtension` existe en `/extensions/`
- [ ] Extension tiene método `defaultValues()` con todos los campos necesarios
- [ ] Extension importada en el UseCase

### Internacionalización

**Keys i18n:**
- [ ] `updateThing` en app_es.arb y app_en.arb
- [ ] `thingUpdatedSuccessfully` en ambos archivos
- [ ] `errorUpdating`, `loadingData`, `save`, `saving` en ambos
- [ ] `recordNotFound`, `conflictError`, `permissionDenied` en ambos
- [ ] `unsavedChanges`, `discardChanges`, `saveChanges` (si usa confirmación)
- [ ] `nonEditableInformation` (si hay campos solo lectura)
- [ ] Labels específicos del feature en ambos archivos
- [ ] Helper functions para Enums con labels i18n (reutilizar de CREATE)
- [ ] Usa `l10n` para TODOS los textos visibles
- [ ] Sin strings hardcodeados

### General

- [ ] Context se pasa como parámetro, nunca se almacena
- [ ] Controllers se limpian en dispose()
- [ ] 🐛 Usar `debugPrint` en lugar de `print` para debugging
- [ ] ✅ Import `package:flutter/foundation.dart` en archivos de dominio que usen debugPrint
- [ ] Prellenado de campos ocurre DESPUÉS de cargar datos (si es asíncrono)
- [ ] Campos dependientes manejan setState correctamente
- [ ] Validación diferencial implementada (opcional)
- [ ] Sin errores de compilación
- [ ] Mutation y UseCase en carpetas correctas

### Características Opcionales (si se implementaron)

**Confirmación de cambios sin guardar:**
- [ ] `PopScope` o `WillPopScope` implementado
- [ ] Tracking de `_hasUnsavedChanges` basado en `_changedFields`
- [ ] Diálogo de confirmación con opciones claras
- [ ] Keys i18n para mensajes de confirmación

**Optimistic UI Updates:**
- [ ] Método `updateOptimistic()` en ViewModel
- [ ] Backup de estado anterior (`_previousUser`)
- [ ] Método `_applyOptimisticUpdate()` implementado
- [ ] Método `_rollbackUpdate()` implementado
- [ ] Indicador visual "guardando..." sin bloquear UI
- [ ] Manejo de errores con restauración automática

## Mejores Prácticas

### Debugging

**🐛 USAR debugPrint EN LUGAR DE print:**
```dart
// MAL ❌
print('Valor: $value');

// BIEN ✅
debugPrint('Valor: $value');
```

**Razones:**
- `debugPrint` no se trunca en consola con textos largos
- Solo imprime en modo debug, no en release
- Mejor rendimiento en producción
- Es la práctica recomendada de Flutter
- Requiere `import 'package:flutter/foundation.dart';` en archivos de dominio

**Emojis para filtrado:**
- 💥 para errores
- 📍 para stackTrace
- ✅ para operaciones exitosas
- ⚠️ para warnings

### Internacionalización

**❌ NUNCA hardcodear textos:**
```dart
// MAL ❌
Text("Actualizar Usuario")
ContentDialog(title: "Editar Producto")
```

**✅ SIEMPRE usar l10n:**
```dart
// BIEN ✅
Text(l10n.updateThing(l10n.user))
ContentDialog(title: l10n.updateThing(l10n.product))
```

### Context Management

- Context se pasa como parámetro en constructores
- NUNCA almacenar context en variables de instancia
- Verificar `context.mounted` antes de usar `context.pop()` en callbacks async
- Usar `BuildContext` directamente en métodos síncronos

### Manejo de Errores

**⚠️ SIEMPRE capturar stackTrace en catch:**
```dart
// MAL ❌
catch (e) {
  debugPrint('Error: $e');
}

// BIEN ✅
catch (e, stackTrace) {
  debugPrint('💥 Error en update{Feature}: $e');
  debugPrint('📍 StackTrace: $stackTrace');
  
  _errorService.showError(
    message: 'Error al actualizar: ${e.toString()}',
    type: ErrorType.error,
  );
}
```

**Elementos Requeridos:**
1. **stackTrace parameter** - Segunda variable en catch para debugging completo
2. **debugPrint con emojis** - 💥 para error, 📍 para stackTrace (facilita filtrado)
3. **ErrorService.showError()** - Feedback visual al usuario con SnackBar
4. **Mensaje descriptivo** - "Error al [operación]" + detalles del error
5. **Import foundation.dart** - `import 'package:flutter/foundation.dart';`
6. **Manejo específico** - Diferentes catch para diferentes tipos de error

### Prellenado de Datos

**Orden correcto de inicialización:**
1. Cargar/recibir datos del registro existente
2. Crear ViewModel con datos
3. Inicializar controllers con valores existentes
4. Renderizar formulario prellenado

**Con objeto completo (Opción A - recomendada):**
```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  // 1. Crear ViewModel con datos
  viewModel = ViewModel(context: context, user: widget.user);
  
  // 2. Inicializar controllers con valores existentes
  nameController = TextEditingController(text: widget.user.name ?? '');
  emailController = TextEditingController(text: widget.user.email ?? '');
}
```

### Validación Diferencial

**Optimización recomendada:**
- Usar `Set<String> _changedFields` para tracking
- Registrar cambios en `onChange` callbacks
- Solo enviar campos modificados con `includeIfNull: false`
- Método `hasChanges()` para detectar modificaciones

### Campos Dependientes

**Buenas prácticas:**
- Evaluar dependencias en `didChangeDependencies` después de cargar datos
- Siempre llamar `setState` al cambiar dependencias
- Resetear campos dependientes cuando cambia el campo principal
- Validar solo campos visibles/habilitados
- Inicialización determinística

## Ventajas del Patrón UPDATE

1. **Modal consistente con CREATE** - Misma UX familiar
2. **Prellenado automático** - Datos existentes listos para editar
3. **Validación integrada** - Form con GlobalKey
4. **Loading state claro** - Feedback visual durante operaciones
5. **Optimización con campos modificados** - Validación diferencial opcional
6. **Manejo robusto de errores** - Casos específicos bien manejados
7. **Cierre automático al éxito** - context.pop(true) tras actualizar
8. **Refresh automático del listado** - Padre refresca al detectar true
9. **Campos solo lectura** - Información contextual no editable
10. **Campos dependientes** - Lógica condicional bien estructurada
11. **Características opcionales** - Confirmación y optimistic updates

## Próximos Chatmodes

- ✅ `create_pattern.chatmode.md` - Patrón para CREATE (formularios)
- ✅ `read_pattern.chatmode.md` - Patrón para READ (listado)
- ✅ `update_pattern.chatmode.md` - Patrón para UPDATE (edición) ← ESTE
- 🔜 `delete_pattern.chatmode.md` - Patrón para DELETE (confirmación)

# ````
