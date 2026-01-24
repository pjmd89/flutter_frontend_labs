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
import 'home_routes.dart';

ShellRoute ownerShellRoute = ShellRoute(
  builder: (context, state, child) {
    return BasicTemplate(child: child);
  },
  routes: [
    ...homeRoutes,
    ...companyRoutes,
    ...laboratoryRoutes,
    ...userRoutes,
    ...examRoutes,
    ...patientRoutes,
    ...invoiceRoutes,
    ...evaluationpackageRoutes,
    ...examtemplateRoutes,
    ...examindicatorRoutes,
  ],
);
ShellRoute rootShellRoute = ShellRoute(
  builder: (context, state, child) {
    return BasicTemplate(child: child);
  },
  routes: [
    ...dashboardRoutes,
    ...companyRoutes,
    ...laboratoryRoutes,
    ...userRoutes,
    ...examtemplateRoutes,
    ...examindicatorRoutes,
    ...patientRoutes,
  ],
);
ShellRoute billingShellRoute = ShellRoute(
  builder: (context, state, child) {
    return BasicTemplate(child: child);
  },
  routes: [...invoiceRoutes, ...patientRoutes],
);
ShellRoute technicianShellRoute = ShellRoute(
  builder: (context, state, child) {
    return BasicTemplate(child: child);
  },
  routes: [...examRoutes, ...evaluationpackageRoutes],
);
ShellRoute bioanalystShellRoute = ShellRoute(
  builder: (context, state, child) {
    return BasicTemplate(child: child);
  },
  routes: [
    ...dashboardRoutes,
    ...patientRoutes,
    ...evaluationpackageRoutes,
    ...laboratoryRoutes,
  ],
);
ShellRoute loginShellRoute = ShellRoute(
  builder: (context, state, child) {
    return LoginTemplate(child: child);
  },
  routes: [...loginRoutes],
);
GoRouter rootRouter = GoRouter(
  initialLocation: "/dashboard",
  routes: [rootShellRoute],
);
GoRouter ownerRouter = GoRouter(
  initialLocation: "/home",
  routes: [ownerShellRoute],
);
GoRouter billingRouter = GoRouter(
  initialLocation: "/billing",
  routes: [billingShellRoute],
);
GoRouter technicianRouter = GoRouter(
  initialLocation: "/exam",
  routes: [technicianShellRoute],
);
GoRouter bioanalystRouter = GoRouter(
  initialLocation: "/patient",
  routes: [bioanalystShellRoute],
);
GoRouter loginRouter = GoRouter(
  initialLocation: "/login",
  routes: [loginShellRoute],
);
