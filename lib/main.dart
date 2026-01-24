import 'package:flutter/material.dart';
import 'package:agile_front/agile_front.dart' as af;
import '/src/presentation/core/templates/main.dart';
import '/src/presentation/providers/auth_notifier.dart';
import '/src/infraestructure/services/error_service.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/locale_notifier.dart';
import '/src/presentation/providers/theme_brightness_notifier.dart';
import '/src/presentation/providers/loading_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return af.MultiProvider(
      providers: [
        af.ChangeNotifierProvider(create: (_) => AppLocaleNotifier()),
        af.ChangeNotifierProvider(create: (_) => AuthNotifier()),
        af.Provider<ErrorService>(create: (_) => ErrorService()),
        af.ChangeNotifierProxyProvider2<
          AuthNotifier,
          ErrorService,
          GQLNotifier
        >(
          create:
              (context) => GQLNotifier(
                authNotifier: context.read<AuthNotifier>(),
                errorService: context.read<ErrorService>(),
              ),
          update:
              (context, authNotifier, errorService, previous) =>
                  previous ??
                  GQLNotifier(
                    authNotifier: authNotifier,
                    errorService: errorService,
                  ),
        ),
        af.ChangeNotifierProxyProvider<GQLNotifier, LaboratoryNotifier>(
          create: (context) => LaboratoryNotifier(
            gqlConn: context.read<GQLNotifier>().gqlConn,
          ),
          update: (context, gqlNotifier, previous) =>
              previous ?? LaboratoryNotifier(gqlConn: gqlNotifier.gqlConn),
        ),
        af.ChangeNotifierProvider(create: (_) => ThemeBrightnessNotifier()),
        af.ChangeNotifierProvider(create: (_) => LoadingNotifier()),
      ],
      child: const Template(),
    );
  }
}
