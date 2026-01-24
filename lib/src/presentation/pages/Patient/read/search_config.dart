import 'package:flutter/foundation.dart';
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
  // Obtener el rol del usuario logueado - usar watch para reactivity
  final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
  final userRole = loggedUser?.labRole;
  
  // Debug
  debugPrint('🔍 Patient Search Config - User Role: $userRole');
  debugPrint('🔍 Is TECHNICIAN? ${userRole == LabMemberRole.tECHNICIAN}');
  
  final isTechnician = userRole == LabMemberRole.tECHNICIAN;

  return SearchTemplateConfig(
    rightWidget: isTechnician 
        ? const SizedBox.shrink() // Ocultar botón si es technician
        : FilledButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.newThing(l10n.patient)),
            onPressed: () async {
              final pushResult = await context.push('/patient/create');
              if (pushResult == true) {
                viewModel.getPatients();
              }
            },
          ),
    searchFields: [
      SearchFields(field: 'firstName'),
      SearchFields(field: 'lastName'),
      SearchFields(field: 'dni'),
      SearchFields(field: 'email'),
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
