import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/EvaluationPackage/read/main.dart';
import '/src/presentation/pages/EvaluationPackage/create/main.dart';
import '/src/presentation/pages/EvaluationPackage/delete/main.dart';
import '/src/presentation/pages/EvaluationPackage/update/main.dart';

final List<GoRoute> evaluationpackageRoutes = [
  GoRoute(
    path: '/evaluationpackage',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const EvaluationPackagePage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const EvaluationPackageCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: EvaluationPackageUpdatePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: EvaluationPackageDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
