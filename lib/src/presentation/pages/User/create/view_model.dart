import 'dart:typed_data';
import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import '/src/domain/entities/main.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/createUser/createuser_mutation.dart';
import '/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import '/src/domain/usecases/User/create_user_usecase.dart';
import '/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import '/src/domain/usecases/upload/upload_usecase.dart';
import '/src/domain/extensions/edgelaboratory_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';
import '/l10n/app_localizations.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  bool _loadingLaboratories = false;
  bool _uploading = false;
  List<Laboratory> _laboratories = [];

  final CreateUserInput input = CreateUserInput();
  
  String? _uploadedLogoPath;
  String? _originalFileName;
  Uint8List? _logoImageBytes;

  List<Laboratory> get laboratories => _laboratories;
  bool get loadingLaboratories => _loadingLaboratories;

  bool get loading => _loading;
  bool get uploading => _uploading;
  String? get uploadedLogoPath => _uploadedLogoPath;
  Uint8List? get logoImageBytes => _logoImageBytes;
  
  // Getter para saber si hay un logo
  bool get hasLogo => _logoImageBytes != null;
  
  // Getter para mostrar el nombre del archivo en el campo
  String? get displayFileName => _originalFileName;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set uploading(bool newUploading) {
    _uploading = newUploading;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    _loadLaboratories();
  }

  Future<void> _loadLaboratories() async {
    _loadingLaboratories = true;
    notifyListeners();

    try {
      debugPrint('🔍 Iniciando carga de laboratorios...');
      
      ReadLaboratoryUsecase readLaboratoryUsecase = ReadLaboratoryUsecase(
        operation: GetLaboratoriesQuery(
          builder: EdgeLaboratoryFieldsBuilder().defaultValues(),
        ),
        conn: _gqlConn,
      );

      debugPrint('🚀 Ejecutando readWithoutPaginate...');
      var response = await readLaboratoryUsecase.readWithoutPaginate();
      
      debugPrint('📦 Respuesta recibida: ${response.runtimeType}');
      
      if (response is EdgeLaboratory) {
        debugPrint('✅ EdgeLaboratory detectado');
        _laboratories = response.edges;
        debugPrint('📊 Número de laboratorios: ${_laboratories.length}');
      } else {
        debugPrint('❌ Respuesta no es EdgeLaboratory');
        _laboratories = [];
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al cargar laboratorios: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      _laboratories = [];
      
      _errorService.showError(
        message: 'Error al cargar laboratorios: ${e.toString()}',
        type: ErrorType.error,
      );
    } finally {
      _loadingLaboratories = false;
      debugPrint('🏁 Carga de laboratorios finalizada. Total: ${_laboratories.length}');
      notifyListeners();
    }
  }

  Future<bool> create() async {
    bool isError = true;
    loading = true;

    CreateUserUsecase useCase = CreateUserUsecase(
      operation: CreateUserMutation(builder: UserFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      // Limpiar campos opcionales vacíos antes de enviar
      // laboratoryID se mantiene si fue seleccionado para técnico o facturación
      if (input.laboratoryID == null || input.laboratoryID!.isEmpty) {
        input.laboratoryID = null;
      }

      // Si cutOffDate está vacío, nulificarlo
      if (input.cutOffDate == null || input.cutOffDate!.isEmpty) {
        input.cutOffDate = null;
      }

      // Si fee está vacío, nulificarlo
      if (input.fee == null || input.fee == 0) {
        input.fee = null;
      }

      // Si companyInfo existe, limpiar sus campos opcionales vacíos
      if (input.companyInfo != null) {
        // Limpiar logo si está vacío
        if (input.companyInfo!.logo == null ||
            input.companyInfo!.logo!.isEmpty) {
          input.companyInfo!.logo = null;
        }

        // Limpiar companyID del laboratoryInfo (se asigna automáticamente)
        input.companyInfo!.laboratoryInfo.companyID = null;
      }

      var response = await useCase.execute(input: input);

      if (response is User) {
        isError = false;

        // Mostrar mensaje de éxito
        final l10n = AppLocalizations.of(_context)!;
        _errorService.showError(
          message: l10n.thingCreatedSuccessfully(l10n.user),
          type: ErrorType.success,
        );
      } else {
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en create user: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;

      // Mostrar error al usuario
      _errorService.showError(
        message: 'Error al crear usuario: ${e.toString()}',
      );
    } finally {
      loading = false;
    }

    return isError;
  }

  /// Sube el logo de la compañía
  Future<bool> uploadCompanyLogo({
    required Uint8List fileBytes,
    required String fileName,
    required String userId,
  }) async {
    uploading = true;

    try {
      final uploadUseCase = UploadFileUseCase(conn: _gqlConn);

      debugPrint('📤 Iniciando upload: $fileName, ${fileBytes.length} bytes');

      final result = await uploadUseCase.uploadFile(
        fileOriginalName: fileName,
        fileDestinyName: 'company_logo',
        fileBytes: fileBytes,
        destinyDirectory: 'companies/logos',
        userId: userId,
        onlyXlsx: false,
      );

      debugPrint('📦 Resultado upload - success: ${result.success}, code: ${result.code}');
      debugPrint('📦 uploadedFile: ${result.uploadedFile}');

      if (result.success && result.uploadedFile != null) {
        // Construir path del archivo subido
        _uploadedLogoPath = result.uploadedFile!['folder'] +
            '/' +
            result.uploadedFile!['name'];

        // Guardar nombre original del archivo
        _originalFileName = fileName;

        // Guardar bytes de la imagen para vista previa
        _logoImageBytes = fileBytes;

        // Actualizar input con el nuevo logo
        input.companyInfo ??= CreateCompanyInput();
        input.companyInfo!.logo = _uploadedLogoPath;

        debugPrint('✅ Logo subido exitosamente: $_uploadedLogoPath');

        final l10n = AppLocalizations.of(_context)!;
        _errorService.showError(
          message: '${l10n.logo} subido exitosamente',
          type: ErrorType.success,
        );

        return true;
      } else {
        String errorMessage;
        switch (result.code) {
          case UploadFileUseCase.codeNoExtension:
            errorMessage = 'El archivo no tiene extensión';
            break;
          case UploadFileUseCase.codeInvalidExtension:
            errorMessage =
                'Extensión no válida. Use: jpeg, jpg, png, gif';
            break;
          case UploadFileUseCase.codeUploadError:
            errorMessage = 'Error al subir el archivo';
            break;
          default:
            errorMessage = 'Error desconocido';
        }

        debugPrint('❌ Error al subir logo: $errorMessage');

        _errorService.showError(
          message: errorMessage,
        );

        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al subir logo: $e');
      debugPrint('📍 StackTrace: $stackTrace');

      _errorService.showError(
        message: 'Error al subir logo: ${e.toString()}',
      );

      return false;
    } finally {
      uploading = false;
    }
  }
}
