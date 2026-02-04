import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/infraestructure/utils/search_fields.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import 'package:labs/src/domain/entities/enums/labmemberrole_enum.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';
import './view_model.dart';

SearchTemplateConfig getSearchConfig({
  required BuildContext context,
  required ViewModel viewModel,
  required AppLocalizations l10n,
}) {
  // Obtener el rol del usuario logueado
  final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
  final isBilling = loggedUser?.labRole == LabMemberRole.bILLING;
  final isBioanalyst = loggedUser?.labRole == LabMemberRole.bIOANALYST;

  return SearchTemplateConfig(
    rightWidget: (isBilling || isBioanalyst)
        ? const SizedBox.shrink() // Ocultar botón si es billing o bioanalista
        : FilledButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.newThing(l10n.user)),
            onPressed: () async {
              final pushResult = await context.push('/user/create');
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
