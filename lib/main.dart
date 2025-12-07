import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_mobile/firebase_options.dart';
import 'package:project_mobile/core/theme/app_theme.dart';
import 'package:project_mobile/services/auth_gate.dart';
import 'package:project_mobile/pages/onboarding.dart';
import 'package:project_mobile/services/notification_service.dart';
import 'package:project_mobile/widgets/lifecycle_manager.dart';
import 'package:project_mobile/providers/navbar_provider.dart';
import 'package:project_mobile/providers/signin_provider.dart';
import 'package:project_mobile/providers/watchlist_providers.dart';
import 'package:project_mobile/providers/daftar_provider.dart';
import 'package:project_mobile/providers/register_provider.dart';
import 'package:project_mobile/providers/editdata_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    await NotificationService().init(); 
  } catch (e) {
    debugPrint("Error saat inisialisasi service: $e");
  }

  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavBarProvider()),
        ChangeNotifierProvider(create: (_) => DaftarProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => SigninProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => EditDataProvider()),
      ],
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return LifecycleManager(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Netlify',
        theme: AppTheme.darkTheme,
        home: seenOnboarding ? const AuthGate() : const Onboarding(),
      ),
    );
  }
}