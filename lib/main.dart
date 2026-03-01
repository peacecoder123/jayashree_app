import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/app_data_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HopeConnectRoot());
}

class HopeConnectRoot extends StatelessWidget {
  const HopeConnectRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppDataProvider()),
        ChangeNotifierProxyProvider<AppDataProvider, AuthProvider>(
          create: (_) => AuthProvider(),
          update: (_, __, auth) => auth!,
        ),
      ],
      child: const HopeConnectApp(),
    );
  }
}
