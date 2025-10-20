import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/Login/read/auth_callback_page.dart';
import '/src/presentation/pages/Login/read/main.dart';

final List<GoRoute> loginRoutes = [
  GoRoute(
    path: '/login',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const LoginPage()
    )
  ),
  GoRoute(
    path: '/auth/callback',
    builder: (context, state) => AuthCallbackPage(uri: state.uri),
  ),
];
