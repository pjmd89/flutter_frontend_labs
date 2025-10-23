import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/domain/entities/enums/role_enum.dart';
import 'package:provider/provider.dart';
import '/src/presentation/core/navigation/routes/main.dart';
import '/src/presentation/core/themes/teal.dart';
import '/src/presentation/providers/auth_notifier.dart';
import '/src/presentation/providers/locale_notifier.dart';
import '/l10n/app_localizations.dart';

class Template extends StatefulWidget {
  const Template({super.key});

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authNotifier = context.read<AuthNotifier>();
    authNotifier.addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    final authNotifier = context.read<AuthNotifier>();

    if (!authNotifier.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/login');
        }
      });
    }
  }

  @override
  void dispose() {
    final authNotifier = context.read<AuthNotifier>();
    authNotifier.removeListener(_onAuthChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String localeCode = context.watch<AppLocaleNotifier>().locale;
    final authNotifier = context.watch<AuthNotifier>();
    GoRouter router;
    switch (authNotifier.role) {
      case Role.owner:
        router = ownerRouter;
        break;
      case Role.billing:
        router = billingRouter;
        break;
      case Role.technician:
        router = technicianRouter;
        break;
      case Role.root:
        router = rootRouter;
        break;
      default:
        router = loginRouter;
    }

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: TealTheme().materialTheme,
      locale: Locale(localeCode),
      supportedLocales: const [Locale('es'), Locale('en')],
    );
  }
}
