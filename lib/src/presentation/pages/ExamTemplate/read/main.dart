import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';
import './search_config.dart';
import './list_builder.dart';
import './ui_components.dart';

class ExamTemplatePage extends StatefulWidget {
  const ExamTemplatePage({super.key});

  @override
  State<ExamTemplatePage> createState() => _ExamTemplatePageState();
}

class _ExamTemplatePageState extends State<ExamTemplatePage> {
  late ViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final templateList = buildList(
          context: context,
          viewModel: viewModel,
          l10n: l10n,
        );

        final displayedCount = templateList.length;
        final totalCount = viewModel.pageInfo?.total.toInt() ?? 0;

        return SearchTemplate(
          config: getSearchConfig(
            context: context,
            viewModel: viewModel,
            l10n: l10n,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Filter Bar
              ExamTemplateFilterBar(
                totalTemplates: totalCount,
                displayedTemplates: displayedCount,
              ),
              const SizedBox(height: 8),

              // ExamTemplate Table
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    const ExamTemplateTableHeader(),
                    if (viewModel.loading)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (viewModel.error)
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(child: Text(l10n.errorLoadingData)),
                      )
                    else if (templateList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            l10n.noRegisteredFemaleThings(l10n.examTemplates),
                          ),
                        ),
                      )
                    else
                      ...templateList,
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Stats Grid
              ExamTemplateStatsGrid(
                totalTemplates: totalCount,
              ),

              const SizedBox(height: 48),

              // Footer
              const ExamTemplateManagementFooter(),
            ],
          ),
        );
      },
    );
  }
}
