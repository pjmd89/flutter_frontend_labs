import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/Company/read/main.dart';
import '/src/presentation/pages/Company/delete/main.dart';
import '/src/presentation/pages/Company/update/main.dart';

final List<GoRoute> companyRoutes = [
  GoRoute(
    path: '/company',
    pageBuilder:
        (context, state) => CustomSlideTransition(
          context: context,
          state: state,
          child: const CompanyPage(),
        ),
    routes: [
      GoRoute(
        path: 'update/:id',
        pageBuilder:
            (context, state) => CustomDialogPage(
              context: context,
              state: state,
              child: CompanyUpdatePage(id: state.pathParameters['id']!),
            ),
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder:
            (context, state) => CustomDialogPage(
              context: context,
              state: state,
              child: CompanyDeletePage(id: state.pathParameters['id']!),
            ),
      ),
    ],
  ),
];
