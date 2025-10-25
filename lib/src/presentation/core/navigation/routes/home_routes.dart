import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/presentation/pages/Dashboard/main.dart';

final List<GoRoute> homeRoutes = [
  GoRoute(
    path: '/home',
    pageBuilder:
        (context, state) => CustomSlideTransition(
          context: context,
          state: state,
          child: const DashboardPage(),
        ),
  ),
];
