import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';

// --- Header Component ---
class UserManagementHeader extends StatelessWidget {
  final VoidCallback? onCreateUser;
  final Function(String)? onSearchChanged;

  const UserManagementHeader({
    super.key,
    this.onCreateUser,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.users,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "${l10n.search} ${l10n.users.toLowerCase()}...",
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: onCreateUser,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.newThing(l10n.user)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Filter Bar Component ---
class UserFilterBar extends StatelessWidget {
  final int totalUsers;
  final int displayedUsers;
  final String? selectedRole;
  final bool showActiveOnly;
  final Function(String?)? onRoleChanged;
  final Function(bool)? onStatusChanged;

  const UserFilterBar({
    super.key,
    required this.totalUsers,
    required this.displayedUsers,
    this.selectedRole,
    this.showActiveOnly = false,
    this.onRoleChanged,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Dropdown de Roles
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String?>(
                value: selectedRole,
                underline: const SizedBox.shrink(),
                icon: const Icon(Icons.arrow_drop_down, size: 20),
                dropdownColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text("Todos los Roles"),
                  ),
                  DropdownMenuItem(
                    value: "TECHNICIAN",
                    child: Text(l10n.roleTechnician),
                  ),
                  DropdownMenuItem(
                    value: "BILLING",
                    child: Text(l10n.roleBilling),
                  ),
                  DropdownMenuItem(
                    value: "BIOANALYST",
                    child: Text(l10n.roleBioanalyst),
                  ),
                ],
                onChanged: onRoleChanged,
              ),
            ),
          ],
        ),
        Text(
          "Mostrando $displayedUsers de $totalUsers ${l10n.users.toLowerCase()}",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
        ),
      ],
    );
  }
}

// --- Stats Grid Component ---
class UserStatsGrid extends StatelessWidget {
  final int totalUsers;
  final int activeUsers;
  final String pendingFees;

  const UserStatsGrid({
    super.key,
    required this.totalUsers,
    required this.activeUsers,
    required this.pendingFees,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: constraints.maxWidth > 800 ? 3 : 1,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 2.5,
          children: [
            _statCard(
              "TOTAL ${l10n.users.toUpperCase()}",
              totalUsers.toString(),
              Icons.groups,
              colorScheme.primary,
              "+12%",
            ),
            _statCard(
              "ACTIVOS ESTE MES",
              activeUsers.toString(),
              Icons.check_circle,
              colorScheme.secondary,
              "${((activeUsers / totalUsers) * 100).toStringAsFixed(0)}%",
            ),
            _statCard(
              "LABORATORIOS",
              "15",
              Icons.science,
              colorScheme.tertiary,
              "Activos",
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String trend,
  ) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  trend,
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Footer Component ---
class UserManagementFooter extends StatelessWidget {
  const UserManagementFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "© 2026 LabOS Laboratory Management Systems. All rights reserved.",
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
      ),
    );
  }
}

// --- User Table Header ---
class UserTableHeader extends StatelessWidget {
  const UserTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              l10n.user.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              l10n.role.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "LABORATORIO",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "ACCIONES",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
