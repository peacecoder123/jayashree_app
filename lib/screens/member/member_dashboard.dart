import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/app_colors.dart';
import '../../core/enums/status.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/app_sidebar.dart';
import '../../widgets/common/custom_app_bar.dart';
import 'my_tasks_screen.dart';
import 'minutes_of_meeting_screen.dart';
import 'hospital_mou_screen.dart';
import 'certificate_screen.dart';
import 'payments_screen.dart';

class MemberDashboard extends StatefulWidget {
  const MemberDashboard({super.key});

  @override
  State<MemberDashboard> createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<MemberDashboard> {
  int _currentIndex = 0;

  static const _screens = [
    MemberMyTasksScreen(),
    MemberMinutesOfMeetingScreen(),
    MemberHospitalMouScreen(),
    MemberCertificateScreen(),
    MemberPaymentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<AppDataProvider>();
    final theme = context.watch<ThemeProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryTeal),
        ),
      );
    }

    final userId = user.id;
    final pendingTasksCount = data
        .tasksForUser(userId)
        .where((t) => t.status == TaskStatus.pending)
        .length;
    final pendingMouCount = data.mouRequests
        .where((m) =>
            m.submittedById == userId && m.status == MouStatus.pending)
        .length;

    final sidebarItems = [
      SidebarItem(
          icon: Icons.task_alt,
          label: 'My Tasks',
          badgeCount: pendingTasksCount),
      const SidebarItem(
          icon: Icons.event_note, label: 'Minutes of Meeting'),
      SidebarItem(
          icon: Icons.local_hospital,
          label: 'Hospital MOU',
          badgeCount: pendingMouCount),
      const SidebarItem(
          icon: Icons.workspace_premium, label: 'Certificate'),
      const SidebarItem(icon: Icons.payment, label: 'Payments'),
    ];

    final screenTitles = [
      'My Tasks',
      'Minutes of Meeting',
      'Hospital MOU',
      'Certificate',
      'Payments',
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: CustomAppBar(
        title: screenTitles[_currentIndex],
        user: user,
        onThemeTap: () => theme.toggleTheme(),
        onSettingsTap: () {},
        onNotificationTap: () {},
      ),
      drawer: AppSidebar(
        items: sidebarItems,
        currentIndex: _currentIndex,
        onItemTap: (i) => setState(() => _currentIndex = i),
        user: user,
        onSignOut: () {
          auth.logout();
          context.go('/login');
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
    );
  }
}
