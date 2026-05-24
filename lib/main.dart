import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/app_shell.dart';
import 'services/notifications.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Reminders.init(); // tz data + local-notifications plugin
  // Strictly portrait — the layout (shell, biome framing) assumes it.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: OptiLifeApp()));
}

class OptiLifeApp extends StatelessWidget {
  const OptiLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OptiLife',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: const AppShell(),
    );
  }
}
