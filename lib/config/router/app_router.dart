import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

// ─── Placeholder screens (replace with real screens as you build them) ───────
class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text(title, style: Theme.of(context).textTheme.headlineSmall)),
      );
}

// ─── Route names ─────────────────────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
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
GoRouter createRouter(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final isLoggedIn = authProvider.isAuthenticated;
      final goingToLogin = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !goingToLogin) return AppRoutes.login;
      if (isLoggedIn && goingToLogin) return AppRoutes.dashboard;
      return null;
    },
    refreshListenable: authProvider,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const _Placeholder('Login'),
      ),
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const _Placeholder('Dashboard'),
          ),
          GoRoute(
            path: AppRoutes.tasks,
            name: 'tasks',
            builder: (context, state) => const _Placeholder('Tasks'),
          ),
          GoRoute(
            path: AppRoutes.meetings,
            name: 'meetings',
            builder: (context, state) => const _Placeholder('Meetings'),
          ),
          GoRoute(
            path: AppRoutes.donations,
            name: 'donations',
            builder: (context, state) => const _Placeholder('Donations'),
          ),
          GoRoute(
            path: AppRoutes.mou,
            name: 'mou',
            builder: (context, state) => const _Placeholder('MOU Requests'),
          ),
          GoRoute(
            path: AppRoutes.certificates,
            name: 'certificates',
            builder: (context, state) => const _Placeholder('Certificates'),
          ),
          GoRoute(
            path: AppRoutes.documents,
            name: 'documents',
            builder: (context, state) => const _Placeholder('Documents'),
          ),
          GoRoute(
            path: AppRoutes.members,
            name: 'members',
            builder: (context, state) => const _Placeholder('Members'),
          ),
          GoRoute(
            path: AppRoutes.volunteers,
            name: 'volunteers',
            builder: (context, state) => const _Placeholder('Volunteers'),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const _Placeholder('Profile'),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const _Placeholder('Settings'),
          ),
          GoRoute(
            path: AppRoutes.joiningLetters,
            name: 'joiningLetters',
            builder: (context, state) => const _Placeholder('Joining Letters'),
          ),
        ],
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
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
}
