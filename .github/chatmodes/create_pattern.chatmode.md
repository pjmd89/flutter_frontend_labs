# Patrón de Arquitectura Modular Flutter - CREATE (Creación con Formulario)

Este chatmode documenta el patrón completo para implementar módulos de **creación** con formularios en Flutter usando agile_front framework y GraphQL.

**Alcance:** Operación CREATE (POST)  
**Otros patrones:** READ, UPDATE, DELETE se documentan en chatmodes separados

## Principios Fundamentales

### 1. Separación de Responsabilidades
Cada archivo tiene una única responsabilidad clara:
- El archivo principal (`main.dart`) solo orquesta el diálogo y el formulario
- La lógica de negocio está en el `view_model.dart`
- Los inputs/entidades manejan los datos del formulario
- La mutation GraphQL maneja la operación de creación

### 2. Nombres Genéricos y Reutilizables
Usa nombres estándar para facilitar la clonación de módulos y mantener consistencia.

### 3. Diálogo Modal para Crear
La creación usa `ContentDialog` (modal) en lugar de página completa, con:
- Formulario validado
- Botones de acción (Cancelar/Crear)
- Loading state durante la operación
- Cierre automático al completar

## Estructura de Archivos para CREATE

```
/pages/{Feature}/create/
  ├── main.dart              # Widget principal con diálogo - 70-90 líneas
  └── view_model.dart        # Lógica de negocio con GraphQL mutation

/domain/
  /usecases/{Feature}/
    └── create_{feature}_usecase.dart      # UseCase con execute()
  /operation/
    /mutations/create{Feature}/
      └── create{feature}_mutation.dart    # Mutation GraphQL
  /extensions/
    └── {feature}_fields_builder_extension.dart  # ⚠️ Extension REQUERIDA
  /entities/
    /inputs/
      └── create{feature}_input.dart       # Input para el formulario
```

### Ejemplo Real: Módulo User/create

**Presentación:**
```
/pages/User/create/
  ├── main.dart              # UserCreatePage con ContentDialog
  └── view_model.dart        # ViewModel con create(), input
```

**Dominio:**
```
/domain/
  /usecases/User/
    └── create_user_usecase.dart           # CreateUserUsecase
  /operation/
    /mutations/createUser/
      └── createuser_mutation.dart         # CreateUserMutation
  /extensions/
    └── user_fields_builder_extension.dart # ⚠️ Extension con defaultValues()
  /entities/
    /inputs/
      └── createuser_input.dart            # CreateUserInput
```

### Clonación Rápida para Nuevos Módulos

Para crear un nuevo módulo de creación (ej: Product):

1. **⚠️ PRIMERO: Verificar/Crear FieldsBuilder Extension**
   - Buscar: `/src/domain/extensions/product_fields_builder_extension.dart`
   - Si NO existe → Crear con método `defaultValues()`
   - Incluir todos los campos que necesitas del servidor

2. **Copiar estructura de User/create** → Product/create

3. **Buscar y reemplazar:**
   - `User` → `Product`
   - `user` → `product`
   - `Usuario` → `Producto`

4. **Archivos genéricos mantienen el mismo nombre:**
   - `main.dart` (mismo nombre)
   - `view_model.dart` (mismo nombre)

5. **Ajustar campos específicos** en el Input y el formulario

## Convención de Nombres para CREATE

### Archivos Genéricos (mismo nombre en todos los módulos CREATE)
- ✅ `main.dart` - Widget principal con ContentDialog (70-90 líneas)
- ✅ `view_model.dart` - Lógica de negocio con GraphQL mutation

### Clases y Archivos del Dominio
- ✅ `Create{Feature}Usecase` - UseCase de creación
  - Ejemplos: `CreateUserUsecase`, `CreateProductUsecase`
- ✅ `Create{Feature}Mutation` - Mutation GraphQL
  - Ejemplos: `CreateUserMutation`, `CreateProductMutation`
- ✅ `Create{Feature}Input` - Input para el formulario
  - Ejemplos: `CreateUserInput`, `CreateProductInput`

