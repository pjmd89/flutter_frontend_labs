import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';
import './search_config.dart';
import './list_builder.dart';

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
        return SearchTemplate(
          config: getSearchConfig(
            context: context,
            viewModel: viewModel,
            l10n: l10n,
          ),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: buildList(
              context: context,
              viewModel: viewModel,
              l10n: l10n,
            ),
          ),
        );
      },
    );
  }
}
