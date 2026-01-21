import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/domain/entities/main.dart';
import '/src/presentation/pages/Exam/read/main.dart';
import '/src/presentation/pages/Exam/create/main.dart';
import '/src/presentation/pages/Exam/delete/main.dart';
import '/src/presentation/pages/Exam/update/main.dart';

final List<GoRoute> examRoutes = [
  GoRoute(
    path: '/exam',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const ExamPage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const ExamCreatePage()
        ),
      ),
      GoRoute(
        path: 'update',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: ExamUpdatePage(
            exam: state.extra as Exam
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: ExamDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
