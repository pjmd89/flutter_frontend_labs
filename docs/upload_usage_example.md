# Guía de Uso: Sistema de Upload de Archivos

## Descripción

El sistema de upload permite subir archivos al servidor mediante GraphQL, con soporte para:
- ✅ Validación de extensiones (pdf, jpeg, jpg, png, xlsx)
- ✅ Carga en fragmentos para archivos grandes (6MB por fragmento)
- ✅ Nombres únicos de archivos con UUID
- ✅ Integración con agile_front framework

## Archivos del Sistema

### Dominio
- **Mutation**: `/src/domain/operation/mutations/upload/upload_mutation.dart`
- **UseCase**: `/src/domain/usecases/upload/upload_usecase.dart`
- **Input**: `/src/domain/entities/types/upload/inputs/uploadfile_input.dart`
- **Model**: `/src/domain/entities/types/upload/upload_model.dart`

## Ejemplo de Uso: Subir Logo de Compañía

### 1. En el ViewModel

```dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:agile_front/agile_front.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/usecases/upload/upload_usecase.dart';

class CompanyCreateViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _uploading = false;
  String? _logoPath;

  bool get uploading => _uploading;
  String? get logoPath => _logoPath;

  CompanyCreateViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
  }

  /// Sube el logo de la compañía
  Future<bool> uploadCompanyLogo({
    required Uint8List fileBytes,
    required String fileName,
    required String userId,
  }) async {
    _uploading = true;
    notifyListeners();

    try {
      // Crear UseCase
      final uploadUseCase = UploadFileUseCase(conn: _gqlConn);

      // Ejecutar upload
      final result = await uploadUseCase.uploadFile(
        fileOriginalName: fileName,
        fileDestinyName: 'company_logo',
        fileBytes: fileBytes,
        destinyDirectory: 'companies/logos',
        userId: userId,
        onlyXlsx: false, // Acepta cualquier formato válido
      );

      if (result.success && result.uploadedFile != null) {
        // Guardar path del archivo subido
        _logoPath = result.uploadedFile!['folder'] + '/' + result.uploadedFile!['name'];
        
        debugPrint('✅ Logo subido exitosamente: $_logoPath');
        return true;
      } else {
        // Manejar error según el código
        String errorMessage;
        switch (result.code) {
          case UploadFileUseCase.codeNoExtension:
            errorMessage = 'El archivo no tiene extensión';
            break;
          case UploadFileUseCase.codeInvalidExtension:
            errorMessage = 'Extensión de archivo no válida. Use: pdf, jpeg, jpg, png, xlsx';
            break;
          case UploadFileUseCase.codeUploadError:
            errorMessage = 'Error al subir el archivo';
            break;
          default:
            errorMessage = 'Error desconocido';
        }
        
        debugPrint('❌ Error al subir logo: $errorMessage');
        
        // Mostrar error al usuario
        _context.read<GQLNotifier>().errorService.showError(
          message: errorMessage,
        );
        
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al subir logo: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al subir logo: ${e.toString()}',
      );
      
      return false;
    } finally {
      _uploading = false;
      notifyListeners();
    }
  }
}
```

### 2. En la UI (Flutter Web)

```dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Agregar al pubspec.yaml

class CompanyLogoUploadWidget extends StatelessWidget {
  final CompanyCreateViewModel viewModel;

  const CompanyLogoUploadWidget({
    super.key,
    required this.viewModel,
  });

  Future<void> _pickAndUploadLogo(BuildContext context) async {
    // Seleccionar archivo
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final fileBytes = file.bytes;
      final fileName = file.name;

      if (fileBytes != null) {
        // Obtener userId (ejemplo, ajustar según tu auth)
        final userId = '123'; // TODO: Obtener del auth provider

        // Subir archivo
        final success = await viewModel.uploadCompanyLogo(
          fileBytes: fileBytes,
          fileName: fileName,
          userId: userId,
        );

        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logo subido exitosamente')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.logoPath != null) ...[
              Text('Logo: ${viewModel.logoPath}'),
              const SizedBox(height: 8),
            ],
            ElevatedButton.icon(
              onPressed: viewModel.uploading
                  ? null
                  : () => _pickAndUploadLogo(context),
              icon: viewModel.uploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(
                viewModel.uploading ? 'Subiendo...' : 'Subir Logo',
              ),
            ),
          ],
        );
      },
    );
  }
}
```

