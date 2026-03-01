import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../screens/public/landing_page.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/superadmin/superadmin_dashboard.dart';
import '../../screens/admin/admin_dashboard.dart';
import '../../screens/member/member_dashboard.dart';
import '../../screens/volunteer/volunteer_dashboard.dart';

// ─── Route names ─────────────────────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  static const String landing = '/';
  static const String login = '/login';
  static const String superAdmin = '/superadmin';
  static const String admin = '/admin';
  static const String member = '/member';
  static const String volunteer = '/volunteer';
  static const String dashboard = '/dashboard';
  static const String tasks = '/tasks';
  static const String meetings = '/meetings';
  static const String donations = '/donations';
  static const String mou = '/mou';
  static const String certificates = '/certificates';
  static const String documents = '/documents';
  static const String members = '/members';
  static const String volunteers = '/volunteers';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String joiningLetters = '/joining-letters';
}

// ─── Router factory ──────────────────────────────────────────────────────────
// Pass the AuthProvider directly so GoRouter's refreshListenable receives the
// live ChangeNotifier instance and is notified on every auth state change.
GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: AppRoutes.landing,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isLoggedIn = authProvider.isAuthenticated;
      final location = state.matchedLocation;
      final publicPaths = [AppRoutes.landing, AppRoutes.login];

      if (!isLoggedIn && !publicPaths.contains(location)) {
        return AppRoutes.login;
      }
      if (isLoggedIn && location == AppRoutes.login) {
        // Redirect to role-specific dashboard
        if (authProvider.isSuperAdmin) return AppRoutes.superAdmin;
        if (authProvider.isAdmin) return AppRoutes.admin;
        if (authProvider.isMember) return AppRoutes.member;
        if (authProvider.isVolunteer) return AppRoutes.volunteer;
        return AppRoutes.login;
      }
      if (isLoggedIn && location == AppRoutes.landing) {
        // Redirect authenticated users from landing page to their dashboard
        if (authProvider.isSuperAdmin) return AppRoutes.superAdmin;
        if (authProvider.isAdmin) return AppRoutes.admin;
        if (authProvider.isMember) return AppRoutes.member;
        if (authProvider.isVolunteer) return AppRoutes.volunteer;
      }
      if (isLoggedIn && location == AppRoutes.dashboard) {
        // Redirect from generic /dashboard to role-specific
        if (authProvider.isSuperAdmin) return AppRoutes.superAdmin;
        if (authProvider.isAdmin) return AppRoutes.admin;
        if (authProvider.isMember) return AppRoutes.member;
        if (authProvider.isVolunteer) return AppRoutes.volunteer;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.landing,
        name: 'landing',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.superAdmin,
        name: 'superAdmin',
        builder: (context, state) => const SuperAdminDashboard(),
      ),
      GoRoute(
        path: AppRoutes.admin,
        name: 'admin',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: AppRoutes.member,
        name: 'member',
        builder: (context, state) => const MemberDashboard(),
      ),
      GoRoute(
        path: AppRoutes.volunteer,
        name: 'volunteer',
        builder: (context, state) => const VolunteerDashboard(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.landing),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
