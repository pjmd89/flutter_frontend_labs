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
  final userRole = loggedUser?.labRole;
  final shouldHideButton = userRole == LabMemberRole.bILLING || userRole == LabMemberRole.tECHNICIAN;

  return SearchTemplateConfig(
    rightWidget: shouldHideButton 
        ? const SizedBox.shrink() // Ocultar botón si es billing o technician
        : FilledButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.createThing(l10n.exam)),
            onPressed: () async {
              final result = await context.push('/exam/create');
              if (result == true) {
                viewModel.getExams();
              }
            },
          ),
    searchFields: [
      SearchFields(field: 'template.name'),
      SearchFields(field: 'baseCost'),
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
