import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:jayshree_foundation/config/theme/app_colors.dart';
import 'package:jayshree_foundation/core/enums/status.dart';
import 'package:jayshree_foundation/providers/app_data_provider.dart';
import 'package:jayshree_foundation/providers/auth_provider.dart';
import 'package:jayshree_foundation/providers/theme_provider.dart';
import 'package:jayshree_foundation/screens/shared/donations_tab.dart';
import 'package:jayshree_foundation/screens/shared/documentation_tab.dart';
import 'package:jayshree_foundation/screens/shared/joining_letters_tab.dart';
import 'package:jayshree_foundation/screens/shared/members_tab.dart';
import 'package:jayshree_foundation/screens/shared/overview_tab.dart';
import 'package:jayshree_foundation/screens/shared/requests_tab.dart';
import 'package:jayshree_foundation/screens/shared/volunteers_tab.dart';
import 'package:jayshree_foundation/widgets/common/app_sidebar.dart';
import 'package:jayshree_foundation/widgets/common/custom_app_bar.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  int _selectedIndex = 0;

  static const List<(IconData, String)> _navItems = [
    (Icons.home_outlined, 'Overview'),
    (Icons.volunteer_activism_outlined, 'Volunteers'),
    (Icons.group_outlined, 'Members'),
    (Icons.attach_money, 'Donations'),
    (Icons.folder_outlined, 'Documentation'),
    (Icons.mail_outline, 'Joining Letters'),
    (Icons.inbox_outlined, 'Requests'),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<AppDataProvider>();
    final theme = context.watch<ThemeProvider>();

    final user = auth.currentUser;
    if (user == null) return const SizedBox.shrink();

    final pendingJL = data.joiningLetters
        .where((l) => l.status == RequestStatus.pending)
        .length;
    final pendingTotal = pendingJL +
        data.certificates.where((c) => c.status == RequestStatus.pending).length +
        data.mouRequests.where((m) => m.status == MouStatus.pending).length;

    final sidebarItems = _navItems.asMap().entries.map((e) {
      final idx = e.key;
      final (icon, label) = e.value;
      int badge = 0;
      if (idx == 5) badge = pendingJL;
      if (idx == 6) badge = pendingTotal;
      return SidebarItem(icon: icon, label: label, badgeCount: badge);
    }).toList();

    final tabs = [
      const OverviewTab(isSuperAdmin: true),
      const VolunteersTab(),
      const MembersTab(),
      const DonationsTab(),
      const DocumentationTab(),
      const JoiningLettersTab(),
      const RequestsTab(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: _navItems[_selectedIndex].$2,
        user: user,
        notificationCount: pendingTotal,
        onThemeTap: () => theme.toggleTheme(),
        onNotificationTap: () => setState(() => _selectedIndex = 6),
        onSettingsTap: () {
          // TODO: implement settings screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings coming soon')),
          );
        },
      ),
      drawer: AppSidebar(
        items: sidebarItems,
        currentIndex: _selectedIndex,
        onItemTap: (index) => setState(() => _selectedIndex = index),
        user: user,
        onSignOut: () => auth.logout(),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: tabs,
      ),
    );
  }
}
