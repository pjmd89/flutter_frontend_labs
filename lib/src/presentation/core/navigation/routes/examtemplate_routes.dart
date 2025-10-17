import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/ExamTemplate/read/main.dart';
import '/src/presentation/pages/ExamTemplate/create/main.dart';
import '/src/presentation/pages/ExamTemplate/delete/main.dart';
import '/src/presentation/pages/ExamTemplate/update/main.dart';

final List<GoRoute> examtemplateRoutes = [
  GoRoute(
    path: '/examtemplate',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const ExamTemplatePage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const ExamTemplateCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: ExamTemplateUpdatePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: ExamTemplateDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
