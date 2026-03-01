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
import 'certificate_screen.dart';
import 'joining_letter_screen.dart';

class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({super.key});

  @override
  State<VolunteerDashboard> createState() =>
      _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  int _currentIndex = 0;

  static const _screens = [
    VolunteerMyTasksScreen(),
    VolunteerMinutesOfMeetingScreen(),
    VolunteerCertificateScreen(),
    VolunteerJoiningLetterScreen(),
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
          child:
              CircularProgressIndicator(color: AppColors.primaryTeal),
        ),
      );
    }

    final userId = user.id;
    final pendingTasksCount = data
        .tasksForUser(userId)
        .where((t) => t.status == TaskStatus.pending)
        .length;

    final sidebarItems = [
      SidebarItem(
          icon: Icons.task_alt,
          label: 'My Tasks',
          badgeCount: pendingTasksCount),
      const SidebarItem(
          icon: Icons.event_note, label: 'Minutes of Meeting'),
      const SidebarItem(
          icon: Icons.workspace_premium,
          label: 'Certificate of Completion'),
      const SidebarItem(
          icon: Icons.description, label: 'Joining Letter'),
    ];

    final screenTitles = [
      'My Tasks',
      'Minutes of Meeting',
      'Certificate of Completion',
      'Joining Letter',
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