### Funciones y Métodos Estándar
- ✅ `create()` - Método en ViewModel que ejecuta la creación
- ✅ `execute()` - Método en UseCase que ejecuta la mutation

## ⚠️ Análisis del Input: Identificación de Campos y Tipos

**REGLA CRÍTICA:** Antes de crear el formulario, SIEMPRE analiza el `Create{Feature}Input` completo para identificar:

### 1. Todos los Campos Disponibles
- Lee el Input completo (`/domain/entities/types/{feature}/inputs/create{feature}input_input.dart`)
- Identifica TODOS los campos (no solo los básicos)
- Verifica si son required u optional

### 2. Identificación de Tipos Especiales

#### **Enums → DropdownButtonFormField**
**Cómo identificar:**
- El tipo del campo es un Enum (ej: `Role`, `Status`, `Type`)
- Busca la definición en `/domain/entities/enums/{enum}_enum.dart`

**Implementación:**
```dart
// 1. Variable de estado para el valor seleccionado
Status? selectedStatus;

// 2. Función helper para obtener labels i18n
String getStatusLabel(BuildContext context, Status status) {
  final l10n = AppLocalizations.of(context)!;
  switch (status) {
    case Status.active:
      return l10n.statusActive;
    case Status.inactive:
      return l10n.statusInactive;
  }
}

// 3. En el formulario
DropdownButtonFormField<Status>(
  value: selectedStatus,
  decoration: InputDecoration(
    labelText: l10n.status,
    isDense: true,
    border: const OutlineInputBorder(),
  ),
  items: Status.values.map((Status status) {
    return DropdownMenuItem<Status>(
      value: status,
      child: Text(getStatusLabel(context, status)),
    );
  }).toList(),
  onChanged: (Status? newValue) {
    setState(() {
      selectedStatus = newValue;
      viewModel.input.status = newValue;
    });
  },
)
```

**i18n para Enums:**
```json
{
  "status": "Estado",
  "statusActive": "Activo",
  "statusInactive": "Inactivo"
}
```

#### **IDs (String terminado en "ID") → Generalmente Select/Autocomplete**
**Cómo identificar:**
- Campo tipo `String?` o `String` con nombre terminado en "ID" (ej: `laboratoryID`, `companyID`)
- Requiere cargar opciones de otra entidad

**Nota:** Por ahora, si encuentras un ID, documenta que necesita un selector pero puede dejarse como TextField temporalmente.

#### **Booleanos → Switch o Checkbox**
**Cómo identificar:**
- Campo tipo `bool` o `bool?`

**Implementación:**
```dart
SwitchListTile(
  title: Text(l10n.isActive),
  value: viewModel.input.isActive ?? false,
  onChanged: (bool value) {
    viewModel.input.isActive = value;
  },
)
```

#### **Fechas (DateTime o String con "date") → DatePicker**
**Cómo identificar:**
- Campo tipo `DateTime` o `String` con nombre que contiene "date" o "Date"

**Implementación:**
```dart
CustomTextFormField(
  labelText: l10n.cutOffDate,
  controller: cutOffDateController,
  readOnly: true,
  onTap: () async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      cutOffDateController.text = date.toString().split(' ')[0];
      viewModel.input.cutOffDate = date.toString();
    }
  },
)
```

#### **Números (num, int, double) → TextField con validación numérica**
**Cómo identificar:**
- Campo tipo `num`, `num?`, `int`, `int?`, `double`, `double?`

**Implementación:**
```dart
CustomTextFormField(
  labelText: l10n.fee,
  controller: feeController,
  onChange: (value) {
    viewModel.input.fee = num.tryParse(value);
  },
)
```

### 3. Orden de Implementación de Campos

