# Patrón de Arquitectura Modular Flutter - READ (Listado con Búsqueda y Paginación)

Este chatmode documenta el patrón completo para implementar módulos de **lectura/listado** con búsqueda y paginación en Flutter usando agile_front framework y GraphQL.

**Alcance:** Operación READ (GET list)  
**Otros patrones:** CREATE, UPDATE, DELETE se documentarán en chatmodes separados

## Principios Fundamentales

### 1. Separación de Responsabilidades
Cada archivo tiene una única responsabilidad clara:
- El archivo principal (`main.dart`) solo orquesta componentes
- La lógica de negocio está en el `view_model.dart`
- La configuración UI está en archivos separados
- Los builders manejan la construcción de UI compleja

### 2. Nombres Genéricos y Reutilizables
Usa nombres estándar para facilitar la clonación de módulos y mantener consistencia.

### 3. Convención Builder de Flutter
Las funciones que construyen widgets usan el prefijo `build`, siguiendo la convención de Flutter:
- `WidgetBuilder` - Flutter: `typedef WidgetBuilder = Widget Function(BuildContext context)`
- `IndexedWidgetBuilder` - Flutter: construye widget basado en índice
- `buildList()` - Nuestro patrón: construye lista de widgets
- `buildForm()` - Nuestro patrón: construye formulario
- `buildItem()` - Nuestro patrón: construye item individual

Este patrón hace que el código sea familiar para cualquier desarrollador Flutter.

## Estructura de Archivos para READ

```
/pages/{Feature}/read/
  ├── main.dart              # Widget principal (orquestador) - 30-40 líneas
  ├── view_model.dart        # Lógica de negocio y estado con GraphQL
  ├── search_config.dart     # Configuración del SearchTemplate
  ├── list_builder.dart      # Constructor de lista con 4 estados
  └── {item}_item.dart       # Widget individual del item

/domain/
  /usecases/{Feature}/
    └── read_{feature}_usecase.dart      # UseCase con search y paginación
  /extensions/
    └── edge{feature}_fields_builder_extension.dart  # Extension con defaultValues()
  /operation/
    /queries/get{Feature}s/
      └── get{feature}s_query.dart       # Query GraphQL
```

### Ejemplo Real: Módulo User/read

**Presentación:**
```
/pages/User/read/
  ├── main.dart              # UserPage - 30 líneas
  ├── view_model.dart        # ViewModel con getUsers(), search(), updatePageInfo()
  ├── search_config.dart     # getSearchConfig() → SearchTemplateConfig
  ├── list_builder.dart      # buildList() con 4 estados (loading, error, empty, success)
  └── user_item.dart         # UserItem widget (Card con PopupMenu)
```

**Dominio:**
```
/domain/
  /usecases/User/
    └── read_user_usecase.dart           # ReadUserUsecase
  /extensions/
    └── edgeuser_fields_builder_extension.dart  # defaultValues() para EdgeUser
  /operation/
    /queries/getUsers/
      └── getusers_query.dart            # GetUsersQuery
    /fields_builders/
      ├── edgeuser_fields_builder.dart   # (Generado automáticamente)
      ├── user_fields_builder.dart       # (Generado automáticamente)
      └── pageinfo_fields_builder.dart   # (Generado automáticamente)
```

### Clonación Rápida para Nuevos Módulos

Para crear un nuevo módulo de lectura (ej: Product):

1. **Copiar estructura de User/read** → Product/read
2. **Buscar y reemplazar:**
   - `User` → `Product`
   - `user` → `product`
   - `Usuario` → `Producto`
3. **Archivos genéricos mantienen el mismo nombre:**
   - `search_config.dart` (mismo nombre)
   - `list_builder.dart` (mismo nombre)
   - `view_model.dart` (mismo nombre)
   - Solo cambiar: `user_item.dart` → `product_item.dart`
4. **Ajustar campos específicos** en FieldsBuilder y widget del item

## Convención de Nombres para READ

### Archivos Genéricos (mismo nombre en todos los módulos READ)
- ✅ `main.dart` - Widget principal (30-40 líneas)
- ✅ `view_model.dart` - Lógica de negocio con GraphQL
- ✅ `search_config.dart` - Configuración del SearchTemplate
- ✅ `list_builder.dart` - Constructor de lista con 4 estados

### Archivos Específicos (cambiar según feature)
- ✅ `{item}_item.dart` - Widget del item
  - Ejemplos: `user_item.dart`, `product_item.dart`, `company_item.dart`
  - Puede ser Card, ListTile, Container, o cualquier composición de widgets

### Funciones Estándar (siguiendo convención Builder de Flutter)
- ✅ `getSearchConfig()` - Retorna `SearchTemplateConfig`
- ✅ `buildList()` - Retorna `List<Widget>` para listas
- ✅ Constructor del widget item - Ej: `UserItem()`, `ProductItem()`

### Clases y Archivos del Dominio
- ✅ `Read{Feature}Usecase` - UseCase de lectura
  - Ejemplos: `ReadUserUsecase`, `ReadProductUsecase`
- ✅ `Get{Feature}sQuery` - Query GraphQL (plural)
  - Ejemplos: `GetUsersQuery`, `GetProductsQuery`
- ✅ `Edge{Feature}FieldsBuilderExtension` - Extension con defaultValues()
  - Ejemplos: `EdgeUserFieldsBuilderExtension`, `EdgeProductFieldsBuilderExtension`

**Nota:** El prefijo `build` sigue la convención de Flutter (`WidgetBuilder`, `IndexedWidgetBuilder`).

## Implementación Detallada

### 1. Archivo Principal (main.dart)

**Características:**
- Máximo 30-40 líneas
- Solo estructura del widget
- Delega toda lógica a otros archivos
- Usa `ListenableBuilder` para reactivity

**Template:**
```dart
import 'package:flutter/material.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';
import './search_config.dart';
import './list_builder.dart';

class FeaturePage extends StatefulWidget {
  const FeaturePage({super.key});

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  late ViewModel viewModel;

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
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return SearchTemplate(
          config: getSearchConfig(context: context, viewModel: viewModel),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: buildList(context: context, viewModel: viewModel),
          ),
        );
      },
    );
  }
}
```

### 2. ViewModel (view_model.dart)

**Características:**
- Extiende `ChangeNotifier` para reactivity
- Maneja estados: loading, error, lista de resultados, pageInfo
- Inicializa Query, UseCase y GqlConn en constructor
- Implementa métodos: getUsers(), search(), updatePageInfo()
- Llama `notifyListeners()` en cada cambio de estado

