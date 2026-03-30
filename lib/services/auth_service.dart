import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Singleton pattern to prevent initializing GoogleSignIn multiple times on the web
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '462993823923-tof1c5i8hhskib5frors946f4572d5h1.apps.googleusercontent.com',
  );

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signIn()
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Sign-in timed out. Check your Firebase or Google Sign-In configuration.'),
          );
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginLocallyWithUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('local_username', username);
  }

  Future<String?> getLocalUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('local_username');
  }

  Future<void> logoutLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('local_username');
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
