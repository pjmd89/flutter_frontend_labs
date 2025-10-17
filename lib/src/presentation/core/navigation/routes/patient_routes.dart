import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/Patient/read/main.dart';
import '/src/presentation/pages/Patient/create/main.dart';
import '/src/presentation/pages/Patient/delete/main.dart';
import '/src/presentation/pages/Patient/update/main.dart';

final List<GoRoute> patientRoutes = [
  GoRoute(
    path: '/patient',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const PatientPage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const PatientCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: PatientUpdatePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: PatientDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
