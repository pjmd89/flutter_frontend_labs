import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/TypeAccess/read/main.dart';
import '/src/presentation/pages/TypeAccess/create/main.dart';
import '/src/presentation/pages/TypeAccess/delete/main.dart';
import '/src/presentation/pages/TypeAccess/update/main.dart';

final List<GoRoute> typeaccessRoutes = [
  GoRoute(
    path: '/typeaccess',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const TypeAccessPage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const TypeAccessCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: TypeAccessUpdatePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: TypeAccessDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