1. **Analizar Input completo** - Identificar todos los campos
2. **Categorizar tipos** - Enum, ID, Boolean, Date, Number, String
3. **Crear keys i18n** - Para cada campo y valores de enums
4. **Crear controllers** - Solo para TextFields
5. **Crear variables de estado** - Para Enums y otros selects
6. **Crear helper functions** - Para labels de enums
7. **Implementar formulario** - En orden lógico (no alfabético)
8. **Dispose controllers** - Limpiar memoria

### 4. Checklist de Análisis del Input

- [ ] Leí el archivo `Create{Feature}Input` completo
- [ ] Identifiqué todos los campos (no solo firstName/lastName/email)
- [ ] Categoricé cada campo por tipo (Enum/ID/Boolean/Date/Number/String)
- [ ] Para cada Enum: creé las keys i18n para todos los valores
- [ ] Para cada campo: creé la key i18n del label
- [ ] Creé controllers solo para TextFields
- [ ] Creé variables de estado para Enums
- [ ] Implementé helper functions para labels de Enums
- [ ] Ordené campos lógicamente en el formulario
- [ ] Agregué dispose() para todos los controllers

## Implementación Detallada

### 1. Archivo Principal (main.dart)

**Características:**
- 70-90 líneas típicamente
- Usa `ContentDialog` para modal
- Incluye `Form` con `GlobalKey<FormState>`
- Controllers para cada campo (`TextEditingController`)
- Usa `ListenableBuilder` para reactivity
- Validación antes de enviar
- Loading state en botón de guardar
- Cierre con resultado (`context.pop(true)`)

**Template:**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';

class {Feature}CreatePage extends StatefulWidget {
  const {Feature}CreatePage({super.key});

  @override
  State<{Feature}CreatePage> createState() => _{Feature}CreatePageState();
}

class _{Feature}CreatePageState extends State<{Feature}CreatePage> {
  late ViewModel viewModel;
  
  // Controllers para cada campo del formulario
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    // Limpiar controllers
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.person_add,
          title: l10n.createThing(l10n.{feature}),
          loading: viewModel.loading,
          form: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  labelText: l10n.name,
                  controller: nameController,
                  isDense: true,
                  fieldLength: FormFieldLength.name,
                  counterText: "",
                  onChange: (value) {
                    viewModel.input.name = value;
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
                // ... más campos según necesidad
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
                        context.pop(true); // Retorna true para indicar éxito
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.createThing(l10n.{feature})),
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
```

**Ejemplo Real (UserCreatePage):**

**Nota:** Este ejemplo incluye:
- ✅ Todos los campos del CreateUserInput (firstName, lastName, email, role, cutOffDate, fee)
- ✅ Enum `Role` implementado como DropdownButtonFormField
- ✅ Helper function `getRoleLabel()` para i18n del enum
- ✅ Variable de estado `selectedRole` para el dropdown
- ✅ Campos numéricos (cutOffDate, fee) con parsing
- ✅ SingleChildScrollView para formularios largos

```dart
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
                    items: Role.values.map((Role role) {
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
```

**Notas Importantes:**
1. **Form con GlobalKey** - Necesario para validación
2. **Controllers** - Uno por cada campo del formulario
3. **dispose()** - Limpia los controllers para evitar memory leaks
4. **Loading state** - Deshabilita botón durante operación
5. **context.mounted** - Verifica que el widget aún existe antes de pop
6. **context.pop(true)** - Retorna true para que el padre sepa que hubo éxito
7. **onChange vs onChanged** - Usa onChange de CustomTextFormField para actualizar input

### 2. ViewModel (view_model.dart)

**Características:**
- Extiende `ChangeNotifier` para reactivity
- Maneja estado: loading
- Tiene instancia del Input (datos del formulario)
- Inicializa GqlConn y UseCase
- Método `create()` que retorna `bool` (true = error, false = éxito)
- Llama `notifyListeners()` en cada cambio de estado

**Template:**
```dart
import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/create{Feature}/create{feature}_mutation.dart';
import 'package:labs/src/domain/usecases/{Feature}/create_{feature}_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;
  
  // Input con valores iniciales
  final Create{Feature}Input input = Create{Feature}Input(
    name: '',
    email: '',
  );

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
  }

  Future<bool> create() async {
    bool isError = true;
    loading = true;

    Create{Feature}Usecase useCase = Create{Feature}Usecase(
      operation: Create{Feature}Mutation(
        builder: {Feature}FieldsBuilder()
      ),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute(input: input);
      
      if (response is {Feature}) {
        isError = false;
      } else {
        // Manejar error
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      loading = false;
    }

    return isError;
  }
}
```

**Ejemplo Real (CreateUserViewModel):**
```dart
import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/createUser/createuser_mutation.dart';
import 'package:labs/src/domain/usecases/User/create_user_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;
  
  final CreateUserInput input = CreateUserInput(
    firstName: '',
    lastName: '',
    email: '',
  );

  bool get loading => _loading;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
  }

