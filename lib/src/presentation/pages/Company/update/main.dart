import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
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

  Future<void> _handleSave() async {
    if (formKey.currentState!.validate()) {
      final isErr = await viewModel.update();
      if (!isErr && context.mounted) {
        context.pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(l10n.updateThing(l10n.company)),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          // Mostrar error si ocurrió
          if (viewModel.error && !viewModel.loading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.somethingWentWrong,
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.pop(false),
                    child: Text(l10n.cancel),
                  ),
                ],
              ),
            );
          }

          // Mostrar loading mientras carga datos iniciales
          if (!_controllersInitialized || viewModel.currentCompany == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Formulario con datos prellenados
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 9,
                              child: _buildMainForm(
                                  l10n, colorScheme, textTheme)),
                          const SizedBox(width: 24),
                          Expanded(
                              flex: 5,
                              child: _buildSidePanel(
                                  l10n, colorScheme, textTheme)),
                        ],
                      )
                    : Column(
                        children: [
                          _buildMainForm(l10n, colorScheme, textTheme),
                          const SizedBox(height: 24),
                          _buildSidePanel(l10n, colorScheme, textTheme),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainForm(
      AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.companyInformation,
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l10n.updateCompanyData, style: textTheme.bodyMedium),
              const Divider(height: 48),

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
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      viewModel.hasLogo
                          ? viewModel.displayFileName ?? ''
                          : l10n.logo,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight:
                            viewModel.hasLogo ? FontWeight.normal : FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidePanel(
      AppLocalizations l10n, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        Card(
          elevation: 0,
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.referenceData,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                if (viewModel.currentCompany!.owner != null) ...[
                  _readOnlyInfo(
                    l10n.owner,
                    '${viewModel.currentCompany!.owner!.firstName} ${viewModel.currentCompany!.owner!.lastName}',
                    textTheme,
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                ],
                _readOnlyInfo(
                  l10n.creationDate,
                  formatTimestamp(viewModel.currentCompany!.created),
                  textTheme,
                  Icons.calendar_today_outlined,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Botones de acción
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Botón Cancelar
              OutlinedButton(
                onPressed: () => context.pop(),
                child: Text(l10n.cancel),
              ),

              const SizedBox(width: 12),

              // Botón Guardar o Loader
              viewModel.loading
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: _handleSave,
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: Text(l10n.save),
                    ),
            ],
          ),
        )
      ],
    );
  }

  Widget _readOnlyInfo(
      String label, String value, TextTheme textTheme, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: textTheme.bodySmall?.color?.withOpacity(0.6)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: textTheme.labelMedium
                      ?.copyWith(color: textTheme.bodySmall?.color)),
              Text(value,
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