**Ejemplo Real Completo (ReadUserUsecase):**
```dart
import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getUsers/getusers_query.dart';
import '/src/domain/extensions/edgeuser_fields_builder_extension.dart';
import '/src/domain/usecases/User/read_user_usecase.dart';
import '/src/domain/entities/inputs/searchinput_input.dart';
import '/src/domain/entities/types/pageinfo/pageinfo_model.dart';

class ViewModel extends ChangeNotifier {
  // Estados privados
  bool _loading = false;
  bool _error = false;
  List<User>? _userList;
  PageInfo? _pageInfo;

  // Dependencias
  late GqlConn _gqlConn;
  late ReadUserUsecase _readUseCase;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetUsersQuery _operation = GetUsersQuery(
    builder: EdgeUserFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<User>? get userList => _userList;
  PageInfo? get pageInfo => _pageInfo;

  // Setters con notificación
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set userList(List<User>? value) {
    _userList = value;
    notifyListeners();
  }

  set pageInfo(PageInfo? value) {
    _pageInfo = value;
    notifyListeners();
  }

  // Constructor - Inicializa dependencias
  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _readUseCase = ReadUserUsecase(operation: _operation, conn: _gqlConn);
    _init();
  }

  // Inicialización - Carga datos al crear el ViewModel
  Future<void> _init() async {
    await getUsers();
  }

  // Obtener todos los usuarios (sin filtros)
  Future<void> getUsers() async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.build();

      if (response is EdgeUser) {
        userList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e) {
      error = true;
      userList = [];
    } finally {
      loading = false;
    }
  }

  // Buscar usuarios con filtros
  Future<void> search(List<SearchInput> searchInputs) async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.search(searchInputs, _pageInfo);

      if (response is EdgeUser) {
        userList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e) {
      error = true;
      userList = [];
    } finally {
      loading = false;
    }
  }

  // Cambiar de página
  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]); // Recargar con la nueva página
  }
}
```

**Notas Importantes:**
1. **Query se crea una vez** - Como field final con defaultValues()
2. **UseCase se inicializa en constructor** - Recibe query y gqlConn
3. **_init() carga datos** - Se llama automáticamente en constructor
4. **getUsers() vs search()** - getUsers sin filtros, search con filtros
5. **Type checking** - Verifica `response is EdgeUser` antes de asignar
6. **Error handling** - try-catch con estado de error y lista vacía
7. **finally** - Siempre apaga loading, incluso si hay error

### 3. GraphQL Queries y FieldsBuilders (Capa de Dominio)

Esta capa maneja la construcción de queries GraphQL de forma programática y type-safe.

**Ubicación:**
```
/domain/operation/
  /queries/
    /get{Feature}s/
      └── get{feature}s_query.dart      # Query GraphQL
  /fields_builders/
    ├── edge{feature}_fields_builder.dart  # Builder para Edge (lista paginada)
    ├── {feature}_fields_builder.dart      # Builder para entidad individual
    └── main.dart                          # Barrel file
```

#### 3.1. Query GraphQL

**Características:**
- Implementa `Operation` de agile_front
- Recibe `FieldsBuilder` en constructor para definir campos a consultar
- Construye la query GraphQL completa con variables y directivas
- Transforma la respuesta JSON a entidad Dart

**Estructura de una Query:**
```dart
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/entities/main.dart';
import 'package:agile_front/infraestructure/operation.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';

class Get{Feature}sQuery implements Operation {
  final Edge{Feature}FieldsBuilder builder;
  final String _name = 'get{Feature}s';
  Map<String,String>? declarativeArgs;
  final String? alias;
  Map<String, dynamic>? opArgs;
  List<Directive>? directives;

  @override
  get name => _name;
  
  Get{Feature}sQuery({
    required this.builder, 
    this.declarativeArgs, 
    this.alias, 
    this.opArgs, 
    this.directives
  });
  
  @override
  String build({
    String? alias, 
    Map<String, String>? declarativeArgs, 
    Map<String, dynamic>? args, 
    List<Directive>? directives
  }) {
    final fields = builder.build();
    
    // Construir declaración de variables GraphQL
    final variableDecl = declarativeArgs ?? this.declarativeArgs ?? {};
    final variablesStr = variableDecl.isNotEmpty 
      ? '(${variableDecl.entries.map((e) => '\$${e.key}:${e.value}').join(',')})' 
      : ''; 
    
    final body = formatField(
      _name,
      alias: alias ?? this.alias,
      args: args ?? opArgs,
      directives: directives ?? this.directives,
      selection: fields,
    );
    
    return '''
      query $_name$variablesStr {
        $body
      }
    ''';
  }
  
  @override
  Edge{Feature} result(Map<String, dynamic> data) {
    String name = alias ?? _name;
    return Edge{Feature}.fromJson(data[name]);
  }
}
```

**Ejemplo Real (GetUsersQuery):**
```dart
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/entities/main.dart';
import 'package:agile_front/infraestructure/operation.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';

class GetUsersQuery implements Operation {
  final EdgeUserFieldsBuilder builder;
  final String _name = 'getUsers';
  Map<String,String>? declarativeArgs;
  final String? alias;
  Map<String, dynamic>? opArgs;
  List<Directive>? directives;

  @override
  get name => _name;
  
  GetUsersQuery({
    required this.builder, 
    this.declarativeArgs, 
    this.alias, 
    this.opArgs, 
    this.directives
  });
  
  @override
  String build({
    String? alias, 
    Map<String, String>? declarativeArgs, 
    Map<String, dynamic>? args, 
    List<Directive>? directives
  }) {
    final fields = builder.build();
    final variableDecl = declarativeArgs ?? this.declarativeArgs ?? {};
    final variablesStr = variableDecl.isNotEmpty 
      ? '(${variableDecl.entries.map((e) => '\$${e.key}:${e.value}').join(',')})' 
      : ''; 
    
    final body = formatField(
      _name,
      alias: alias ?? this.alias,
      args: args ?? opArgs,
      directives: directives ?? this.directives,
      selection: fields,
    );
    
    return '''
      query $_name$variablesStr {
        $body
      }
    ''';
  }
  
  @override
  EdgeUser result(Map<String, dynamic> data) {
    String name = alias ?? _name;
    return EdgeUser.fromJson(data[name]);
  }
}
```

#### 3.2. FieldsBuilder (Generado Automáticamente)

Los FieldsBuilders son clases generadas que construyen la selección de campos GraphQL de forma type-safe.

**Tipos de FieldsBuilder:**

1. **Edge{Feature}FieldsBuilder** - Para consultas paginadas
2. **{Feature}FieldsBuilder** - Para la entidad individual
3. **PageInfoFieldsBuilder** - Para información de paginación

**EdgeUserFieldsBuilder (ejemplo de Edge):**
```dart
// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';

class EdgeUserFieldsBuilder {
  final List<String> _fields = [];
  
  EdgeUserFieldsBuilder edges({
    String? alias, 
    Map<String, dynamic>? args, 
    List<Directive>? directives, 
    void Function(UserFieldsBuilder)? builder
  }) {
    final child = UserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("edges", 
      alias: alias, 
      args: args, 
      directives: directives, 
      selection: child.build()
    );
    _fields.add(fieldStr);
    return this;
  }
  
  EdgeUserFieldsBuilder pageInfo({
    String? alias, 
    Map<String, dynamic>? args, 
    List<Directive>? directives, 
    void Function(PageInfoFieldsBuilder)? builder
  }) {
    final child = PageInfoFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("pageInfo", 
      alias: alias, 
      args: args, 
      directives: directives, 
      selection: child.build()
    );
    _fields.add(fieldStr);
    return this;
  }
  
  String build() => _fields.join(" ");
}
```

