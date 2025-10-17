import 'package:go_router/go_router.dart';
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

ShellRoute userShellRoute = ShellRoute(
  builder: (context, state, child) {
    return BasicTemplate(child: child);
  },
  routes: [
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

GoRouter templateRouter = GoRouter(
  initialLocation: "/",
  routes: [
    userShellRoute
  ],
);
