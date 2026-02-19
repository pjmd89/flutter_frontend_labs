import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/presentation/core/navigation/transitions/main.dart';
import '/src/domain/entities/main.dart';
import '/src/presentation/pages/Laboratory/read/main.dart';
import '/src/presentation/pages/Laboratory/create/main.dart';
import '/src/presentation/pages/Laboratory/delete/main.dart';
import '/src/presentation/pages/Laboratory/update/main.dart';
import '/src/presentation/pages/Laboratory/billing/main.dart';

final List<GoRoute> laboratoryRoutes = [
  GoRoute(
    path: '/laboratory',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const LaboratoryPage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomSidebarPage(
          context: context, 
          state: state, 
          child: const LaboratoryCreatePage()
        ),
      ),
      GoRoute(
        path: 'update',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: LaboratoryUpdatePage(
            laboratory: state.extra as Laboratory
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: LaboratoryDeletePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: ':id/billing',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: LaboratoryBillingPage(
            laboratoryId: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