  Future<bool> create() async {
    bool isError = true;
    loading = true;

    CreateUserUsecase useCase = CreateUserUsecase(
      operation: CreateUserMutation(
        builder: UserFieldsBuilder()
      ),
      conn: _gqlConn,
    );

    try {
      var response = await useCase.execute(input: input);
      
      if (response is User) {
        isError = false;
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
    } finally {
      loading = false;
    }

    return isError;
  }
}
```

**Notas Importantes:**
1. **Input como field** - Accesible desde el main.dart
2. **create() retorna bool** - true = error, false = éxito
3. **UseCase se crea en el método** - No se guarda como field
4. **Type checking** - Verifica `response is {Feature}`
5. **try-catch-finally** - finally siempre apaga loading
6. **No necesita _init()** - No hay carga inicial de datos

### 3. GraphQL Mutation (Capa de Dominio)

**Ubicación:**
```
/domain/operation/
  /mutations/
    /create{Feature}/
      └── create{feature}_mutation.dart      # Mutation GraphQL
```

**Template:**
```dart
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/entities/main.dart';
import 'package:agile_front/infraestructure/operation.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';

class Create{Feature}Mutation implements Operation {
  final {Feature}FieldsBuilder builder;
  final String _name = 'create{Feature}';
  Map<String, String>? declarativeArgs;
  final String? alias;
  Map<String, dynamic>? opArgs;
  List<Directive>? directives;

  @override
  get name => _name;

  Create{Feature}Mutation({
    required this.builder,
    this.declarativeArgs,
    this.alias,
    this.opArgs,
    this.directives,
  });

  @override
  String build({
    String? alias,
    Map<String, String>? declarativeArgs,
    Map<String, dynamic>? args,
    List<Directive>? directives,
  }) {
    final fields = builder.build();
    
    final variableDecl = declarativeArgs ?? this.declarativeArgs ?? {};
    final variablesStr = variableDecl.isNotEmpty
        ? '(\${variableDecl.entries.map((e) => '\$\${e.key}:\${e.value}').join(',')})'
        : '';

    final body = formatField(
      _name,
      alias: alias ?? this.alias,
      args: args ?? opArgs,
      directives: directives ?? this.directives,
      selection: fields,
    );

    return '''
      mutation $_name$variablesStr {
        $body
      }
    ''';
  }

  @override
  {Feature} result(Map<String, dynamic> data) {
    String name = alias ?? _name;
    return {Feature}.fromJson(data[name]);
  }
}
```

**Ejemplo Real (CreateUserMutation):**
```dart
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/entities/main.dart';
import 'package:agile_front/infraestructure/operation.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';

class CreateUserMutation implements Operation {
  final UserFieldsBuilder builder;
  final String _name = 'createUser';
  Map<String, String>? declarativeArgs;
  final String? alias;
  Map<String, dynamic>? opArgs;
  List<Directive>? directives;

  @override
  get name => _name;

  CreateUserMutation({
    required this.builder,
    this.declarativeArgs,
    this.alias,
    this.opArgs,
    this.directives,
  });

