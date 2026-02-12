import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';
import './view_model.dart';

/// Laboratory Switcher - Similar al selector de cuentas de Google
/// Muestra el laboratorio actual y permite cambiar entre laboratorios disponibles
class LaboratorySwitcher extends StatefulWidget {
  const LaboratorySwitcher({super.key});

  @override
  State<LaboratorySwitcher> createState() => _LaboratorySwitcherState();
}

class _LaboratorySwitcherState extends State<LaboratorySwitcher> {
  late LaboratorySwitcherViewModel viewModel;
  late LaboratoryNotifier _laboratoryNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = LaboratorySwitcherViewModel(context: context);
    _laboratoryNotifier = context.read<LaboratoryNotifier>();
    
    // Escuchar cambios en el LaboratoryNotifier para recargar lista
    _laboratoryNotifier.addListener(_onLaboratoryChanged);
  }

  @override
  void dispose() {
    _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    super.dispose();
  }

  /// Callback cuando cambia el laboratorio (incluyendo cuando se crea uno nuevo)
  void _onLaboratoryChanged() {
    // Recargar la lista de laboratorios disponibles
    viewModel.getLaboratories();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final laboratoryNotifier = context.watch<LaboratoryNotifier>();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return PopupMenuButton<Laboratory>(
          tooltip: l10n.selectLaboratory,
          offset: const Offset(0, 50),
          constraints: const BoxConstraints(
            minWidth: 280,
            maxWidth: 340,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // Widget que se muestra en el AppBar (compacto)
          child: _buildCurrentLabWidget(
            context,
            laboratoryNotifier,
            theme,
          ),
          // Items del menú desplegable
          itemBuilder: (context) => _buildMenuItems(
            context,
            laboratoryNotifier,
            l10n,
            theme,
          ),
          onSelected: (laboratory) async {
            await laboratoryNotifier.selectLaboratory(laboratory, context);
          },
        );
      },
    );
  }

  /// Widget compacto que muestra el laboratorio actual
  /// Similar al chip de cuenta de Google
  Widget _buildCurrentLabWidget(
    BuildContext context,
    LaboratoryNotifier laboratoryNotifier,
    ThemeData theme,
  ) {
    final hasLab = laboratoryNotifier.hasLaboratory;
    final labName = laboratoryNotifier.selectedLaboratory?.company?.name;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: hasLab
                  ? theme.colorScheme.primaryContainer.withOpacity(0.5)
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasLab
                    ? theme.colorScheme.primary.withOpacity(0.3)
                    : theme.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar/Icono del laboratorio
                CircleAvatar(
                  radius: 14,
                  backgroundColor: hasLab
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  child: Icon(
                    Icons.science,
                    size: 16,
                    color: hasLab
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                if (labName != null) ...[
                  const SizedBox(width: 8),
                  // Nombre del laboratorio (máximo 20 caracteres)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: Text(
                      labName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const SizedBox(width: 4),
                // Icono dropdown
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construir items del menú desplegable
  List<PopupMenuEntry<Laboratory>> _buildMenuItems(
    BuildContext context,
    LaboratoryNotifier laboratoryNotifier,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final items = <PopupMenuEntry<Laboratory>>[];

    // Header del menú
    items.add(
      PopupMenuItem<Laboratory>(
        enabled: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.science_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.laboratories,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );

    // Estados: Loading, Error, Empty, Success
    if (viewModel.loading) {
      items.add(
        PopupMenuItem<Laboratory>(
          enabled: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.loading,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (viewModel.error) {
      items.add(
        PopupMenuItem<Laboratory>(
          enabled: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: theme.colorScheme.error),
                const SizedBox(width: 8),
                Text(
                  l10n.errorLoadingData,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (viewModel.laboratoryList == null ||
        viewModel.laboratoryList!.isEmpty) {
      items.add(
        PopupMenuItem<Laboratory>(
          enabled: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.noRegisteredMaleThings(l10n.laboratories),
              style: TextStyle(color: theme.colorScheme.outline),
            ),
          ),
        ),
      );
    } else {
      // Lista de laboratorios
      for (final laboratory in viewModel.laboratoryList!) {
        final isSelected =
            laboratoryNotifier.selectedLaboratory?.id == laboratory.id;

        items.add(
          PopupMenuItem<Laboratory>(
            value: laboratory,
            child: _buildLaboratoryMenuItem(
              laboratory,
              isSelected,
              theme,
            ),
          ),
        );
      }
    }

    return items;
  }

  /// Widget de cada laboratorio en el menú
  Widget _buildLaboratoryMenuItem(
    Laboratory laboratory,
    bool isSelected,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Avatar del laboratorio
          CircleAvatar(
            radius: 20,
            backgroundColor: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.secondaryContainer,
            child: Icon(
              Icons.science,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          // Información del laboratorio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  laboratory.company?.name ?? 'Sin nombre',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.primary : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (laboratory.address.isNotEmpty)
                  Text(
                    laboratory.address,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // Check de selección
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
              size: 20,
            ),
        ],
      ),
    );
  }
}
