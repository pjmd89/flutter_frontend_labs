import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Importación condicional para web
import 'dart:html' as html show FileUploadInputElement, File, FileReader;

class CompanyUpdatePage extends StatefulWidget {
  const CompanyUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<CompanyUpdatePage> createState() => _CompanyUpdatePageState();
}

class _CompanyUpdatePageState extends State<CompanyUpdatePage> {
  late ViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers para campos editables
  late TextEditingController nameController;
  late TextEditingController logoController;
  late TextEditingController taxIDController;

  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, companyId: widget.id);

    // Escuchar cambios del ViewModel para inicializar controllers
    viewModel.addListener(_updateControllers);
  }

  void _updateControllers() {
    // Inicializar controllers cuando los datos se carguen
    if (viewModel.currentCompany != null &&
        !viewModel.loading &&
        !_controllersInitialized) {
      setState(() {
        nameController = TextEditingController(
          text: viewModel.currentCompany!.name,
        );
        logoController = TextEditingController(
          text: viewModel.currentCompany!.logo,
        );
        taxIDController = TextEditingController(
          text: viewModel.currentCompany!.taxID,
        );
        _controllersInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    viewModel.removeListener(_updateControllers);
    if (_controllersInitialized) {
      nameController.dispose();
      logoController.dispose();
      taxIDController.dispose();
    }
    super.dispose();
  }

  Future<void> _pickAndUploadLogo(BuildContext context) async {
    try {
      debugPrint('🔧 Iniciando selección de archivo... (kIsWeb: $kIsWeb)');
      
      if (kIsWeb) {
        // Implementación específica para web usando dart:html
        debugPrint('🌐 Usando implementación web nativa');
        
        final uploadInput = html.FileUploadInputElement();
        uploadInput.accept = 'image/jpeg,image/jpg,image/png,image/gif';
        uploadInput.click();

        await uploadInput.onChange.first;

        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();
          
          reader.readAsArrayBuffer(file);
          await reader.onLoad.first;

          final Uint8List fileBytes = reader.result as Uint8List;
          final String fileName = file.name;

          debugPrint('📄 Archivo web: $fileName, Bytes: ${fileBytes.length}');

          // Validar extensión
          final extension = fileName.split('.').last.toLowerCase();
          if (!['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Formato no válido. Usa JPG, JPEG, PNG o GIF')),
            );
            return;
          }

          // Subir archivo
          final success = await viewModel.uploadCompanyLogo(
            fileBytes: fileBytes,
            fileName: fileName,
            userId: 'company_update',
          );

          // Actualizar controller con el nuevo path
          if (success && viewModel.uploadedLogoPath != null) {
            setState(() {
              logoController.text = viewModel.uploadedLogoPath!;
            });
          }
        } else {
          debugPrint('ℹ️ Selección de archivo cancelada');
        }
      } else {
        // Para plataformas nativas (mobile/desktop) - no debería llegar aquí en web
        debugPrint('⚠️ Esta ruta solo funciona en web');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionalidad solo disponible en web')),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error al seleccionar archivo: $e');
      debugPrint('💥 Tipo de error: ${e.runtimeType}');
      debugPrint('📍 StackTrace: $stackTrace');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
        if (!_controllersInitialized || viewModel.currentCompany == null) {
          return ContentDialog(
            icon: Icons.business,
            title: l10n.updateThing(l10n.company),
            loading: true,
            form: Form(child: const Center(child: CircularProgressIndicator())),
            actions: [],
          );
        }

        // Formulario con datos prellenados
        return ContentDialog(
          icon: Icons.business,
          title: l10n.updateThing(l10n.company),
          loading: viewModel.loading,
          maxWidth: 600,
          form: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nombre de la empresa
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

                  // Logo URL
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: l10n.logo,
                          controller: logoController,
                          isDense: true,
                          fieldLength: FormFieldLength.email,
                          counterText: "",
                          readOnly: true,
                          onTap: viewModel.uploading
                              ? null
                              : () => _pickAndUploadLogo(context),
                          suffixIcon: viewModel.uploading
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.upload_file),
                          onChange: (value) {
                            viewModel.input.logo = value;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: FilledButton.icon(
                          onPressed:
                              viewModel.uploading
                                  ? null
                                  : () => _pickAndUploadLogo(context),
                          icon: viewModel.uploading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.upload_file),
                          label: Text(
                            viewModel.uploading
                                ? 'Subiendo...'
                                : 'Subir',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (viewModel.uploadedLogoPath != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Logo subido: ${viewModel.uploadedLogoPath}',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Tax ID
                  CustomTextFormField(
                    labelText: l10n.taxID,
                    controller: taxIDController,
                    isDense: true,
                    fieldLength: FormFieldLength.name,
                    counterText: "",
                    onChange: (value) {
                      viewModel.input.taxID = value;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campos de solo lectura (no están en UpdateCompanyInput)
                  if (viewModel.currentCompany!.owner != null) ...[
                    Card(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceVariant.withOpacity(0.3),
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
                              l10n.owner,
                              '${viewModel.currentCompany!.owner!.firstName} ${viewModel.currentCompany!.owner!.lastName}',
                            ),
                            const SizedBox(height: 8),
                            _buildReadOnlyField(
                              'Fecha de creación',
                              DateTime.fromMillisecondsSinceEpoch(
                                viewModel.currentCompany!.created.toInt(),
                              ).toString().split('.')[0],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                  onPressed:
                      viewModel.loading
                          ? null
                          : () async {
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
