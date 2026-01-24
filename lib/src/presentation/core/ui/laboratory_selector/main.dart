import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';
import './view_model.dart';

class LaboratorySelectorDialog extends StatefulWidget {
  const LaboratorySelectorDialog({super.key});

  @override
  State<LaboratorySelectorDialog> createState() =>
      _LaboratorySelectorDialogState();
}

class _LaboratorySelectorDialogState extends State<LaboratorySelectorDialog> {
  late LaboratorySelectorViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = LaboratorySelectorViewModel(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.science_outlined,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.selectLaboratory,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: _buildContent(context, l10n, theme),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    // Estado: Cargando
    if (viewModel.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Estado: Error
    if (viewModel.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadingData,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ),
        ),
      );
    }

    // Estado: Sin laboratorios
    if (viewModel.laboratoryList == null ||
        viewModel.laboratoryList!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.science_outlined,
                size: 48,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noRegisteredMaleThings(l10n.laboratories),
                style: TextStyle(color: theme.colorScheme.outline),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Estado: Con laboratorios
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.laboratoryList!.length,
      itemBuilder: (context, index) {
        final laboratory = viewModel.laboratoryList![index];
        return _buildLaboratoryCard(context, laboratory, l10n, theme);
      },
    );
  }

  Widget _buildLaboratoryCard(
    BuildContext context,
    Laboratory laboratory,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final laboratoryNotifier = context.watch<LaboratoryNotifier>();
    final isSelected =
        laboratoryNotifier.selectedLaboratory?.id == laboratory.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await laboratoryNotifier.selectLaboratory(laboratory, context);
          if (context.mounted) {
            context.pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.science,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 16),

              // Información del laboratorio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      laboratory.company?.name ?? l10n.noDataAvailable,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (laboratory.address.isNotEmpty)
                      Text(
                        '${l10n.address}: ${laboratory.address}',
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (laboratory.contactPhoneNumbers.isNotEmpty)
                      Text(
                        '${l10n.phoneNumber}: ${laboratory.contactPhoneNumbers.first}',
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),

              // Check mark si está seleccionado
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
