import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';
import 'package:starry_mind/features/galaxy/presentation/pages/galaxy_home_page.dart';

class StarryMindApp extends StatelessWidget {
  const StarryMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StarryMind',
      theme: AppTheme.build(),
      home: const GalaxyHomePage(),
    );
  }
}
