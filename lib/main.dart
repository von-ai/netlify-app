import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'providers/navbar_provider.dart';
import 'widgets/navbar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NavBarProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watch List App',
      theme: AppTheme.darkTheme,
      home: NavBar(),
      // penting: panggil NavBar di sini
    );
  }
}