  @override
  String build({
    String? alias,
    Map<String, String>? declarativeArgs,
    Map<String, dynamic>? args,
    List<Directive>? directives,
  }) {
    final fields = builder.build();
    
    final variableDecl = declarativeArgs ?? this.declarativeArgs ?? {};
    final variablesStr = variableDecl.isNotEmpty
        ? '(\${variableDecl.entries.map((e) => '\$\${e.key}:\${e.value}').join(',')})'
        : '';

    final body = formatField(
      _name,
      alias: alias ?? this.alias,
      args: args ?? opArgs,
      directives: directives ?? this.directives,
      selection: fields,
    );

    return '''
      mutation $_name$variablesStr {
        $body
      }
    ''';
  }

  @override
  User result(Map<String, dynamic> data) {
    String name = alias ?? _name;
    return User.fromJson(data[name]);
  }
}
```

### 4. UseCase (Capa de Dominio)

**Ubicación:**
```
/domain/usecases/{Feature}/
  └── create_{feature}_usecase.dart
```

**Características:**
- NO modifica la operation recibida en constructor
- Crea una NUEVA mutation dentro del método `execute()`
- Usa `{Feature}FieldsBuilder().defaultValues()` para configurar campos
- Usa `GqlVar("name")` para referenciar la variable GraphQL
- El nombre de la variable ("name") debe coincidir en `declarativeArgs` y `variables`

**Template:**
```dart
import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/extensions/{feature}_fields_builder_extension.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/create{Feature}/create{feature}_mutation.dart';

class Create{Feature}Usecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;

  Create{Feature}Usecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic> build() async {
    _conn.operation(operation: _operation, callback: callback);
  }

  callback(Object ob) {
    // final thisObject = ob as {Feature};
  }

  Future<dynamic> execute({required Create{Feature}Input input}) async {
    {Feature}FieldsBuilder fieldsBuilder = {Feature}FieldsBuilder().defaultValues();
    
    Create{Feature}Mutation mutation = Create{Feature}Mutation(
      declarativeArgs: {
        "name": 'Create{Feature}Input!',
      },
      builder: fieldsBuilder,
      opArgs: {
        "input": GqlVar("name")
      }
    );
    
    var response = await _conn.operation(
      operation: mutation,
      variables: {'name': input},
    );
    
    return response;
  }
}
```

**Ejemplo Real (CreateUserUsecase):**
```dart
import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/extensions/user_fields_builder_extension.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createUser/createuser_mutation.dart';

class CreateUserUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;

  CreateUserUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic> build() async {
    _conn.operation(operation: _operation, callback: callback);
  }

  callback(Object ob) {
    // final thisObject = ob as User;
  }

  Future<dynamic> execute({required CreateUserInput input}) async {
    UserFieldsBuilder fieldsBuilder = UserFieldsBuilder().defaultValues();
    
    CreateUserMutation mutation = CreateUserMutation(
      declarativeArgs: {
        "name": 'CreateUserInput!',
      },
      builder: fieldsBuilder,
      opArgs: {
        "input": GqlVar("name")
      }
    );
    
    var response = await _conn.operation(
      operation: mutation,
      variables: {'name': input},
    );
    
    return response;
  }
}
```

**Ejemplo Real 2 (CreateDestinationOfficeUsecase):**
```dart
import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/extensions/destinationoffice_fields_builder_extension.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createDestinationOffice/createdestinationoffice_mutation.dart';

class CreateDestinationOfficeUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;

  CreateDestinationOfficeUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic> build() async {
    _conn.operation(operation: _operation, callback: callback);
  }

  callback(Object ob) {
    // final thisObject = ob as DestinationOffice;
  }

  Future<dynamic> execute({required CreateDestinationOfficeInput input}) async {
    DestinationOfficeFieldsBuilder fieldsBuilder = 
        DestinationOfficeFieldsBuilder().defaultValues();
    
    CreateDestinationOfficeMutation mutation = CreateDestinationOfficeMutation(
      declarativeArgs: {
        "name": 'CreateDestinationOfficeInput!',
      },
      builder: fieldsBuilder,
      opArgs: {
        "input": GqlVar("name")
      }
    );
    
    var response = await _conn.operation(
      operation: mutation,
      variables: {'name': input},
    );
    
    return response;
  }
}
```

**Notas Importantes:**
1. **Nueva mutation en execute()** - NO reutiliza la del constructor
2. **fieldsBuilder.defaultValues()** - Extension para configurar campos por defecto
3. **declarativeArgs** - Define variable GraphQL (ej: `"name": 'CreateUserInput!'`)
4. **GqlVar("name")** - Referencia a la variable en opArgs
5. **variables** - Diccionario con `{'name': input}` (input sin serializar)
6. **Nombre consistente** - "name" en declarativeArgs, opArgs y variables
7. **Input directo** - Se pasa el input object, NO `input.toJson()`
8. **callback()** - Opcional para procesar respuesta

### 5. FieldsBuilder Extension (Capa de Dominio) ⚠️ IMPORTANTE

**Ubicación:**
```
/domain/extensions/
  └── {feature}_fields_builder_extension.dart
```

**¿Por qué es necesario?**
Esta extension es **REQUERIDA** para el UseCase. Define qué campos se deben solicitar en la mutation GraphQL. Si no existe, DEBES crearla antes de implementar el UseCase.

**Características:**
- Extension sobre `{Feature}FieldsBuilder`
- Método `defaultValues()` que retorna el mismo builder configurado
- Lista TODOS los campos que la mutation debe retornar
- Se usa en `execute()`: `{Feature}FieldsBuilder().defaultValues()`

**Template:**
```dart
import '/src/domain/operation/fields_builders/main.dart';

extension {Feature}FieldsBuilderExtension on {Feature}FieldsBuilder {
  {Feature}FieldsBuilder defaultValues() {
    return this
      ..id()
      ..field1()
      ..field2()
      ..field3();
      // ... todos los campos necesarios
  }
}
```

**Ejemplo Real (UserFieldsBuilderExtension):**
```dart
import '/src/domain/operation/fields_builders/main.dart';

extension UserFieldsBuilderExtension on UserFieldsBuilder {
  UserFieldsBuilder defaultValues() {
    return this
      ..id()
      ..firstName()
      ..lastName()
      ..role()
      ..email()
      ..cutOffDate()
      ..fee();
  }
}
```

**Notas Importantes:**
1. **Archivo debe crearse** - No es auto-generado
2. **Ubicación exacta** - `/src/domain/extensions/{feature}_fields_builder_extension.dart`
3. **Nombre de extension** - `{Feature}FieldsBuilderExtension`
4. **Nombre de método** - `defaultValues()` (estándar en el proyecto)
5. **Return this** - Permite method chaining
6. **Todos los campos** - Incluye TODOS los campos que quieres recibir del servidor
7. **Importar en UseCase** - `import '/src/domain/extensions/{feature}_fields_builder_extension.dart';`

**¿Cómo verificar si existe?**
Busca el archivo: `/src/domain/extensions/{feature}_fields_builder_extension.dart`
- Si NO existe → **Créalo primero antes del UseCase**
- Si existe → Verifica que tenga el método `defaultValues()`

**Orden de Implementación:**
1. ✅ Crear Input
2. ✅ Crear Mutation
3. ⚠️ **Crear FieldsBuilder Extension** ← NO OLVIDAR
4. ✅ Crear UseCase (usa la extension)
5. ✅ Crear ViewModel
6. ✅ Crear UI

### 6. Input Entity (Capa de Dominio)

**Ubicación:**
```
/domain/entities/
  /inputs/
    └── create{feature}_input.dart
```

**Template:**
```dart
import 'package:json_annotation/json_annotation.dart';

part 'create{feature}_input.g.dart';

@JsonSerializable()
class Create{Feature}Input {
  String name;
  String email;
  // ... más campos según necesidad

  Create{Feature}Input({
    required this.name,
    required this.email,
  });

  factory Create{Feature}Input.fromJson(Map<String, dynamic> json) =>
      _$Create{Feature}InputFromJson(json);

