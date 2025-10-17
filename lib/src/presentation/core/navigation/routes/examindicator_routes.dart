import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/ExamIndicator/read/main.dart';
import '/src/presentation/pages/ExamIndicator/create/main.dart';
import '/src/presentation/pages/ExamIndicator/delete/main.dart';
import '/src/presentation/pages/ExamIndicator/update/main.dart';

final List<GoRoute> examindicatorRoutes = [
  GoRoute(
    path: '/examindicator',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const ExamIndicatorPage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const ExamIndicatorCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: ExamIndicatorUpdatePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: ExamIndicatorDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
