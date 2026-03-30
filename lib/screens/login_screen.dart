import 'package:flutter/material.dart';
import 'package:check_2_check/services/auth_service.dart';
import 'package:check_2_check/screens/dev_mode_screen.dart';
import 'package:check_2_check/utils/feature_flags.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign-in failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithUsername() async {
    if (_usernameController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    await _authService.loginLocallyWithUsername(_usernameController.text.trim());
    // Navigation is handled automatically by AuthWrapper reacting to SharedPreferences stream changes!
    // Wait, AuthWrapper is a StreamBuilder over Firebase Auth. 
    // It doesn't listen to SharedPreferences. We must trigger a rebuild or navigate.
    if (mounted) {
      // Force reload auth state by navigating or let the developer force reload.
      // To keep it simple, we push replacement to trigger main wrapper again.
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool useBypass = FeatureFlags.enableUsernameOnlyLogin;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_applications),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DevModeScreen())).then((_) {
                setState(() {}); // refresh if flag changed
              });
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Check-2-Check', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 48),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (useBypass) ...[
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username (Dev Bypass)'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loginWithUsername,
                  child: const Text('Continue'),
                )
              ] else ...[
                ElevatedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
