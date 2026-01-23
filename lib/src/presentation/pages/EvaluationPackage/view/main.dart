import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './details_section.dart';
import './exams_section.dart';

class EvaluationPackageViewPage extends StatefulWidget {
  final String id;
  
  const EvaluationPackageViewPage({
    super.key,
    required this.id,
  });

  @override
  State<EvaluationPackageViewPage> createState() => _EvaluationPackageViewPageState();
}

class _EvaluationPackageViewPageState extends State<EvaluationPackageViewPage> {
  late ViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context, id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.evaluationPackage),
        actions: [
          if (!viewModel.loading && viewModel.evaluationPackage != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: l10n.viewPdf,
              onPressed: () {
                // TODO: Implementar visualización de PDF
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PDF: ${viewModel.evaluationPackage!.pdfFilepath}')),
                );
              },
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          // Estado: Cargando
          if (viewModel.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado: Error
          if (viewModel.error || viewModel.evaluationPackage == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    l10n.errorLoadingData,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          // Estado: Con datos
          final evaluationPackage = viewModel.evaluationPackage!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsSection(
                  evaluationPackage: evaluationPackage,
                  l10n: l10n,
                ),
                const SizedBox(height: 24),
                ExamsSection(
                  evaluationPackage: evaluationPackage,
                  l10n: l10n,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
