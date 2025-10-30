import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/enums/role_enum.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import 'package:labs/src/presentation/providers/locale_notifier.dart';
import 'package:labs/src/presentation/providers/theme_brightness_notifier.dart';
import 'package:provider/provider.dart';
import './view_model.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({super.key});

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  late ViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  void _showLogoutConfirmation(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(l10n.logout),
            content: Text(l10n.logoutConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await viewModel.logout();
                },
                child: Text(l10n.logout),
              ),
            ],
          ),
    );
  }

  String _getRoleLabel(BuildContext context, Role role) {
    final l10n = AppLocalizations.of(context)!;
    switch (role) {
      case Role.root:
        return l10n.roleRoot;
      case Role.admin:
        return l10n.roleAdmin;
      case Role.owner:
        return l10n.roleOwner;
      case Role.technician:
        return l10n.roleTechnician;
      case Role.billing:
        return l10n.roleBilling;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authNotifier = context.watch<AuthNotifier>();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        if (viewModel.loading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(l10n.loggingOut),
              ],
            ),
          );
        }

        return PopupMenuButton<String>(
          offset: const Offset(0, 50),
          tooltip: '',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 18,
                  child: Text(
                    authNotifier.firstName.isNotEmpty
                        ? authNotifier.firstName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    authNotifier.fullName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
          itemBuilder:
              (context) => [
                // Idioma con submenú
                PopupMenuItem<String>(
                  onTap: () {},
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(hoverColor: Colors.transparent),
                    child: PopupMenuButton<AppLocale>(
                      offset: const Offset(200, 0),
                      tooltip: '',
                      child: Row(
                        children: [
                          const Icon(Icons.language, size: 20),
                          const SizedBox(width: 12),
                          Text(l10n.language),
                          const Spacer(),
                          const Icon(Icons.arrow_right, size: 20),
                        ],
                      ),
                      itemBuilder:
                          (context) => [
                            PopupMenuItem<AppLocale>(
                              value: AppLocale.es,
                              child: Row(
                                children: [
                                  if (context
                                          .read<AppLocaleNotifier>()
                                          .locale ==
                                      'es')
                                    const Icon(Icons.check, size: 20)
                                  else
                                    const SizedBox(width: 20),
                                  const SizedBox(width: 8),
                                  Text(l10n.languageSpanish),
                                ],
                              ),
                            ),
                            PopupMenuItem<AppLocale>(
                              value: AppLocale.en,
                              child: Row(
                                children: [
                                  if (context
                                          .read<AppLocaleNotifier>()
                                          .locale ==
                                      'en')
                                    const Icon(Icons.check, size: 20)
                                  else
                                    const SizedBox(width: 20),
                                  const SizedBox(width: 8),
                                  Text(l10n.languageEnglish),
                                ],
                              ),
                            ),
                          ],
                      onSelected: (locale) {
                        context.read<AppLocaleNotifier>().setLocale(locale);
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ),
                ),
                // Tema con submenú
                PopupMenuItem<String>(
                  onTap: () {},
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(hoverColor: Colors.transparent),
                    child: PopupMenuButton<BrightnessMode>(
                      offset: const Offset(200, 0),
                      tooltip: '',
                      child: Row(
                        children: [
                          const Icon(Icons.palette, size: 20),
                          const SizedBox(width: 12),
                          Text(l10n.brightnessTheme),
                          const Spacer(),
                          const Icon(Icons.arrow_right, size: 20),
                        ],
                      ),
                      itemBuilder:
                          (context) => [
                            PopupMenuItem<BrightnessMode>(
                              value: BrightnessMode.light,
                              child: Row(
                                children: [
                                  if (context
                                          .read<ThemeBrightnessNotifier>()
                                          .brightness ==
                                      Brightness.light)
                                    const Icon(Icons.check, size: 20)
                                  else
                                    const SizedBox(width: 20),
                                  const SizedBox(width: 8),
                                  Text(l10n.brightnessLight),
                                ],
                              ),
                            ),
                            PopupMenuItem<BrightnessMode>(
                              value: BrightnessMode.dark,
                              child: Row(
                                children: [
                                  if (context
                                          .read<ThemeBrightnessNotifier>()
                                          .brightness ==
                                      Brightness.dark)
                                    const Icon(Icons.check, size: 20)
                                  else
                                    const SizedBox(width: 20),
                                  const SizedBox(width: 8),
                                  Text(l10n.brightnessDark),
                                ],
                              ),
                            ),
                          ],
                      onSelected: (mode) {
                        context.read<ThemeBrightnessNotifier>().brightnessMode =
                            mode;
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                // Logout
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      const Icon(Icons.logout, size: 20),
                      const SizedBox(width: 12),
                      Text(l10n.logout),
                    ],
                  ),
                ),
                // Rol del usuario (solo informativo)
                if (authNotifier.role != null) ...[
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    enabled: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.badge,
                          size: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getRoleLabel(context, authNotifier.role!),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
          onSelected: (value) {
            if (value == 'logout') {
              _showLogoutConfirmation(context, l10n);
            }
          },
        );
      },
    );
  }
}
