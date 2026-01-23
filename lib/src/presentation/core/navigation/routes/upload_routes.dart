import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/Upload/read/main.dart';
import '/src/presentation/pages/Upload/create/main.dart';
import '/src/presentation/pages/Upload/delete/main.dart';
import '/src/presentation/pages/Upload/update/main.dart';

final List<GoRoute> uploadRoutes = [
  GoRoute(
    path: '/upload',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const UploadPage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const UploadCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: UploadUpdatePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: UploadDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
