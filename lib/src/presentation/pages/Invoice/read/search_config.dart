import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import 'package:labs/src/infraestructure/utils/search_fields.dart';
import './view_model.dart';

SearchTemplateConfig getSearchConfig({
  required BuildContext context,
  required ViewModel viewModel,
  required AppLocalizations l10n,
}) {

  return SearchTemplateConfig(
    rightWidget: FilledButton.icon(
      icon: const Icon(Icons.add),
      label: Text(l10n.createThing(l10n.invoice)),
      onPressed: () async {
        final result = await context.push('/invoice/create');
        if (result == true) {
          viewModel.getInvoices();
        }
      },
    ),
    searchFields: [
      SearchFields(
        field: 'paymentStatus',
      ),
    ],
    pageInfo: viewModel.pageInfo,
    onSearchChanged: (searchInputs) {
      if (searchInputs.isEmpty) {
        viewModel.getInvoices();
      } else {
        viewModel.search(searchInputs);
      }
    },
    onPageInfoChanged: (pageInfo) {
      viewModel.updatePageInfo(pageInfo);
    },
  );
}
