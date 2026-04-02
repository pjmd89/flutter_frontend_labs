import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/presentation/core/ui/search/main.dart';
import './view_model.dart';
import './search_config.dart';
import './ui_components.dart';
import './list_builder.dart';
import './membership_item.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late ViewModel viewModel;
  String? selectedRole;
  bool showActiveOnly = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }

  List<Widget> _applyFilters(List<Widget> userList) {
    if (selectedRole == null && !showActiveOnly) {
      return userList;
    }

    return userList.where((widget) {
      if (selectedRole != null) {
        if (widget is MembershipItem) {
          final memberRole = widget.membership.role?.name.toUpperCase();
          final roleMatches = memberRole == selectedRole;
          if (!roleMatches) return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final allUserList = buildList(
          context: context,
          viewModel: viewModel,
          l10n: l10n,
        );

        final userList = _applyFilters(allUserList);
        final displayedCount = userList.length;
        final totalCount = viewModel.pageInfo?.total.toInt() ?? 0;

        return SearchTemplate(
          config: getSearchConfig(
            context: context,
            viewModel: viewModel,
            l10n: l10n,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Filter Bar
              UserFilterBar(
                totalUsers: totalCount,
                displayedUsers: displayedCount,
                selectedRole: selectedRole,
                showActiveOnly: showActiveOnly,
                onRoleChanged: (String? newRole) {
                  setState(() => selectedRole = newRole);
                },
                onStatusChanged: (bool newStatus) {
                  setState(() => showActiveOnly = newStatus);
                },
              ),
              const SizedBox(height: 8),

              // User Table
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    const UserTableHeader(),
                    if (viewModel.loading)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (viewModel.error)
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(child: Text(l10n.errorLoadingData)),
                      )
                    else if (userList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            l10n.noRegisteredFemaleThings('Membresías'),
                          ),
                        ),
                      )
                    else
                      ...userList,
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Stats Grid
              UserStatsGrid(
                totalUsers: totalCount,
                activeUsers: displayedCount,
                pendingFees: "\$0",
              ),

              const SizedBox(height: 48),

              // Footer
              const UserManagementFooter(),
            ],
          ),
        );
      },
    );
  }
}