**UserFieldsBuilder (ejemplo de entidad):**
```dart
// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';

class UserFieldsBuilder {
  final List<String> _fields = [];
  
  UserFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  
  UserFieldsBuilder firstName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("firstName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  
  UserFieldsBuilder lastName({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("lastName", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  
  // ... más campos
  
  String build() => _fields.join(" ");
}
```

#### 3.3. Uso de FieldsBuilders

**Sintaxis Básica:**
```dart
// Crear builder
EdgeUserFieldsBuilder builder = EdgeUserFieldsBuilder();

// Configurar campos con sintaxis fluida
builder
  ..edges(builder: (userBuilder) {
    userBuilder
      ..id()
      ..firstName()
      ..lastName()
      ..email();
  })
  ..pageInfo(builder: (pageInfoBuilder) {
    pageInfoBuilder
      ..page()
      ..split()
      ..total();
  });

// Construir string de campos
String fields = builder.build();
```

**Query GraphQL Generada:**
```graphql
query getUsers {
  getUsers {
    edges {
      _id
      firstName
      lastName
      email
    }
    pageInfo {
      page
      split
      total
    }
  }
}
```

#### 3.4. Extension defaultValues()

Para evitar repetir la configuración de campos en cada uso, se crea una extensión que define los campos por defecto.

**Ubicación:**
```
/domain/extensions/
  └── edge{feature}_fields_builder_extension.dart
```

**Template:**
```dart
import '/src/domain/operation/fields_builders/main.dart';

extension Edge{Feature}FieldsBuilderExtension on Edge{Feature}FieldsBuilder {
  Edge{Feature}FieldsBuilder defaultValues() {
    return this
      ..edges(builder: ({feature}Builder) {
        {feature}Builder
          ..id()
          ..field1()
          ..field2()
          ..fieldN()
          ..created()
          ..updated();
      })
      ..pageInfo(builder: (pageInfoBuilder) {
        pageInfoBuilder
          ..page()
          ..pages()
          ..split()
          ..shown()
          ..total()
          ..overall();
      });
  }
}
```

**Uso con defaultValues():**
```dart
// En lugar de configurar todos los campos manualmente:
EdgeUserFieldsBuilder builder = EdgeUserFieldsBuilder()
  ..edges(builder: (userBuilder) {
    userBuilder..id()..firstName()..lastName()..email();
  })
  ..pageInfo(builder: (pageInfoBuilder) {
    pageInfoBuilder..page()..split();
  });

// Simplemente usa defaultValues():
EdgeUserFieldsBuilder builder = EdgeUserFieldsBuilder().defaultValues();
```

#### 3.5. Flujo Completo: Query + FieldsBuilder + UseCase

**1. Crear Query con FieldsBuilder:**
```dart
final query = GetUsersQuery(
  builder: EdgeUserFieldsBuilder().defaultValues()
);
```

**2. Usar en UseCase:**
```dart
class ReadUserUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;
  
  ReadUserUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation, _conn = conn;

  Future<dynamic> readWithoutPaginate() async {
    EdgeUserFieldsBuilder builder = EdgeUserFieldsBuilder().defaultValues();
    final response = await _conn.operation(
      operation: GetUsersQuery(builder: builder),
      variables: {},
    );
    return response;
  }
}
```

**3. Inicializar en ViewModel:**
```dart
class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ReadUserUsecase _readUseCase;
  
  final GetUsersQuery _operation = GetUsersQuery(
    builder: EdgeUserFieldsBuilder().defaultValues()
  );

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = context.read<GQLNotifier>().gqlConn;
    _readUseCase = ReadUserUsecase(
      operation: _operation,
      conn: _gqlConn,
    );
    _init();
  }
  
  Future<void> getResults() async {
    loading = true;
    try {
      final response = await _readUseCase.build();
      // Procesar response
    } catch (e) {
      error = true;
    } finally {
      loading = false;
    }
  }
}
```

**Notas Importantes:**
1. **FieldsBuilders son generados** - No se editan manualmente
2. **Extension defaultValues()** - Se crea manualmente para cada feature
3. **Query recibe builder** - Siempre pasar builder en constructor
4. **Sintaxis fluida** - Usar cascade operator (`..`) para encadenar métodos
5. **Type-safe** - Los builders garantizan que solo se seleccionen campos válidos

### 4. UseCase (Capa de Dominio)

**Ubicación:**
```
/domain/usecases/{Feature}/
  └── read_{feature}_usecase.dart
```

**Características:**
- Implementa `af.UseCase` de agile_front
- Encapsula operaciones GraphQL (usa las Queries definidas en sección 3)
- Recibe `Operation` (Query) y `Service` (GqlConn) en constructor
- Proporciona métodos específicos para diferentes tipos de consultas
- Maneja directivas GraphQL (search, paginate)

**Relación con Queries:**
El UseCase recibe una Query (creada en la sección 3) que ya tiene configurado su FieldsBuilder. El UseCase solo se encarga de ejecutar la operación con diferentes parámetros (búsqueda, paginación, etc.).

**Métodos Estándar:**
1. `build()` - Ejecución simple sin parámetros
2. `search()` - Búsqueda con filtros y paginación opcional
3. `readWithoutPaginate()` - Lectura completa sin paginación (opcional)

**Template:**
```dart
import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/inputs/searchinput_input.dart';
import '/src/domain/entities/types/pageinfo/pageinfo_model.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/get{Feature}s/get{feature}s_query.dart';
import '/src/domain/extensions/edge{feature}_fields_builder_extension.dart';


class Read{Feature}Usecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;
  
  Read{Feature}Usecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic>build() async {
    return _conn.operation(operation: _operation, callback: callback);
  }
  
  Future<dynamic>search(List<SearchInput> search, PageInfo? pageInfo) async {
    (_operation as Get{Feature}sQuery).declarativeArgs = {
      "search": "[SearchInput]"
    };

    _operation.directives = [
      Directive('search', {'input': GqlVar('search')}),
      if (pageInfo != null)
        Directive('paginate', {
          'page': pageInfo.page,
          'split': pageInfo.split,
        }),
    ];
    return _conn.operation(
      operation: _operation,
      variables: {'search': search.map((e) => e.toJson()).toList()}
    );
  }
  
  Future<dynamic> readWithoutPaginate() async {
    Edge{Feature}FieldsBuilder builder = Edge{Feature}FieldsBuilder().defaultValues();
    final response = await _conn.operation(
      operation: Get{Feature}sQuery(builder: builder),
      variables: {},
    );
    return response;
  }
  
  callback(Object ob) {
    // final thisObject = ob as Edge{Feature};
  }
}
```

