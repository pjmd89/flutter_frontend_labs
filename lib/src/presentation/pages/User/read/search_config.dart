import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/infraestructure/utils/search_fields.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';

SearchTemplateConfig getSearchConfig({
  required BuildContext context,
  required ViewModel viewModel,
  required AppLocalizations l10n,
}) {
  return SearchTemplateConfig(
    rightWidget: FilledButton.icon(
      icon: const Icon(Icons.add),
      label: const Text('Nueva Membresía'),
      onPressed: () async {
        final pushResult = await context.push('/membership/create');
        if (pushResult == true) {
          viewModel.getMemberships();
        }
      },
    ),
    searchFields: [
      SearchFields(field: 'member'),
      SearchFields(field: 'laboratory'),
    ],
    pageInfo: viewModel.pageInfo,
    onSearchChanged: (search) {
      viewModel.search(search);
    },
    onPageInfoChanged: (pageInfo) {
      viewModel.updatePageInfo(pageInfo);
    },
  );
}