  Map<String, dynamic> toJson() => _$Create{Feature}InputToJson(this);
}
```

**Ejemplo Real (CreateUserInput):**
```dart
import 'package:json_annotation/json_annotation.dart';

part 'createuser_input.g.dart';

@JsonSerializable()
class CreateUserInput {
  String firstName;
  String lastName;
  String email;

  CreateUserInput({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory CreateUserInput.fromJson(Map<String, dynamic> json) =>
      _$CreateUserInputFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserInputToJson(this);
}
```

**Notas Importantes:**
1. **@JsonSerializable** - Necesario para generar toJson()
2. **part** - Referencia al archivo generado `.g.dart`
3. **Campos no-final** - Deben ser mutables para el formulario
4. **Valores requeridos** - Inicializados en el ViewModel

## Internacionalización (i18n)

### Keys Necesarias para CREATE

**IMPORTANTE:** Crear keys i18n para TODOS los campos del Input y TODOS los valores de enums.

#### Keys Básicas del Módulo
```json
{
  "createThing": "Crear {thing}",
  "newThing": "Nuevo {thing}",
  "save": "Guardar",
  "cancel": "Cancelar"
}
```

#### Keys de Campos (una por cada campo del Input)
```json
{
  "firstName": "Nombre",
  "lastName": "Apellido",
  "email": "Correo electrónico",
  "role": "Rol",
  "cutOffDate": "Fecha de corte",
  "fee": "Tarifa"
}
```

#### Keys de Enums (una por cada valor del enum)
Para cada enum, crear:
1. Key del campo: `"role": "Rol"`
2. Key por cada valor: `"role{Value}": "Etiqueta"`

**Ejemplo con enum Role:**
```json
{
  "role": "Rol",
  "roleRoot": "Root",
  "roleAdmin": "Administrador",
  "roleOwner": "Propietario",
  "roleTechnician": "Técnico",
  "roleBilling": "Facturación"
}
```

**Patrón de nomenclatura para enums:**
- Campo: `{fieldName}` (ej: `role`, `status`)
- Valores: `{fieldName}{ValuePascalCase}` (ej: `roleAdmin`, `statusActive`)

## Flujo Completo CREATE

```
1. Usuario hace clic en botón "Nuevo {Feature}"
   ↓
2. Se abre ContentDialog con formulario
   ↓
3. Usuario llena campos → onChange actualiza viewModel.input
   ↓
4. Usuario hace clic en "Crear {Feature}"
   ↓
5. Se valida formulario con formKey.currentState!.validate()
   ↓
6. ViewModel.create() inicia:
   - loading = true
   - Crea UseCase con Mutation y FieldsBuilder
   - Ejecuta useCase.execute(input: input)
   ↓
7. UseCase prepara mutation:
   - Agrega declarativeArgs
   - Serializa input a JSON con toJson()
   - Ejecuta operación GraphQL
   ↓
8. Mutation.build() genera string GraphQL
   ↓
9. GqlConn envía mutation al servidor
   ↓
10. Mutation.result() transforma JSON → {Feature}
   ↓
11. ViewModel verifica respuesta:
    - Si response is {Feature} → isError = false
    - Si no → isError = true
   ↓
12. loading = false, notifyListeners()
   ↓
13. Si !isError → context.pop(true)
   ↓
14. Padre (READ) detecta pop(true) y refresca lista
```

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

### Internacionalización
**❌ NUNCA hardcodear textos:**
```dart
// MAL ❌
Text("Crear Usuario")

// BIEN ✅
Text(l10n.createThing(l10n.user))
```

### Context Management
- Context se pasa como parámetro, nunca se almacena en variables de instancia
- Verificar `context.mounted` antes de usar `context.pop()` en callbacks async

## Checklist de Verificación - Módulo CREATE

### Presentación (/pages/{Feature}/create/)
- [ ] `main.dart` tiene 70-90 líneas
- [ ] Usa `ContentDialog` con icon, title, loading, form, actions
- [ ] Tiene `GlobalKey<FormState>` para validación
- [ ] Controllers para cada campo con dispose()
- [ ] `ListenableBuilder` para reactivity
- [ ] Obtiene `l10n` con `AppLocalizations.of(context)!`
- [ ] Usa `l10n.createThing(l10n.{feature})` en título y botón
- [ ] Usa `l10n` para labels de campos
- [ ] `onChange` actualiza `viewModel.input.{field}`
- [ ] Botón "Cancelar" hace `context.pop()` sin argumentos
- [ ] Botón "Crear" valida antes de llamar `viewModel.create()`
- [ ] Botón "Crear" muestra `CircularProgressIndicator` cuando loading
- [ ] Botón "Crear" deshabilitado cuando loading
- [ ] Verifica `context.mounted` antes de `context.pop(true)`
- [ ] Retorna `true` en `context.pop()` para indicar éxito
- [ ] Sin strings hardcodeados

### ViewModel
- [ ] Extiende `ChangeNotifier`
- [ ] Estado `_loading` con getter y setter
- [ ] Setter de `loading` llama `notifyListeners()`
- [ ] Field `input` del tipo `Create{Feature}Input` con valores iniciales
- [ ] Inicializa `GqlConn` en constructor
- [ ] Método `create()` retorna `Future<bool>`
- [ ] `create()` crea UseCase con Mutation y FieldsBuilder
- [ ] `create()` llama `useCase.execute(input: input)`
- [ ] Type checking: `response is {Feature}`
- [ ] Error handling con try-catch
- [ ] finally apaga loading siempre
- [ ] Retorna `false` si éxito, `true` si error

### Dominio
- [ ] **⚠️ `{Feature}FieldsBuilderExtension` creada PRIMERO** (archivo en `/extensions/`)
- [ ] Extension tiene método `defaultValues()` con todos los campos
- [ ] Extension importada en el UseCase
- [ ] `Create{Feature}Mutation` implementada
- [ ] `Create{Feature}Usecase` con método `execute()`
- [ ] UseCase usa `{Feature}FieldsBuilder().defaultValues()` en execute()
- [ ] UseCase crea nueva mutation dentro de execute() (NO modifica la del constructor)
- [ ] UseCase usa `GqlVar("name")` en opArgs
- [ ] UseCase pasa input directo en variables (NO serializado)
- [ ] `Create{Feature}Input` con `@JsonSerializable`
- [ ] Input tiene `toJson()` y `fromJson()`
- [ ] Mutation retorna entidad {Feature}

### Internacionalización
- [ ] Todas las keys necesarias en `app_es.arb` y `app_en.arb`
- [ ] Usa `l10n` para TODOS los textos visibles
- [ ] Sin strings hardcodeados

### General
- [ ] Context se pasa como parámetro, nunca se almacena
- [ ] Controllers se limpian en dispose()
- [ ] 🐛 Usar `debugPrint` en lugar de `print` para debugging
- [ ] ✅ Import `package:flutter/foundation.dart` en archivos de dominio que usen debugPrint
- [ ] Sin errores de compilación
- [ ] Mutation y UseCase en carpetas correctas

## Ventajas del Patrón CREATE

1. **Modal vs Página Completa** - Más rápido y mejor UX
2. **Validación Integrada** - Form con GlobalKey
3. **Loading State** - Feedback visual claro
4. **Error Handling** - Retorno bool simple
5. **Cierre Automático** - context.pop(true) al éxito
6. **Refresh Automático** - Padre refresca al detectar true
7. **Reutilizable** - ContentDialog puede usarse en varios contextos

## Próximos Chatmodes

- ✅ `read_pattern.chatmode.md` - Patrón para READ (listado)
- ✅ `create_pattern.chatmode.md` - Patrón para CREATE (formularios) ← ESTE
- 🔜 `update_pattern.chatmode.md` - Patrón para UPDATE (edición)
- 🔜 `delete_pattern.chatmode.md` - Patrón para DELETE (confirmación)
