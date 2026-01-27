import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/domain/entities/enums/role_enum.dart';
import 'package:labs/src/domain/entities/enums/labmemberrole_enum.dart';
import 'package:provider/provider.dart';
import '/src/presentation/core/navigation/routes/main.dart';
import '/src/presentation/core/themes/teal.dart';
import '/src/presentation/providers/auth_notifier.dart';
import '/src/infraestructure/services/error_service.dart';
import '/src/presentation/providers/locale_notifier.dart';
import '/src/presentation/providers/theme_brightness_notifier.dart';
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
      // Forzar rebuild para cambiar al loginRouter
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
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
    final themeBrightnessNotifier = context.watch<ThemeBrightnessNotifier>();
    final errorService = context.read<ErrorService>();

    GoRouter router;
    switch (authNotifier.role) {
      case Role.rOOT:
        router = rootRouter;
        break;
      case Role.aDMIN:
        router = ownerRouter;
        break;
      case Role.uSER:
        // Determinar router según labRole del laboratorio actual
        if (authNotifier.labRole != null) {
          switch (authNotifier.labRole!) {
            case LabMemberRole.oWNER:
              router = ownerRouter;
              break;
            case LabMemberRole.bIOANALYST:
              router = bioanalystRouter;
              break;
            case LabMemberRole.tECHNICIAN:
              router = technicianRouter;
              break;
            case LabMemberRole.bILLING:
              router = billingRouter;
              break;
          }
        } else {
          // Si no tiene labRole, usar userIsLabOwner como fallback
          router = authNotifier.userIsLabOwner ? ownerRouter : bioanalystRouter;
        }
        break;
      default:
        router = loginRouter;
    }

    return MaterialApp.router(
      // Key única para forzar reconstrucción al cambiar de router (especialmente al logout)
      key: ValueKey(authNotifier.isAuthenticated ? authNotifier.id : 'login'),
      scaffoldMessengerKey: errorService.scaffoldMessengerKey,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: TealTheme().lightTheme,
      darkTheme: TealTheme().darkTheme,
      themeMode:
          themeBrightnessNotifier.brightness == Brightness.light
              ? ThemeMode.light
              : ThemeMode.dark,
      locale: Locale(localeCode),
      supportedLocales: const [Locale('es'), Locale('en')],
    );
  }
}
