import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/firebase_options.dart';
// import 'package:project_mobile/pages/onboarding.dart';
import 'package:project_mobile/widgets/navbar.dart';
import 'core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'providers/navbar_provider.dart';
import 'providers/daftar_provider.dart';
import 'package:project_mobile/providers/register_provider.dart';
// import 'pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavBarProvider()),
        ChangeNotifierProvider(create: (_) => DaftarProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
      ],
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
    );
  }
}
