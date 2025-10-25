import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import './view_model.dart';
import './company_item.dart';

List<Widget> buildList({
  required BuildContext context,
  required ViewModel viewModel,
  required AppLocalizations l10n,
}) {
  // Estado: Cargando
  if (viewModel.loading) {
    return [const Center(child: CircularProgressIndicator())];
  }

  // Estado: Error
  if (viewModel.error) {
    return [Center(child: Text(l10n.errorLoadingData))];
  }

  // Estado: Sin datos
  if (viewModel.companyList == null || viewModel.companyList!.isEmpty) {
    return [Center(child: Text(l10n.noRegisteredFemaleThings(l10n.companies)))];
  }

  // Estado: Con datos - mapea cada item a su widget
  return viewModel.companyList!.map((company) {
    return CompanyItem(
      company: company,
      l10n: l10n,
      onUpdate: (id) async {
        final result = await context.push('/company/update/$id');
        if (result == true) {
          viewModel.getCompanies();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/company/delete/$id');
        if (result == true) {
          viewModel.getCompanies();
        }
      },
    );
  }).toList();
}
