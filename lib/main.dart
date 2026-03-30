import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:check_2_check/firebase_options.dart';
import 'package:check_2_check/services/auth_service.dart';
import 'package:check_2_check/screens/calendar_screen.dart';
import 'package:check_2_check/screens/login_screen.dart';
import 'package:check_2_check/screens/dev_mode_screen.dart';
import 'package:check_2_check/screens/main_navigation_screen.dart';
import 'package:check_2_check/utils/feature_flags.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FeatureFlags.init();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase Initialization Error: $e');
  }
  runApp(const Check2CheckApp());
}

class Check2CheckApp extends StatelessWidget {
  const Check2CheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check-2-Check',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: kDebugMode ? '/dev' : '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/dev': (context) => const DevModeScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (FeatureFlags.enableUsernameOnlyLogin) {
      return FutureBuilder<String?>(
        future: AuthService().getLocalUsername(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData && snapshot.data != null) {
            return FeatureFlags.enableMainNavigationTabs 
              ? const MainNavigationScreen() 
              : const CalendarScreen();
          }
          return const LoginScreen();
        },
      );
    }

    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Firebase Auth Error:\n${snapshot.error}', textAlign: TextAlign.center),
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return FeatureFlags.enableMainNavigationTabs 
            ? const MainNavigationScreen() 
            : const CalendarScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
