import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/core/ui/content_dialog/content_dialog.dart';
import './view_model.dart';

class UserLaboratoriesPage extends StatefulWidget {
  const UserLaboratoriesPage({super.key, required this.userId});
  final String userId;

  @override
  State<UserLaboratoriesPage> createState() => _UserLaboratoriesPageState();
}

class _UserLaboratoriesPageState extends State<UserLaboratoriesPage> {
  late ViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, userId: widget.userId);
    viewModel.loadLaboratories();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ContentDialog(
          icon: Icons.science_outlined,
          title: l10n.viewLaboratories,
          loading: viewModel.loading,
          form: Form(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.error)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          l10n.errorLoadingData,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    )
                  else if (viewModel.laboratoryList == null || viewModel.laboratoryList!.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(l10n.noRegisteredMaleThings('Laboratorios')),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.laboratoryList!.length,
                      itemBuilder: (context, index) {
                        final laboratory = viewModel.laboratoryList![index];
                        return _buildLaboratoryCard(context, laboratory, l10n);
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLaboratoryCard(BuildContext context, Laboratory laboratory, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.science),
        title: Text(laboratory.company?.name ?? 'Sin nombre'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (laboratory.address.isNotEmpty)
              Text('${l10n.address}: ${laboratory.address}'),
            if (laboratory.contactPhoneNumbers.isNotEmpty)
              Text('${l10n.phoneNumber}: ${laboratory.contactPhoneNumbers.first}'),
            if (laboratory.company?.owner != null)
              Text('${l10n.owner}: ${laboratory.company?.owner?.firstName ?? ''} ${laboratory.company?.owner?.lastName ?? ''}'),
          ],
        ),
      ),
    );
  }
}
    