### 3. Ejemplo con solo archivos XLSX

```dart
Future<bool> uploadExcelFile({
  required Uint8List fileBytes,
  required String fileName,
  required String userId,
}) async {
  final uploadUseCase = UploadFileUseCase(conn: _gqlConn);

  final result = await uploadUseCase.uploadFile(
    fileOriginalName: fileName,
    fileDestinyName: 'patient_import',
    fileBytes: fileBytes,
    destinyDirectory: 'imports',
    userId: userId,
    onlyXlsx: true, // ⚠️ Solo acepta .xlsx
  );

  return result.success;
}
```

## Configuración del Backend

El backend debe tener esta mutation GraphQL:

```graphql
type Mutation {
  upload(input: UploadFileInput!): UploadResult!
}

input UploadFileInput {
  name: String!
  size: Int!
  type: String!
  folder: String!
  file: String!        # Base64 fragment
  sizeUploaded: Int!
}

type UploadResult {
  name: String!
  size: Int!
  type: String!
  folder: String!
  sizeUploaded: Int!
}
```

## Extensiones Válidas

- `pdf` → `application/pdf`
- `jpeg` / `jpg` → `image/jpeg`
- `png` → `image/png`
- `xlsx` → `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`

## Códigos de Resultado

```dart
UploadFileUseCase.codeOk                // ✅ Subida exitosa
UploadFileUseCase.codeNoExtension       // ❌ Archivo sin extensión
UploadFileUseCase.codeInvalidExtension  // ❌ Extensión no válida
UploadFileUseCase.codeUploadError       // ❌ Error en el servidor
```

## Características Técnicas

### Carga en Fragmentos
- Tamaño de fragmento: **6MB** (`byteInterval = 1024 * 1024 * 6`)
- Método recursivo para archivos grandes
- Trackeo de `sizeUploaded` en cada fragmento

### Nombres Únicos
- Formato: `{userId}_{uuid}_{destinyName}.{extension}`
- Ejemplo: `123_a1b2c3d4-e5f6-7890-abcd-ef1234567890_company_logo.png`

### Seguridad
- Validación de extensiones en cliente y servidor
- UUID para evitar colisiones de nombres
- Carpetas organizadas por tipo de contenido

## Dependencias Requeridas

```yaml
# pubspec.yaml
dependencies:
  uuid: ^4.5.1          # Para nombres únicos ✅
  file_picker: ^8.0.0   # Para seleccionar archivos (opcional)
```

## Errores Comunes

### 1. "Extensión no válida"
**Solución**: Verificar que el archivo tenga una de las extensiones permitidas.

### 2. "Error al subir archivo"
**Solución**: Verificar que el backend esté corriendo y tenga la mutation `upload`.

### 3. "Archivo muy grande"
**Solución**: El sistema divide automáticamente en fragmentos de 6MB, pero verifica límites del backend.

## Testing

```dart
// Ejemplo de test
test('Upload file with valid extension', () async {
  final useCase = UploadFileUseCase(conn: mockGqlConn);
  
  final result = await useCase.uploadFile(
    fileOriginalName: 'test.png',
    fileDestinyName: 'test',
    fileBytes: Uint8List.fromList([1, 2, 3]),
    destinyDirectory: 'test',
    userId: '123',
  );
  
  expect(result.success, true);
  expect(result.code, UploadFileUseCase.codeOk);
});
```

## Siguientes Pasos

1. Implementar el backend GraphQL con la mutation `upload`
2. Agregar `file_picker` al pubspec si necesitas selección de archivos
3. Usar el UseCase en tus páginas de creación/edición
4. Guardar el `logoPath` en el input de Company/User

## Soporte

Para más información, consulta:
- [Patrón CREATE](./create_pattern.chatmode.md)
- [agile_front README](../readme_agile_front.md)
