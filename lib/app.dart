import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/router/app_router.dart';
import 'config/theme/dark_theme.dart';
import 'config/theme/light_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';

class JayshreeFoundationApp extends StatefulWidget {
  const JayshreeFoundationApp({super.key});

  @override
  State<JayshreeFoundationApp> createState() => _JayshreeFoundationAppState();
}

class _JayshreeFoundationAppState extends State<JayshreeFoundationApp> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _router ??= createRouter(context.read<AuthProvider>());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: 'Jayshree Foundation',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _router!,
    );
  }
}
