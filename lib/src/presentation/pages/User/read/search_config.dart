import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/infraestructure/utils/search_fields.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';

SearchTemplateConfig getSearchConfig({
  required BuildContext context,
  required ViewModel viewModel,
}) {
  return SearchTemplateConfig(
    rightWidget: FilledButton.icon(
      icon: const Icon(Icons.add),
      label: Text("Nuevo Usuario"),
      onPressed: () async {
        final pushResult = await context.push('/destinationoffice/create');
        if (pushResult == true) {
          //viewModel.getResults();
        }
      },
    ),
    searchFields: [SearchFields(field: 'name')],
    //pageInfo: viewModel.pageInfo,
    onSearchChanged: (search) {
      //viewModel.search(search);
    },
    onPageInfoChanged: (pageInfo) {
      //viewModel.pageInfo = pageInfo;
      //viewModel.getResults();
    },
  );
}