**Ejemplo Real (ReadUserUsecase):**
```dart
import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/inputs/searchinput_input.dart';
import '/src/domain/entities/types/pageinfo/pageinfo_model.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getUsers/getusers_query.dart';
import '/src/domain/extensions/edgeuser_fields_builder_extension.dart';


class ReadUserUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;
  
  ReadUserUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic>build() async {
    return _conn.operation(operation: _operation, callback: callback);
  }
  
  Future<dynamic>search(List<SearchInput> search, PageInfo? pageInfo) async {
    (_operation as GetUsersQuery).declarativeArgs = {
      "search": "[SearchInput]"
    };

    _operation.directives = [
      Directive('search', {'input': GqlVar('search')}),
      if (pageInfo != null)
        Directive('paginate', {
          'page': pageInfo.page,
          'split': pageInfo.split,
        }),
    ];
    return _conn.operation(
      operation: _operation,
      variables: {'search': search.map((e) => e.toJson()).toList()}
    );
  }
  
  Future<dynamic> readWithoutPaginate() async {
    EdgeUserFieldsBuilder builder = EdgeUserFieldsBuilder().defaultValues();
    final response = await _conn.operation(
      operation: GetUsersQuery(builder: builder),
      variables: {},
    );
    return response;
  }
  
  callback(Object ob) {
    // final thisObject = ob as EdgeUser;
  }
}
```

#### Extension para FieldsBuilder

**Ubicación:**
```
/domain/extensions/
  └── edge{feature}_fields_builder_extension.dart
```

**Características:**
- Extiende el FieldsBuilder generado automáticamente
- Define método `defaultValues()` con los campos por defecto
- Incluye campos de edges (entidad) y pageInfo

**Template:**
```dart
import '/src/domain/operation/fields_builders/main.dart';

extension Edge{Feature}FieldsBuilderExtension on Edge{Feature}FieldsBuilder {
  Edge{Feature}FieldsBuilder defaultValues() {
    return this
      ..edges(builder: ({feature}Builder) {
        {feature}Builder
          ..id()
          ..field1()
          ..field2()
          ..fieldN()
          ..created()
          ..updated();
      })
      ..pageInfo(builder: (pageInfoBuilder) {
        pageInfoBuilder
          ..page()
          ..pages()
          ..split()
          ..shown()
          ..total()
          ..overall();
      });
  }
}
```

**Ejemplo Real (EdgeUserFieldsBuilderExtension):**
```dart
import '/src/domain/operation/fields_builders/main.dart';

extension EdgeUserFieldsBuilderExtension on EdgeUserFieldsBuilder {
  EdgeUserFieldsBuilder defaultValues() {
    return this
      ..edges(builder: (userBuilder) {
        userBuilder
          ..id()
          ..firstName()
          ..lastName()
          ..role()
          ..email()
          ..cutOffDate()
          ..fee()
          ..created()
          ..updated();
      })
      ..pageInfo(builder: (pageInfoBuilder) {
        pageInfoBuilder
          ..page()
          ..pages()
          ..split()
          ..shown()
          ..total()
          ..overall();
      });
  }
}
```

**Notas Importantes:**
1. **Query como dependencia** - El UseCase recibe una Query ya configurada con su FieldsBuilder (ver sección 3)
2. **Directivas GraphQL** - `search` y `paginate` se agregan dinámicamente según necesidad
3. **declarativeArgs** - Define variables GraphQL necesarias para la query
4. **readWithoutPaginate()** - Método opcional que crea una nueva Query con defaultValues()
5. **callback()** - Puede procesar el resultado si se necesita transformación adicional
6. **Extension defaultValues()** - Centraliza la configuración de campos por defecto (ver sección 3.4)

**Flujo completo de ejecución:**
```
ViewModel crea Query con FieldsBuilder.defaultValues()
    ↓
Query se pasa al UseCase en constructor
    ↓
UseCase.build() ejecuta la operación GraphQL
    ↓
Query.build() genera string GraphQL con los campos configurados
    ↓
GqlConn envía query al servidor
    ↓
Query.result() transforma JSON a entidad Edge{Feature}
```

### 5. Configuración (search_config.dart)

**Características:**
- Función que retorna SearchTemplateConfig
- Recibe `context`, `viewModel` y `l10n` como parámetros nombrados requeridos
- Usa `l10n` para TODOS los textos visibles
- Contiene toda la configuración del SearchTemplate

**Template:**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/infraestructure/utils/search_fields.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';

SearchTemplateConfig getSearchConfig({
  required BuildContext context,
  required ViewModel viewModel,
  required AppLocalizations l10n,  // l10n es requerido
}) {
  return SearchTemplateConfig(
    rightWidget: FilledButton.icon(
      icon: const Icon(Icons.add),
      label: Text(l10n.createThing(l10n.user)),  // Usar l10n
      onPressed: () async {
        final result = await context.push('/user/create');
        if (result == true) {
          viewModel.getUsers();
        }
      },
    ),
    searchFields: [
      SearchFields(field: 'name', label: l10n.name),
      SearchFields(field: 'email', label: l10n.email),
    ],
    pageInfo: viewModel.pageInfo,
    onSearchChanged: (search) {
      viewModel.search(search);
    },
    onPageInfoChanged: (pageInfo) {
      viewModel.updatePageInfo(pageInfo);
    },
  );
}
```

### 6. Constructor de Lista (list_builder.dart)

**Características:**
- Función que retorna `List<Widget>`
- Recibe `context` y `viewModel` como parámetros
- **Maneja 4 estados obligatorios**: loading, error, empty (sin datos), success (con datos)
- Usa el prefijo `build` siguiendo la convención de Flutter (como `WidgetBuilder`)
- Cada item del map debe recibir la entidad completa, no propiedades individuales
- Los callbacks de navegación deben incluir refresh automático (`viewModel.getResults()`)

**Estados Obligatorios:**
1. **Loading** - Muestra `CircularProgressIndicator` mientras carga
2. **Error** - Muestra mensaje de error si falla la petición
3. **Empty** - Muestra mensaje cuando la lista está vacía
4. **Success** - Mapea cada item de la lista a su widget correspondiente

**Template:**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './user_item.dart';

List<Widget> buildList({
  required BuildContext context,
  required ViewModel viewModel,
  required AppLocalizations l10n,  // l10n es requerido
}) {
  // Estado: Cargando
  if (viewModel.loading) {
    return [const Center(child: CircularProgressIndicator())];
  }

  // Estado: Error
  if (viewModel.error) {
    return [
      Center(
        child: Text(l10n.errorLoadingData),  // Usar l10n
      )
    ];
  }

  // Estado: Sin datos
  if (viewModel.userList == null || viewModel.userList!.isEmpty) {
    return [
      Center(
        child: Text(l10n.noDataAvailable),  // Usar l10n
      )
    ];
  }

  // Estado: Con datos - mapea cada item a su widget
  return viewModel.userList!.map((user) {
    return UserItem(
      user: user,  // Pasa la entidad completa
      l10n: l10n,  // Pasar l10n al widget
      onUpdate: (id) async {
        final result = await context.push('/user/update/$id');
        if (result == true) {
          viewModel.getUsers();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/user/delete/$id');
        if (result == true) {
          viewModel.getUsers();
        }
      },
    );
  }).toList();
}
```

