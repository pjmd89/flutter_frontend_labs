# Patrón de Arquitectura Modular Flutter

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

## Estructura de Archivos Estándar

```
/pages/{Feature}/{Action}/
  ├── main.dart              # Widget principal (orquestador)
  ├── view_model.dart        # Lógica de negocio y estado
  ├── search_config.dart     # Configuración del SearchTemplate
  ├── list_builder.dart      # Constructor de listas/grid/contenido
  ├── form_builder.dart      # Constructor de formularios (si aplica)
  └── {item}_item.dart       # Widget individual del item (nombre específico)
```

### Ejemplo Completo de Estructura

```
/pages/
  /User/
    /read/
      ├── main.dart              # UserPage widget
      ├── view_model.dart        # ViewModel class
      ├── search_config.dart     # getSearchConfig() → SearchTemplateConfig
      ├── list_builder.dart      # buildList() → List<Widget>
      └── user_item.dart         # Widget individual del usuario
    /create/
      ├── main.dart              # UserCreatePage widget
      ├── view_model.dart        # ViewModel class
      └── form_builder.dart      # buildForm() → Widget
  /Product/
    /read/
      ├── main.dart              # ProductPage widget
      ├── view_model.dart        # ViewModel class
      ├── search_config.dart     # getSearchConfig() (mismo nombre!)
      ├── list_builder.dart      # buildList() (mismo nombre!)
      └── product_item.dart      # Widget individual del producto
```

## Convención de Nombres

### Archivos Genéricos (usar en todos los módulos)
- `search_config.dart` - Configuración del SearchTemplate
- `list_builder.dart` - Constructor de listas
- `form_builder.dart` - Constructor de formularios
- `view_model.dart` - Lógica de negocio

### Archivos Específicos (cambiar según feature)
- `main.dart` - Contiene `{Feature}Page` o `{Feature}{Action}Page`
- `{item}_item.dart` - Widget del item (ej: `user_item.dart`, `product_item.dart`)
  - Puede ser Card, ListTile, Container, o cualquier widget según el diseño
- Entities y modelos del dominio

### Funciones Estándar (siguiendo convención Builder de Flutter)
- `getSearchConfig()` - Retorna SearchTemplateConfig
- `buildList()` - Retorna `List<Widget>` para listas
- `buildForm()` - Retorna `Widget` para formularios
- `buildContent()` - Retorna `Widget` para contenido personalizado
- `buildItem()` - Retorna `Widget` para un item individual

**Nota:** El prefijo `build` sigue la convención de Flutter para funciones que construyen widgets, similar a `WidgetBuilder`, `IndexedWidgetBuilder`, etc.

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
- Extiende `ChangeNotifier`
- Maneja estado local con getters/setters
- Llama `notifyListeners()` cuando cambia el estado
- Recibe `BuildContext` en constructor para acceder a providers

**Template:**
```dart
import 'package:flutter/material.dart';
import 'package:agile_front/agile_front.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  // Estado privado
  bool _loading = true;
  bool _error = false;
  List<dynamic>? _resultList;
  
  // Dependencias
  late GqlConn _gqlConn;
  final BuildContext _context;

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<dynamic>? get resultList => _resultList;

  // Setters con notificación
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set resultList(List<dynamic>? value) {
    _resultList = value;
    notifyListeners();
  }

  // Constructor
  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _init();
  }

  // Inicialización
  Future<void> _init() async {
    await getResults();
  }

  // Métodos de negocio
  Future<void> getResults() async {
    loading = true;
    try {
      // Lógica de obtención de datos
      final results = await _gqlConn.operation(operation: someOperation);
      resultList = results;
      error = false;
    } catch (e) {
      error = true;
    } finally {
      loading = false;
    }
  }

  Future<void> search(List<SearchInput> searchInputs) async {
    // Lógica de búsqueda
    await getResults();
  }

  Future<void> updatePageInfo(PageInfo pageInfo) async {
    // Lógica de paginación
    await getResults();
  }
}
```

### 3. Configuración (search_config.dart)

**Características:**
- Función que retorna SearchTemplateConfig
- Recibe `context` y `viewModel` como parámetros nombrados requeridos
- Contiene toda la configuración del SearchTemplate

