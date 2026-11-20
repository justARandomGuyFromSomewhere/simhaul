import 'package:flutter/material.dart';
import 'app/routes.dart';
import 'app/theme.dart';

void main() {
  runApp(const HaulCalcApp());
}

class HaulCalcApp extends StatelessWidget {
  const HaulCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haulage & Fleet Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
