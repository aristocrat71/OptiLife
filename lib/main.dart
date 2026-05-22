import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/app_shell.dart';
import 'theme/theme.dart';

void main() {
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
