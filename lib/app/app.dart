import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

class MyEarApp extends StatelessWidget {
  const MyEarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Ear App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Respects system theme
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.home,
    );
  }
}
