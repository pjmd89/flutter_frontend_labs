import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/Login/read/main.dart';

final List<GoRoute> loginRoutes = [
  GoRoute(
    path: '/login',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const LoginPage()
    ),
    /*routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const CompanyCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: CompanyUpdatePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: CompanyDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
    */
  )
];
