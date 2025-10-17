import 'package:go_router/go_router.dart';
import 'package:labs/src/presentation/core/templates/login/main.dart';
import '/src/presentation/core/templates/basic/main.dart';
import 'exam_routes.dart';
import 'company_routes.dart';
import 'laboratory_routes.dart';
import 'evaluationpackage_routes.dart';
import 'user_routes.dart';
import 'examtemplate_routes.dart';
import 'examindicator_routes.dart';
import 'invoice_routes.dart';
import 'patient_routes.dart';
import 'login_routes.dart';
import 'dashboard_routes.dart';

ShellRoute userShellRoute = ShellRoute(
  builder: (context, state, child) {
    return BasicTemplate(child: child);
  },
  routes: [
    ...dashboardRoutes,
    ...loginRoutes,
    ...examRoutes,
    ...companyRoutes,
    ...laboratoryRoutes,
    ...evaluationpackageRoutes,
    ...userRoutes,
    ...examtemplateRoutes,
    ...examindicatorRoutes,
    ...invoiceRoutes,
    ...patientRoutes,
  ],
);
ShellRoute loginShellRoute = ShellRoute(
  builder: (context, state, child) {
    return LoginTemplate(child: child);
  },
  routes: [
    ...loginRoutes,
  ],
);

GoRouter templateRouter = GoRouter(
  initialLocation: "/dashboard",
  routes: [
    userShellRoute
  ],
);
GoRouter loginRouter = GoRouter(
  initialLocation: "/login",
  routes: [
    loginShellRoute
  ],
);
