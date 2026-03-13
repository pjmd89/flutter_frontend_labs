import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:provider/provider.dart';
import './view_model.dart';
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
      // Filtrar por rol
      if (selectedRole != null) {
        if (widget is MembershipItem) {
          final roleMatches = widget.membership.role?.toString().contains(selectedRole!) ?? false;
          if (!roleMatches) return false;
        }
      }
      
      // Filtro de "Solo Activos" siempre muestra todos (ya que no tenemos estado inactivo en el modelo)
      // Este filtro es visual solamente
      
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final loggedUser = context.watch<LaboratoryNotifier>().loggedUser;
    final isBilling = loggedUser?.labRole == LabMemberRole.bILLING;

    return Scaffold(
      body: ListenableBuilder(
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

          return Column(
            children: [
              // Header
              UserManagementHeader(
                onCreateUser: isBilling
                    ? null
                    : () async {
                        final pushResult =
                            await context.push('/user/create');
                        if (pushResult == true) {
                          viewModel.getMemberships();
                        }
                      },
                onSearchChanged: null, // Deshabilitado temporalmente
              ),
              
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filter Bar
                        UserFilterBar(
                          totalUsers: totalCount,
                          displayedUsers: displayedCount,
                          selectedRole: selectedRole,
                          showActiveOnly: showActiveOnly,
                          onRoleChanged: (String? newRole) {
                            setState(() {
                              selectedRole = newRole;
                            });
                          },
                          onStatusChanged: (bool newStatus) {
                            setState(() {
                              showActiveOnly = newStatus;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // User Table
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            children: [
                              // Table Header
                              const UserTableHeader(),
                              
                              // User List (como filas de tabla)
                              if (viewModel.loading)
                                const Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (viewModel.error)
                                Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Center(
                                    child: Text(l10n.errorLoadingData),
                                  ),
                                )
                              else if (userList.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Center(
                                    child: Text(
                                      l10n.noRegisteredFemaleThings(
                                          'Membresías'),
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
