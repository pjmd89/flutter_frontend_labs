# Implementación de Upload de Logo para Company

## ✅ Completado

Se ha integrado exitosamente el sistema de upload de archivos en el módulo de actualización de Company.

## 📦 Dependencias Agregadas

```yaml
# pubspec.yaml
dependencies:
  uuid: ^4.5.1          # ✅ Para nombres únicos de archivos
  file_picker: ^8.0.0   # ✅ Para seleccionar archivos desde el navegador
```

## 🔧 Archivos Modificados

### 1. ViewModel de Company Update
**Archivo:** `/src/presentation/pages/Company/update/view_model.dart`

**Cambios:**
- ✅ Importado `dart:typed_data` para manejo de bytes
- ✅ Importado `UploadFileUseCase` para funcionalidad de upload
- ✅ Agregado estado `_uploading` con getter/setter
- ✅ Agregado `_uploadedLogoPath` para trackear el logo subido
- ✅ Implementado método `uploadCompanyLogo()` con:
  - Validación de extensiones (pdf, jpeg, jpg, png, xlsx)
  - Carga en fragmentos de 6MB
  - Nombres únicos con UUID
  - Manejo de errores completo
  - Feedback al usuario con ErrorService
  - Actualización automática del input con el nuevo path

### 2. UI de Company Update
**Archivo:** `/src/presentation/pages/Company/update/main.dart`

**Cambios:**
- ✅ Importado `file_picker` y `dart:typed_data`
- ✅ Agregado botón "Subir" junto al campo de Logo
- ✅ Indicador de progreso durante la carga (CircularProgressIndicator)
- ✅ Mensaje de confirmación cuando el logo se sube exitosamente
- ✅ Método `_pickAndUploadLogo()` para manejar:
  - Selección de archivo de imagen
  - Llamada al ViewModel para subir
  - Actualización del TextEditingController con el nuevo path
  - Manejo de errores

## 🎨 Características de la UI

### Campo de Logo Mejorado
```dart
Row(
  children: [
    Expanded(
      child: CustomTextFormField(
        labelText: l10n.logo,
        controller: logoController,
        // ... campo para editar URL manualmente
      ),
    ),
    FilledButton.icon(
      onPressed: _pickAndUploadLogo,
      icon: viewModel.uploading 
          ? CircularProgressIndicator() 
          : Icon(Icons.upload_file),
      label: Text(viewModel.uploading ? 'Subiendo...' : 'Subir'),
    ),
  ],
)
```

### Mensaje de Confirmación
Cuando el logo se sube exitosamente, aparece un contenedor verde con:
- ✅ Ícono de check
- 📂 Path completo del archivo subido
- 🎨 Colores del tema (primaryContainer)

## 📝 Flujo de Uso

### Para el Usuario Final:

1. **Abrir Edición de Company** → Se carga el formulario con datos existentes
2. **Click en "Subir"** → Se abre el selector de archivos
3. **Seleccionar Imagen** → Solo imágenes (png, jpg, jpeg)
4. **Esperar** → Indicador de progreso mientras sube
5. **Confirmación** → Mensaje verde con el path del archivo
6. **Guardar** → El nuevo logo se guarda al hacer "Update"

### Ventajas:

- ✅ **No necesita escribir URLs** - Sube directamente desde su computadora
- ✅ **Validación automática** - Solo acepta formatos válidos
- ✅ **Nombres únicos** - No hay colisiones de archivos
- ✅ **Feedback visual** - Sabe exactamente cuándo termina
- ✅ **Organizado** - Los logos se guardan en `companies/logos/`

## 🔍 Ejemplo de Nombres Generados

```
companies/logos/company_update_a1b2c3d4-e5f6-7890-abcd-ef1234567890_company_logo.png
```

**Formato:** `{carpeta}/{userId}_{uuid}_{nombre}.{ext}`

## 🧪 Para Probar

1. Ejecutar la aplicación
2. Ir a la página de Companies
3. Seleccionar una empresa para editar
4. En el campo "Logo", hacer click en "Subir"
5. Seleccionar una imagen (png, jpg, jpeg)
6. Verificar que aparece el mensaje de confirmación
7. Guardar los cambios
8. Verificar que el logo se actualiza correctamente

## 📚 Documentación Relacionada

- [Guía Completa de Upload](/docs/upload_usage_example.md)
- [CREATE Pattern](./create_pattern.chatmode.md) - Para implementar en otros módulos

## 🚀 Próximos Pasos (Opcional)

Si deseas implementar upload en otros módulos:

1. **User/create** - Para foto de perfil
2. **Laboratory/create** - Para logo del laboratorio
3. **Patient/create** - Para documentos del paciente

El patrón es el mismo, solo necesitas:
- Importar `UploadFileUseCase`
- Agregar método `uploadXXX()` en el ViewModel
- Agregar botón de upload en la UI
- Actualizar el campo correspondiente en el Input
