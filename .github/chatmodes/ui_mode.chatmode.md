# Modo UI/UX - Modificación de Entorno Gráfico

Este chatmode está diseñado exclusivamente para tareas relacionadas con la **interfaz de usuario (UI)** y la **experiencia de usuario (UX)**.

**Objetivo:** Mejorar, corregir o modificar la apariencia visual y la interacción del usuario sin alterar la lógica de negocio subyacente.

## ⚠️ REGLA DE ORO: NO TOCAR LÓGICA DE NEGOCIO

**ESTRICTAMENTE PROHIBIDO MODIFICAR:**
- ❌ Archivos `view_model.dart`
- ❌ Casos de uso (`usecases/`)
- ❌ Entidades y Modelos (`entities/`)
- ❌ Operaciones GraphQL (`mutations/`, `queries/`)
- ❌ Repositorios o Servicios de Infraestructura

**SI SE REQUIERE CAMBIAR LÓGICA:**
- Cambiar al modo correspondiente (CREATE, READ, UPDATE, etc.) o solicitar al usuario que cambie de contexto.

## Alcance Permitido

Este modo se centra en la capa de **Presentación**:

### 1. Widgets y Páginas (`/pages/{Feature}/*/main.dart`)
- Modificar estructura de widgets (Column, Row, Stack).
- Ajustar propiedades visuales (color, padding, margin, decoration).
- Cambiar textos (usando l10n).
- Reorganizar elementos en pantalla.

### 2. Componentes de Items (`*_item.dart`)
- Rediseñar tarjetas (Cards), listas (ListTiles) o grids.
- Ajustar visualización de datos (formatos de fecha, moneda, etc. *en la vista*).
- Añadir indicadores visuales (iconos, badges).

### 3. Builders y Configuración UI
- `list_builder.dart`: Cambiar cómo se muestran los estados (loading, error, empty).
- `search_config.dart`: Ajustar campos de búsqueda visuales o botones de acción.

### 4. Temas y Estilos
- Modificar `ThemeData`.
- Ajustar colores, tipografías y formas globales.
- Implementar modo oscuro/claro.

### 5. Internacionalización (`l10n/`)
- Agregar o modificar traducciones en `.arb`.
- Asegurar que no existan strings hardcodeados.

## Guías de Estilo UI

### Consistencia
- Usar `Theme.of(context)` para colores y estilos de texto.
- No hardcodear colores (ej: `Colors.red`), usar `ColorScheme` (ej: `Theme.of(context).colorScheme.error`).
- Mantener espaciados consistentes (multiplos de 4 o 8).

### Responsividad
- Usar `Wrap`, `Flex`, o `LayoutBuilder` para adaptarse a diferentes tamaños de pantalla.
- En listas tipo grid, usar `ConstrainedBox` para limitar el ancho máximo de las tarjetas (ej: `maxWidth: 360`).

### Feedback Visual
- Asegurar que los estados de carga y error sean visibles y claros.
- Usar `SnackBar` para notificaciones (a través de `ErrorService` si es necesario, pero solo la invocación).

## Ejemplo de Modificación Permitida

**Solicitud:** "Cambiar el color del botón de guardar a verde y ponerlo a la izquierda."

**✅ CAMBIO CORRECTO (`main.dart`):**
```dart
// Antes
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FilledButton(onPressed: save, child: Text('Guardar')),
  ],
)

// Después
Row(
  mainAxisAlignment: MainAxisAlignment.start, // Cambio de posición
  children: [
    FilledButton(
      style: FilledButton.styleFrom(backgroundColor: Colors.green), // Cambio de estilo
      onPressed: save, 
      child: Text('Guardar')
    ),
  ],
)
```

**❌ CAMBIO INCORRECTO (`view_model.dart`):**
- Modificar la función `save()` para que haga algo diferente.
- Cambiar cómo se procesan los datos antes de guardar.

## Checklist para Modo UI

- [ ] ¿El cambio afecta solo a la apariencia o disposición?
- [ ] ¿He evitado modificar archivos de lógica (`view_model.dart`, `usecases`)?
- [ ] ¿Estoy usando `AppLocalizations` para nuevos textos?
- [ ] ¿El diseño es consistente con el resto de la aplicación?
- [ ] ¿He verificado la responsividad?