**Template:**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/infraestructure/utils/search_fields.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';

SearchTemplateConfig getSearchConfig({
  required BuildContext context,
  required ViewModel viewModel,
}) {
  return SearchTemplateConfig(
    rightWidget: FilledButton.icon(
      icon: const Icon(Icons.add),
      label: Text("Nuevo Item"),
      onPressed: () async {
        final result = await context.push('/feature/create');
        if (result == true) {
          viewModel.getResults();
        }
      },
    ),
    searchFields: [
      SearchFields(field: 'name'),
      SearchFields(field: 'email'),
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

### 4. Constructor de Lista (list_builder.dart)

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
import './view_model.dart';
import './item_item.dart'; // Widget del item (puede ser Card, ListTile, etc.)

List<Widget> buildList({
  required BuildContext context,
  required ViewModel viewModel,
}) {
  // Estado: Cargando
  if (viewModel.loading) {
    return [const Center(child: CircularProgressIndicator())];
  }

  // Estado: Error
  if (viewModel.error) {
    return [
      const Center(
        child: Text('Error al cargar los datos'),
      )
    ];
  }

  // Estado: Sin datos
  if (viewModel.resultList == null || viewModel.resultList!.isEmpty) {
    return [
      const Center(
        child: Text('No hay datos disponibles'),
      )
    ];
  }

  // Estado: Con datos - mapea cada item a su widget
  return viewModel.resultList!.map((item) {
    return ItemWidget(
      item: item,  // Pasa la entidad completa
      onUpdate: (id) async {
        final result = await context.push('/feature/update/$id');
        if (result == true) {
          viewModel.getResults();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/feature/delete/$id');
        if (result == true) {
          viewModel.getResults();
        }
      },
      // Callbacks adicionales según necesidad
      onCustomAction: (id) {
        // context.push('/feature/$id/custom');
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

### 5. Constructor de Formulario (form_builder.dart)

**Características:**
- Función que retorna `Widget`
- Recibe `context` y `viewModel` como parámetros
- Agrupa todos los campos del formulario

**Template:**
```dart
import 'package:flutter/material.dart';
import './view_model.dart';

Widget buildForm({
  required BuildContext context,
  required ViewModel viewModel,
}) {
  return Form(
    key: viewModel.formKey,
    child: Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Nombre',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo requerido';
            }
            return null;
          },
          onSaved: (value) => viewModel.name = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo requerido';
            }
            return null;
          },
          onSaved: (value) => viewModel.email = value,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            if (viewModel.formKey.currentState!.validate()) {
              viewModel.formKey.currentState!.save();
              await viewModel.submit();
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}
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

## Checklist de Revisión

Antes de finalizar un módulo, verifica:

- [ ] El archivo `main.dart` tiene menos de 40 líneas
- [ ] Todos los archivos genéricos usan nombres estándar
- [ ] Las funciones tienen nombres genéricos (`getSearchConfig`, `buildList`, etc.)
- [ ] El `ViewModel` extiende `ChangeNotifier`
- [ ] Todos los setters del `ViewModel` llaman `notifyListeners()`
- [ ] El context se pasa como parámetro, no se almacena
- [ ] Los archivos específicos tienen nombres descriptivos (`user_item.dart`, `product_item.dart`)
- [ ] Los imports están organizados (externos, internos, locales)
- [ ] No hay código comentado innecesario
- [ ] Cada archivo tiene una única responsabilidad

## Ejemplo Completo de Módulo

Ver la implementación completa en:
```
/pages/User/read/
  ├── main.dart
  ├── view_model.dart
  ├── search_config.dart
  ├── list_builder.dart
  └── user_item.dart        # Widget del item (Card, ListTile, Container, etc.)
```

Esta es la implementación de referencia que debe seguirse para todos los nuevos módulos.

## Nota sobre Widgets de Items

El archivo `{item}_item.dart` puede contener cualquier tipo de widget según el diseño:
- **Card** - Para diseños tipo tarjeta con sombras
- **ListTile** - Para listas simples con leading/trailing
- **Container** - Para diseños completamente personalizados
- **GridTile** - Para diseños en cuadrícula
- O cualquier composición de widgets que necesites

Lo importante es mantener el patrón de nombres genéricos en los archivos auxiliares.
