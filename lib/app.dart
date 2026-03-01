import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/router/app_router.dart';
import 'config/theme/dark_theme.dart';
import 'config/theme/light_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';

class HopeConnectApp extends StatefulWidget {
  const HopeConnectApp({super.key});

  @override
  State<HopeConnectApp> createState() => _HopeConnectAppState();
}

class _HopeConnectAppState extends State<HopeConnectApp> {
  late final _router = createRouter(context);

  @override
  Widget build(BuildContext context) {
    // Rebuild router when auth state changes
    context.watch<AuthProvider>();

    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: 'HopeConnect',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _router,
    );
  }
}
