import 'package:agile_front/agile_front.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '/src/domain/entities/main.dart';
import '/src/presentation/pages/User/read/main.dart';
import '/src/presentation/pages/User/create/main.dart';
import '/src/presentation/pages/User/delete/main.dart';
import '/src/presentation/pages/User/update/main.dart';
import '/src/presentation/pages/User/laboratories/main.dart';
import '/src/presentation/pages/User/billing/main.dart';

final List<GoRoute> userRoutes = [
  GoRoute(
    path: '/user',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const UserPage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const UserCreatePage()
        ),
      ),
      GoRoute(
        path: '/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const UserCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) {
          debugPrint('\n🛣️ ========== RUTA UPDATE ==========');
          debugPrint('🛣️ state.pathParameters["id"]: ${state.pathParameters['id']}');
          debugPrint('🛣️ state.extra != null: ${state.extra != null}');
          debugPrint('🛣️ state.extra type: ${state.extra.runtimeType}');
          if (state.extra != null) {
            debugPrint('🛣️ state.extra is LabMembershipInfo: ${state.extra is LabMembershipInfo}');
          }
          debugPrint('========================================\n');
          
          return CustomDialogPage(
            context: context, 
            state: state, 
            child: UserUpdatePage(
              id: state.pathParameters['id']!,
              user: state.extra as LabMembershipInfo?,
            )
          );
        }
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: UserDeletePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: ':id/laboratories',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: UserLaboratoriesPage(
            userId: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: ':id/billing',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: UserBillingPage(
            userId: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
