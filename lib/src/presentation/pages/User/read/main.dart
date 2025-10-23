import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/infraestructure/utils/search_fields.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';
import './read_card.dart';
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
    return ListenableBuilder(listenable: viewModel, builder:  (context, child) {
      //final l10n = AppLocalizations.of(context)!;
      return SearchTemplate(
        rightWidget: FilledButton.icon(
          icon: const Icon(Icons.add),
          //label: Text(l10n.createThing(l10n.destinationOffice)),
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
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: /*viewModel.loading
            ? [const Center(child: CircularProgressIndicator())]
            : */[
              ReadCard(),
            ],
          /*
            ? [const Center(child: CircularProgressIndicator())] :
          viewModel.resultList?.map((result) => DestinationOfficeCard(
            data: result,
            onUpdate: (id) async {
              final pushResult = await context.push('/destinationoffice/update/$id');
              log('pushResult: $pushResult');
              if (pushResult == true) {
                viewModel.getResults();
              }
            },
            onDelete: (id) async {
              final pushResult = await context.push('/destinationoffice/delete/$id');
              if (pushResult == true) {
                viewModel.getResults();
              }
            },
            onManageUsers: (id) {
              //context.push('/destinationoffice/manageusers/$id');
            },
          )).toList() ?? [],*/
        ),
      );
    });
  }
}
