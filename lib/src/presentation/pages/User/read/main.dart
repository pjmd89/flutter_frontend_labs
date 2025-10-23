import 'package:flutter/material.dart';
//import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';
import './search_config.dart';
import './list_builder.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        //final l10n = AppLocalizations.of(context)!;
        return SearchTemplate(
          config: getSearchConfig(context: context, viewModel: viewModel),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: buildList(context: context, viewModel: viewModel),
          ),
        );
      },
    );
  }
}
