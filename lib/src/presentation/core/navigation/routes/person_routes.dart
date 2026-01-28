import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/Person/read/main.dart';
import '/src/presentation/pages/Person/create/main.dart';
import '/src/presentation/pages/Person/delete/main.dart';
import '/src/presentation/pages/Person/update/main.dart';

final List<GoRoute> personRoutes = [
  GoRoute(
    path: '/person',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const PersonPage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const PersonCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: PersonUpdatePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: PersonDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
