import 'package:agile_front/agile_front.dart';
import 'package:go_router/go_router.dart';
import '/src/presentation/pages/Invoice/read/main.dart';
import '/src/presentation/pages/Invoice/create/main.dart';
import '/src/presentation/pages/Invoice/delete/main.dart';
import '/src/presentation/pages/Invoice/update/main.dart';

final List<GoRoute> invoiceRoutes = [
  GoRoute(
    path: '/invoice',
    pageBuilder: (context, state) => CustomSlideTransition(
      context: context, 
      state: state, 
      child: const InvoicePage()
    ),
    routes: [
      GoRoute(
        path: 'create',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: const InvoiceCreatePage()
        ),
      ),
      GoRoute(
        path: 'update/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: InvoiceUpdatePage(
            id: state.pathParameters['id']!
          )
        )
      ),
      GoRoute(
        path: 'delete/:id',
        pageBuilder: (context, state) => CustomDialogPage(
          context: context, 
          state: state, 
          child: InvoiceDeletePage(
            id: state.pathParameters['id']!
          )
        )
      )
    ]
  )
];