**Notas Importantes:**
1. **Siempre manejar los 4 estados** - No omitir ninguno, incluso si parece obvio
2. **Entidad completa en el widget** - Pasar `item: item` completo, no propiedades individuales
3. **Refresh después de acciones** - Llamar `viewModel.getResults()` después de update/delete
4. **Callbacks opcionales** - Usar `Function(String id)?` con `?` para callbacks opcionales
5. **Import de go_router** - Solo si usas navegación con `context.push()`

**Errores Comunes a Evitar:**
- ❌ No manejar todos los estados
- ❌ Pasar solo `id` o propiedades sueltas al widget del item
- ❌ Olvidar el refresh después de update/delete
- ❌ No usar callbacks opcionales (hacer todos required)

#### Ejemplo de Widget de Item ({item}_item.dart)

**Template:**
```dart
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';

class UserItem extends StatelessWidget {
  final User user;  // Recibe la entidad completa
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;
  final Function(String id)? onCustomAction;

  const UserItem({
    super.key,
    required this.user,
    this.onUpdate,
    this.onDelete,
    this.onCustomAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit' && onUpdate != null) {
                  onUpdate!(user.id);
                } else if (value == 'delete' && onDelete != null) {
                  onDelete!(user.id);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),
                const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
              ],
            ),
          ),
          if (onCustomAction != null)
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () => onCustomAction!(user.id),
                  child: const Text('Acción personalizada'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
```

## Resumen del Flujo Completo READ

### Flujo de Ejecución
```
1. Usuario abre la página
   ↓
2. UserPage crea ViewModel(context)
   ↓
3. ViewModel inicializa:
   - GqlConn desde provider
   - GetUsersQuery con EdgeUserFieldsBuilder.defaultValues()
   - ReadUserUsecase con query y conn
   ↓
4. _init() → getUsers()
   ↓
5. UseCase.build() ejecuta query GraphQL
   ↓
6. Query.build() genera string GraphQL con campos
   ↓
7. GqlConn envía query al servidor
   ↓
8. Query.result() transforma JSON → EdgeUser
   ↓
9. ViewModel actualiza userList y pageInfo
   ↓
10. notifyListeners() → ListenableBuilder actualiza UI
   ↓
11. buildList() mapea usuarios a UserItem widgets
```

### Flujo de Búsqueda
```
1. Usuario ingresa texto en SearchTemplate
   ↓
2. onSearchChanged callback en search_config
   ↓
3. ViewModel.search(searchInputs)
   ↓
4. UseCase.search(searchInputs, pageInfo)
   ↓
5. Agrega directives: @search, @paginate
   ↓
6. Ejecuta query con variables
   ↓
7. Actualiza userList con resultados filtrados
```

### Flujo de Paginación
```
1. Usuario cambia página en SearchTemplate
   ↓
2. onPageInfoChanged callback en search_config
   ↓
3. ViewModel.updatePageInfo(newPageInfo)
   ↓
4. Actualiza _pageInfo y llama search([])
   ↓
5. Query incluye directive @paginate con nueva página
   ↓
6. Carga datos de la nueva página
```

## Internacionalización (i18n)

### Regla Obligatoria
**TODOS los textos visibles al usuario DEBEN usar AppLocalizations**. No se permiten strings hardcodeados en español o inglés.

### Configuración Básica

**Archivos de localización:**
```
lib/l10n/
  ├── app_en.arb              # Traducciones en inglés
  ├── app_es.arb              # Traducciones en español
  ├── app_localizations.dart  # Clase generada automáticamente
  ├── app_localizations_en.dart
  └── app_localizations_es.dart
```

### Uso en Widgets

**En main.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';  // Import obligatorio
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';
import './search_config.dart';
import './list_builder.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late ViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;  // Obtener l10n
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return SearchTemplate(
          config: getSearchConfig(
            context: context, 
            viewModel: viewModel,
            l10n: l10n,  // Pasar l10n a search_config
          ),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: buildList(
              context: context, 
              viewModel: viewModel,
              l10n: l10n,  // Pasar l10n a list_builder
            ),
          ),
        );
      },
    );
  }
}
```

**En search_config.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/infraestructure/utils/search_fields.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';

SearchTemplateConfig getSearchConfig({
  required BuildContext context,
  required ViewModel viewModel,
  required AppLocalizations l10n,  // Recibir l10n como parámetro
}) {
  return SearchTemplateConfig(
    rightWidget: FilledButton.icon(
      icon: const Icon(Icons.add),
      label: Text(l10n.createThing(l10n.user)),  // Usar l10n para textos
      onPressed: () async {
        final result = await context.push('/user/create');
        if (result == true) {
          viewModel.getUsers();
        }
      },
    ),
    searchFields: [
      SearchFields(field: 'name', label: l10n.name),
      SearchFields(field: 'email', label: l10n.email),
    ],
    pageInfo: viewModel.pageInfo,
    onSearchChanged: (search) {
      viewModel.search(search);
    },
    onPageInfoChanged: (pageInfo) {
      viewModel.updatePageInfo(pageInfo);
    },
  );
}
```

**En list_builder.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './user_item.dart';

