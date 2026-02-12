import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import 'package:labs/src/presentation/core/ui/main.dart';
import './view_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Importación para web (package:web reemplaza dart:html)
import 'package:web/web.dart' show HTMLInputElement, FileReader;
import 'dart:js_interop';

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
      viewModel = ViewModel(context: context, companyId: widget.id);
      viewModel.addListener(_updateControllers);
      _viewModelInitialized = true;
    } else if (_controllersInitialized) {
      // Si el ViewModel ya está inicializado y los controllers también,
      // forzar actualización cuando cambie el idioma
      setState(() {
        // Actualizar logoController porque displayFileName usa l10n
        logoController.text = viewModel.displayFileName ?? '';
      });
    }
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
          text: viewModel.displayFileName ?? '',
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

  Future<void> _pickAndUploadLogo(BuildContext context) async {
    try {
      debugPrint('🔧 Iniciando selección de archivo... (kIsWeb: $kIsWeb)');
      
      if (kIsWeb) {
        // Implementación específica para web usando package:web
        debugPrint('🌐 Usando implementación web nativa');
        
        final uploadInput = HTMLInputElement();
        uploadInput.type = 'file';
        uploadInput.accept = 'image/jpeg,image/jpg,image/png,image/gif';
        uploadInput.click();

        // Esperar a que se seleccione un archivo
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Usar completer para manejar el evento de cambio
        final completer = Completer<void>();
        uploadInput.addEventListener('change', ((JSAny event) {
          completer.complete();
        }).toJS);
        
        await completer.future;

        final files = uploadInput.files;
        if (files != null && files.length > 0) {
          final file = files.item(0)!;
          final reader = FileReader();
          
          // Usar completer para el evento onload
          final loadCompleter = Completer<void>();
          reader.addEventListener('load', ((JSAny event) {
            loadCompleter.complete();
          }).toJS);
          
          reader.readAsArrayBuffer(file);
          await loadCompleter.future;

          final result = reader.result;
          final Uint8List fileBytes = (result as JSArrayBuffer).toDart.asUint8List();
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

          // Actualizar controller con el nombre original del archivo
          if (success && viewModel.displayFileName != null) {
            setState(() {
              logoController.text = viewModel.displayFileName!;
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

                  // Botón para cambiar logo
                  Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          viewModel.hasLogo
                              ? viewModel.displayFileName ?? ''
                              : l10n.logo,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: viewModel.hasLogo ? FontWeight.normal : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: viewModel.uploading
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
                            : const Icon(Icons.upload_file, size: 18),
                        label: Text(
                          viewModel.uploading
                              ? l10n.uploading
                              : (viewModel.hasLogo ? l10n.changeLogo : l10n.upload),
                        ),
                      ),
                    ],
                  ),
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
                      ).colorScheme.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.nonEditableInformation,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 12),
                            _buildReadOnlyField(
                              l10n.owner,
                              '${viewModel.currentCompany!.owner!.firstName} ${viewModel.currentCompany!.owner!.lastName}',
                            ),
                            const SizedBox(height: 8),
                            _buildReadOnlyField(
                              l10n.creationDate,
                              formatTimestamp(viewModel.currentCompany!.created),
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
