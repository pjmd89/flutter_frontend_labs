import 'package:flutter/material.dart';
import 'package:agile_front/agile_front.dart' as af;
import '/src/presentation/core/templates/main.dart';
import '/src/presentation/providers/auth_notifier.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/locale_notifier.dart';
import '/src/presentation/providers/theme_brightness_notifier.dart';
import '/src/presentation/providers/loading_notifier.dart';

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
        af.ChangeNotifierProxyProvider<AuthNotifier, GQLNotifier>(
          create:
              (context) =>
                  GQLNotifier(authNotifier: context.read<AuthNotifier>()),
          update:
              (context, authNotifier, previous) =>
                  previous ?? GQLNotifier(authNotifier: authNotifier),
        ),
        af.ChangeNotifierProvider(create: (_) => ThemeBrightnessNotifier()),
        af.ChangeNotifierProvider(create: (_) => LoadingNotifier()),
      ],
      child: Template(),
    );
  }
}
