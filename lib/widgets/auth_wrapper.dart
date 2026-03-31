import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:check_2_check/services/auth_service.dart';
import 'package:check_2_check/screens/login_screen.dart';
import 'package:check_2_check/screens/main_navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  String? _localUsername;
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    _checkLocalAuth();
  }

  Future<void> _checkLocalAuth() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _localUsername = prefs.getString('local_username');
        _initializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // If Firebase User exists OR Local Username exists, show the app
        if (snapshot.hasData || _localUsername != null) {
          return const MainNavigationScreen();
        }

        // Otherwise, show login
        return const LoginScreen();
      },
    );
  }
}