List<Widget> buildList({
  required BuildContext context,
  required ViewModel viewModel,
  required AppLocalizations l10n,  // Recibir l10n
}) {
  // Estado: Cargando
  if (viewModel.loading) {
    return [const Center(child: CircularProgressIndicator())];
  }

  // Estado: Error
  if (viewModel.error) {
    return [
      Center(
        child: Text(l10n.errorLoadingData),  // Usar l10n
      )
    ];
  }

  // Estado: Sin datos
  if (viewModel.userList == null || viewModel.userList!.isEmpty) {
    return [
      Center(
        child: Text(l10n.noDataAvailable),  // Usar l10n
      )
    ];
  }

  // Estado: Con datos
  return viewModel.userList!.map((user) {
    return UserItem(
      user: user,
      l10n: l10n,  // Pasar l10n al widget item
      onUpdate: (id) async {
        final result = await context.push('/user/update/$id');
        if (result == true) {
          viewModel.getUsers();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/user/delete/$id');
        if (result == true) {
          viewModel.getUsers();
        }
      },
    );
  }).toList();
}
```

**En user_item.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';

class UserItem extends StatelessWidget {
  final User user;
  final AppLocalizations l10n;  // Recibir l10n
  final Function(String id)? onUpdate;
  final Function(String id)? onDelete;

  const UserItem({
    super.key,
    required this.user,
    required this.l10n,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person_outline)),
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(user.email),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit' && onUpdate != null) {
              onUpdate!(user.id);
            } else if (value == 'delete' && onDelete != null) {
              onDelete!(user.id);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Text(l10n.edit),  // Usar l10n
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(l10n.delete),  // Usar l10n
            ),
          ],
        ),
      ),
    );
  }
}
```

### Archivos .arb (Traducciones)

**app_es.arb (Español):**
```json
{
  "@@locale": "es",
  
  // ============ ENTIDADES ============
  "user": "Usuario",
  "@user": {
    "description": "Término para usuario en singular"
  },
  "users": "Usuarios",
  "@users": {
    "description": "Término para usuarios en plural"
  },
  
  // ============ TEMPLATES CRUD ============
  "newThing": "Nuevo {thing}",
  "@newThing": {
    "description": "Plantilla para crear entidad masculina/neutra. Ej: Nuevo Usuario",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Usuario"
      }
    }
  },
  "newFemeThing": "Nueva {thing}",
  "@newFemeThing": {
    "description": "Plantilla para crear entidad femenina. Ej: Nueva Empresa",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Empresa"
      }
    }
  },
  "createThing": "Crear {thing}",
  "@createThing": {
    "description": "Plantilla para acción de crear. Ej: Crear Usuario",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Usuario"
      }
    }
  },
  "updateThing": "Actualizar {thing}",
  "@updateThing": {
    "description": "Plantilla para acción de actualizar. Ej: Actualizar Usuario",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Usuario"
      }
    }
  },
  "editThing": "Editar {thing}",
  "@editThing": {
    "description": "Plantilla para acción de editar. Ej: Editar Usuario",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Usuario"
      }
    }
  },
  "deleteThing": "Eliminar {thing}",
  "@deleteThing": {
    "description": "Plantilla para acción de eliminar. Ej: Eliminar Usuario",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Usuario"
      }
    }
  },
  "deleteQuestion": "¿Está seguro de eliminar {thing}?",
  "@deleteQuestion": {
    "description": "Pregunta de confirmación para eliminar. Ej: ¿Está seguro de eliminar Usuario?",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Usuario"
      }
    }
  },
  
  // ============ MENSAJES DE LISTA VACÍA ============
  "noRegisteredMaleThings": "No hay {thing} registrados",
  "@noRegisteredMaleThings": {
    "description": "Mensaje cuando no hay registros (masculino/neutro). Ej: No hay Usuarios registrados",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Usuarios"
      }
    }
  },
  "noRegisteredFemaleThings": "No hay {thing} registradas",
  "@noRegisteredFemaleThings": {
    "description": "Mensaje cuando no hay registros (femenino). Ej: No hay Empresas registradas",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Empresas"
      }
    }
  },
  
  // ============ CAMPOS DE FORMULARIO ============
  "name": "Nombre",
  "@name": {
    "description": "Etiqueta para campo de nombre"
  },
  "email": "Correo electrónico",
  "@email": {
    "description": "Etiqueta para campo de correo electrónico"
  },
  
  // ============ MENSAJES DE ESTADO ============
  "loading": "Cargando...",
  "@loading": {
    "description": "Mensaje mostrado durante carga de datos"
  },
  "errorLoadingData": "Error al cargar los datos",
  "@errorLoadingData": {
    "description": "Mensaje de error cuando falla la carga de datos"
  },
  "noDataAvailable": "No hay datos disponibles",
  "@noDataAvailable": {
    "description": "Mensaje cuando no existen datos para mostrar"
  },
  
  // ============ ACCIONES GENERALES ============
  "search": "Buscar",
  "@search": {
    "description": "Acción o etiqueta para búsqueda"
  },
  "filter": "Filtrar",
  "@filter": {
    "description": "Acción o etiqueta para filtrado"
  },
  "edit": "Editar",
  "@edit": {
    "description": "Acción para editar registro"
  },
  "delete": "Eliminar",
  "@delete": {
    "description": "Acción para eliminar registro"
  },
  "save": "Guardar",
  "@save": {
    "description": "Acción para guardar cambios"
  },
  "cancel": "Cancelar",
  "@cancel": {
    "description": "Acción para cancelar operación"
  }
}
```

**app_en.arb (Inglés):**
```json
{
  "@@locale": "en",
  
  // ============ ENTITIES ============
  "user": "User",
  "@user": {
    "description": "Term for user in singular form"
  },
  "users": "Users",
  "@users": {
    "description": "Term for users in plural form"
  },
  
  // ============ CRUD TEMPLATES ============
  "newThing": "New {thing}",
  "@newThing": {
    "description": "Template for creating new entity. Ex: New User",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "User"
      }
    }
  },
  "newFemeThing": "New {thing}",
  "@newFemeThing": {
    "description": "Template for creating new entity (same as newThing in English). Ex: New Company",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Company"
      }
    }
  },
  "createThing": "Create {thing}",
  "@createThing": {
    "description": "Template for create action. Ex: Create User",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "User"
      }
    }
  },
  "updateThing": "Update {thing}",
  "@updateThing": {
    "description": "Template for update action. Ex: Update User",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "User"
      }
    }
  },
  "editThing": "Edit {thing}",
  "@editThing": {
    "description": "Template for edit action. Ex: Edit User",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "User"
      }
    }
  },
  "deleteThing": "Delete {thing}",
  "@deleteThing": {
    "description": "Template for delete action. Ex: Delete User",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "User"
      }
    }
  },
  "deleteQuestion": "Are you sure you want to delete {thing}?",
  "@deleteQuestion": {
    "description": "Confirmation question for deletion. Ex: Are you sure you want to delete User?",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "User"
      }
    }
  },
  
  // ============ EMPTY LIST MESSAGES ============
  "noRegisteredMaleThings": "No {thing} registered",
  "@noRegisteredMaleThings": {
    "description": "Message when no records exist. Ex: No Users registered",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Users"
      }
    }
  },
  "noRegisteredFemaleThings": "No {thing} registered",
  "@noRegisteredFemaleThings": {
    "description": "Message when no records exist (same as male in English). Ex: No Companies registered",
    "placeholders": {
      "thing": {
        "type": "String",
        "example": "Companies"
      }
    }
  },
  
  // ============ FORM FIELDS ============
  "name": "Name",
  "@name": {
    "description": "Label for name field"
  },
  "email": "Email",
  "@email": {
    "description": "Label for email field"
  },
  
  // ============ STATE MESSAGES ============
  "loading": "Loading...",
  "@loading": {
    "description": "Message displayed during data loading"
  },
  "errorLoadingData": "Error loading data",
  "@errorLoadingData": {
    "description": "Error message when data loading fails"
  },
  "noDataAvailable": "No data available",
  "@noDataAvailable": {
    "description": "Message when no data exists to display"
  },
  
  // ============ GENERAL ACTIONS ============
  "search": "Search",
  "@search": {
    "description": "Action or label for search"
  },
  "filter": "Filter",
  "@filter": {
    "description": "Action or label for filtering"
  },
  "edit": "Edit",
  "@edit": {
    "description": "Action to edit record"
  },
  "delete": "Delete",
  "@delete": {
    "description": "Action to delete record"
  },
  "save": "Save",
  "@save": {
    "description": "Action to save changes"
  },
  "cancel": "Cancel",
  "@cancel": {
    "description": "Action to cancel operation"
  }
}
```

### Patrones Comunes con Placeholders

**Traducciones con parámetros:**
```json
// app_es.arb
{
  "createThing": "Crear {thing}",
  "deleteThing": "¿Eliminar {thing}?",
  "thingCount": "{count} {thing}",
  "@thingCount": {
    "placeholders": {
      "count": {"type": "int"},
      "thing": {"type": "String"}
    }
  }
}

// Uso en código
Text(l10n.createThing(l10n.user))        // "Crear Usuario"
Text(l10n.deleteThing(l10n.user))        // "¿Eliminar Usuario?"
Text(l10n.thingCount(5, l10n.users))     // "5 Usuarios"
```

### Templates con Género (Español)

**En español, algunos sustantivos tienen género diferente:**
```dart
// Masculino/Neutro - usar newThing
Text(l10n.newThing(l10n.user))           // "Nuevo Usuario"
Text(l10n.newThing(l10n.product))        // "Nuevo Producto"

// Femenino - usar newFemeThing
Text(l10n.newFemeThing(l10n.company))    // "Nueva Empresa"
Text(l10n.newFemeThing(l10n.license))    // "Nueva Licencia"

// Listas vacías con género
Text(l10n.noRegisteredMaleThings(l10n.users))      // "No hay Usuarios registrados"
Text(l10n.noRegisteredFemaleThings(l10n.companies)) // "No hay Empresas registradas"
```

**Nota:** En inglés, `newThing` y `newFemeThing` son iguales, pero se mantienen ambas keys para consistencia entre idiomas.

### Convención de Nombres en .arb

**Categorías de keys:**
```json
{
  // Entidades (sustantivos, singular y plural)
  "user": "Usuario",
  "users": "Usuarios",
  "product": "Producto",
  "products": "Productos",
  
  // Acciones (verbos)
  "create": "Crear",
  "edit": "Editar",
  "delete": "Eliminar",
  "save": "Guardar",
  "cancel": "Cancelar",
  
  // Campos de formulario
  "name": "Nombre",
  "email": "Correo electrónico",
  "password": "Contraseña",
  
  // Mensajes de estado
  "loading": "Cargando...",
  "errorLoadingData": "Error al cargar los datos",
  "noDataAvailable": "No hay datos disponibles",
  
  // Templates con placeholders (camelCase)
  "createThing": "Crear {thing}",
  "deleteThing": "¿Eliminar {thing}?",
  "editThing": "Editar {thing}"
}
```

### Reglas Importantes

1. 🔑 **CREAR KEYS SI NO EXISTEN:**
   - Las keys de internacionalización NO necesitan existir previamente
   - Si necesitas `l10n.newThing`, simplemente agrégala a los archivos `.arb`
   - Todas las keys deben crearse en ambos archivos: `app_es.arb` y `app_en.arb`
   - Flutter generará automáticamente el código de `AppLocalizations` al guardar

2. ✅ **Siempre obtener l10n en build():**
   ```dart
   final l10n = AppLocalizations.of(context)!;
   ```

3. ✅ **Pasar l10n como parámetro a funciones:**
   ```dart
   getSearchConfig(context: context, viewModel: viewModel, l10n: l10n)
   ```

4. ✅ **Pasar l10n a widgets hijos:**
   ```dart
   UserItem(user: user, l10n: l10n)
   ```

5. ✅ **Agregar @metadata para cada key:**
   ```json
   "user": "Usuario",
   "@user": {
     "description": "Término para usuario en singular"
   }
   ```

6. ❌ **NUNCA hardcodear textos:**
   ```dart
   // MAL ❌
   Text("Crear Usuario")
   
   // BIEN ✅
   Text(l10n.createThing(l10n.user))
   ```

7. ✅ **Usar templates para textos compuestos:**
   ```dart
   // Mejor usar template con placeholder
   l10n.createThing(l10n.user)  // "Crear Usuario"
   
   // Que concatenar strings
   "${l10n.create} ${l10n.user}"  // Más difícil de traducir
   ```

## Manejo de Contexto

### Regla Importante
**NUNCA** almacenar el `context` en variables de instancia fuera del ciclo de vida del widget.

### Forma Correcta ✅
```dart
// Pasar context como parámetro
Widget buildForm({
  required BuildContext context,
  required ViewModel viewModel,
}) {
  return ElevatedButton(
    onPressed: () {
      // context está disponible y es válido
      context.push('/route');
    },
    child: Text('Ir'),
  );
}
```

### Forma Incorrecta ❌
```dart
class MyClass {
  BuildContext? _context; // NO HACER ESTO
  
  void setContext(BuildContext context) {
    _context = context; // Puede causar memory leaks
  }
}
```

## Objetos de Configuración

### Cuándo Crear un Objeto de Configuración
- Cuando un widget tiene 5+ parámetros relacionados
- Para agrupar parámetros que siempre se usan juntos
- Para reducir la complejidad del constructor

### Template de Objeto de Configuración
```dart
class TemplateConfig {
  final Widget rightWidget;
  final Alignment alignment;
  final List<Filter>? filters;
  final Function()? onAction;
  final Function(PageInfo)? onPageInfoChanged;
  
  const TemplateConfig({
    this.rightWidget = const SizedBox.shrink(),
    this.alignment = Alignment.centerRight,
    this.filters,
    this.onAction,
    this.onPageInfoChanged,
  });
}

// Uso
class MyWidget extends StatelessWidget {
  final Widget child;
  final TemplateConfig config;
  
  const MyWidget({
    super.key,
    required this.child,
    this.config = const TemplateConfig(),
  });
}
```

## Guía para Clonar un Módulo

### Paso 1: Copiar Estructura
```bash
# Copiar carpeta completa
cp -r pages/User/read pages/Product/read
```

### Paso 2: Archivos que NO Cambian de Nombre
Los siguientes archivos mantienen el mismo nombre:
- ✅ `view_model.dart`
- ✅ `config.dart`
- ✅ `list_builder.dart`
- ✅ `form_builder.dart`

### Paso 3: Archivos que SÍ Cambian de Nombre
- `user_item.dart` → `product_item.dart`
- Otros componentes específicos del feature

### Paso 4: Ajustar Contenido
1. En `main.dart`:
   - Cambiar nombre del widget: `UserPage` → `ProductPage`
   - Los imports de archivos genéricos NO cambian

2. En `view_model.dart`:
   - Ajustar lógica específica del feature
   - Cambiar tipos de datos si es necesario

3. En `search_config.dart`:
   - Ajustar textos (botones, labels)
   - Ajustar rutas de navegación
   - La función `getSearchConfig()` mantiene el nombre

4. En `list_builder.dart`:
   - Cambiar import del widget: `user_item.dart` → `product_item.dart`
   - La función `buildList()` mantiene el nombre

### Paso 5: Verificar Imports
```dart
// Estos imports NO cambian (archivos genéricos)
import './view_model.dart';
import './search_config.dart';
import './list_builder.dart';

// Este import SÍ cambia (archivo específico)
import './user_item.dart';  // → import './product_item.dart';
```

## Ventajas del Patrón

### 1. Código Limpio y Legible
- Archivos cortos y enfocados
- Fácil de entender el flujo
- Separación clara de responsabilidades

### 2. Fácil Mantenimiento
- Cambios aislados en archivos específicos
- No hay efectos secundarios inesperados
- Fácil de debuggear

### 3. Testeable
- Cada función puede testearse por separado
- No hay dependencias ocultas
- Fácil de mockear

### 4. Reutilizable
- Funciones puras que pueden usarse en múltiples lugares
- Nombres genéricos facilitan la reutilización
- Configuraciones encapsuladas

### 5. Escalable
- Estructura predecible
- Fácil de agregar nuevos features
- Reduce curva de aprendizaje para nuevos desarrolladores

### 6. No Hay Problemas de Contexto
- Context se pasa explícitamente como parámetro
- No se almacena en variables de instancia
- Callbacks capturan el contexto correctamente

### 7. Facilita Clonación de Módulos
- Nombres consistentes en todos los módulos
- Copy/paste con ajustes mínimos
- Menos errores al crear nuevos features

## Cuándo Aplicar Separación

### SÍ Separar en Archivo Aparte
- ✅ Configuraciones con 5+ propiedades
- ✅ Lógica de construcción de listas complejas
- ✅ Callbacks con lógica de más de 3 líneas
- ✅ Formularios con múltiples campos
- ✅ Cualquier código que se repita en múltiples lugares

### NO Separar
- ❌ Widgets simples de 1-2 líneas
- ❌ Configuraciones con 1-2 propiedades
- ❌ Callbacks triviales (ej: `() => setState()`)
- ❌ Código que solo se usa una vez y es muy específico

## Checklist de Revisión - Módulo READ

### Presentación (/pages/{Feature}/read/)
- [ ] `main.dart` tiene menos de 40 líneas
- [ ] `main.dart` solo orquesta: ListenableBuilder → SearchTemplate → buildList()
- [ ] `main.dart` obtiene `l10n` con `AppLocalizations.of(context)!`
- [ ] `main.dart` pasa `l10n` a getSearchConfig() y buildList()
- [ ] `view_model.dart` extiende ChangeNotifier
- [ ] `view_model.dart` tiene estados: _loading, _error, _userList, _pageInfo
- [ ] `view_model.dart` tiene Query con EdgeUserFieldsBuilder.defaultValues()
- [ ] `view_model.dart` inicializa ReadUserUsecase en constructor
- [ ] `view_model.dart` implementa: getUsers(), search(), updatePageInfo()
- [ ] Todos los setters llaman `notifyListeners()`
- [ ] `search_config.dart` recibe parámetro `l10n` requerido
- [ ] `search_config.dart` usa `l10n` para TODOS los textos (no strings hardcodeados)
- [ ] `list_builder.dart` recibe parámetro `l10n` requerido
- [ ] `list_builder.dart` usa `l10n` en mensajes de error, loading, empty
- [ ] `list_builder.dart` maneja 4 estados: loading, error, empty, success
- [ ] `list_builder.dart` pasa `l10n` al widget item
- [ ] `{item}_item.dart` recibe `l10n` como parámetro requerido
- [ ] `{item}_item.dart` usa `l10n` para TODOS los textos visibles
- [ ] `{item}_item.dart` recibe entidad completa, no propiedades sueltas
- [ ] Los callbacks son opcionales (`Function(String id)?`)

### Internacionalización (i18n)
- [ ] ❌ NO hay strings hardcodeados en español o inglés
- [ ] 🔑 Si una key no existe, créala en ambos archivos `.arb`
- [ ] ✅ Todas las keys necesarias existen en `app_es.arb`
- [ ] ✅ Todas las keys necesarias existen en `app_en.arb`
- [ ] ✅ Cada key tiene su @metadata con description detallada
- [ ] ✅ Cada placeholder tiene su tipo y ejemplo definido
- [ ] ✅ Keys de entidad definidas (singular y plural): "user", "users"
- [ ] ✅ Keys de acciones: "edit", "delete", "save", "cancel", "search", "filter"
- [ ] ✅ Keys de estado: "loading", "errorLoadingData", "noDataAvailable"
- [ ] ✅ Templates CRUD: "newThing", "createThing", "updateThing", "editThing", "deleteThing"
- [ ] ✅ Templates con género (español): "newThing", "newFemeThing"
- [ ] ✅ Templates de lista vacía: "noRegisteredMaleThings", "noRegisteredFemaleThings"
- [ ] ✅ Template de confirmación: "deleteQuestion"
- [ ] ✅ Comentarios organizadores por sección en archivos `.arb`

### Dominio
- [ ] `Read{Feature}Usecase` implementado con build(), search(), readWithoutPaginate()
- [ ] `Get{Feature}sQuery` implementado con FieldsBuilder
- [ ] Extension `Edge{Feature}FieldsBuilderExtension` con defaultValues()
- [ ] defaultValues() incluye todos los campos necesarios + pageInfo completo
- [ ] UseCase maneja directivas: @search y @paginate

### General
- [ ] Context se pasa como parámetro, nunca se almacena
- [ ] `l10n` se pasa como parámetro a funciones y widgets
- [ ] Imports organizados: externos → internos → locales
- [ ] Import de AppLocalizations en archivos que usan textos
- [ ] No hay código comentado innecesario
- [ ] Nombres genéricos en archivos reutilizables
- [ ] Sin errores de compilación

## Implementación de Referencia

**Módulo completo User/read:**
```
/pages/User/read/
  ├── main.dart              # 30 líneas - Orquestador
  ├── view_model.dart        # 108 líneas - Estados + Query + UseCase + Métodos
  ├── search_config.dart     # getSearchConfig() → SearchTemplateConfig
  ├── list_builder.dart      # buildList() con 4 estados obligatorios
  └── user_item.dart         # UserItem con User entity + callbacks opcionales

/domain/usecases/User/
  └── read_user_usecase.dart           # 48 líneas - 3 métodos

/domain/extensions/
  └── edgeuser_fields_builder_extension.dart  # defaultValues()

/domain/operation/queries/getUsers/
  └── getusers_query.dart              # GetUsersQuery con EdgeUserFieldsBuilder
```

**Usar este módulo como base para clonar nuevos módulos READ.**

## Próximos Chatmodes

Este patrón cubre **READ (listado con búsqueda y paginación)**. Para otras operaciones, consultar:

- 🔜 `create_pattern.chatmode.md` - Patrón para CREATE (formularios de creación)
- 🔜 `update_pattern.chatmode.md` - Patrón para UPDATE (formularios de edición)
- 🔜 `delete_pattern.chatmode.md` - Patrón para DELETE (confirmación y eliminación)
