import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/KeyValuePair/read/main.dart';
import '/src/presentation/pages/KeyValuePair/create/main.dart';
import '/src/presentation/pages/KeyValuePair/delete/main.dart';
import '/src/presentation/pages/KeyValuePair/update/main.dart';

final List<GoRoute> keyvaluepairRoutes = [
  GoRoute(
    path: '/keyvaluepair',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const KeyValuePairPage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const KeyValuePairCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: KeyValuePairUpdatePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: KeyValuePairDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
