import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/app_data_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Note: The browser console may show "Intl.v8BreakIterator is deprecated.
  // Please use Intl.Segmenter instead." This is a known non-blocking warning
  // originating from the browser's JS runtime (used by the `intl` Dart package
  // on web). No code change is required; it will resolve when the browser and
  // SDK update their internal implementations.
  runApp(const JayshreeFoundationRoot());
}

class JayshreeFoundationRoot extends StatelessWidget {
  const JayshreeFoundationRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppDataProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const JayshreeFoundationApp(),
    );
  }
}
