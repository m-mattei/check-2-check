import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:check_2_check/firebase_options.dart';
import 'package:check_2_check/widgets/auth_wrapper.dart';
import 'package:check_2_check/utils/feature_flags.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FeatureFlags.init();
  await ThemeService.init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase Initialization failed: $e');
  }

  runApp(const Check2CheckApp());
}

class ThemeService {
  static SharedPreferences? _prefs;
  static const _themeKey = 'theme_mode';
  static const _primaryColorKey = 'primary_color';
  static const _secondaryColorKey = 'secondary_color';

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.system,
  );
  static final ValueNotifier<Color> primaryColor = ValueNotifier(Colors.blue);
  static final ValueNotifier<Color> secondaryColor = ValueNotifier(Colors.teal);

  static const List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
  ];

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedTheme = _prefs?.getString(_themeKey);
    if (savedTheme != null) {
      themeMode.value = ThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }

    final savedPrimary = _prefs?.getInt(_primaryColorKey);
    if (savedPrimary != null) {
      primaryColor.value = Color(savedPrimary);
    }

    final savedSecondary = _prefs?.getInt(_secondaryColorKey);
    if (savedSecondary != null) {
      secondaryColor.value = Color(savedSecondary);
    }
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _prefs?.setString(_themeKey, mode.name);
  }

  static Future<void> setPrimaryColor(Color color) async {
    primaryColor.value = color;
    await _prefs?.setInt(_primaryColorKey, color.toARGB32());
  }

  static Future<void> setSecondaryColor(Color color) async {
    secondaryColor.value = color;
    await _prefs?.setInt(_secondaryColorKey, color.toARGB32());
  }
}

class Check2CheckApp extends StatelessWidget {
  const Check2CheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        ThemeService.themeMode,
        ThemeService.primaryColor,
        ThemeService.secondaryColor,
      ]),
      builder: (context, _) {
        final primary = ThemeService.primaryColor.value;
        final secondary = ThemeService.secondaryColor.value;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Check-2-Check',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: primary,
              brightness: Brightness.light,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: secondary),
              bodyMedium: TextStyle(color: secondary),
              bodySmall: TextStyle(color: secondary.withValues(alpha: 0.8)),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: secondary,
              unselectedItemColor: secondary.withValues(alpha: 0.5),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: primary,
              brightness: Brightness.dark,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: secondary),
              bodyMedium: TextStyle(color: secondary),
              bodySmall: TextStyle(color: secondary.withValues(alpha: 0.8)),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: secondary,
              unselectedItemColor: secondary.withValues(alpha: 0.5),
            ),
            useMaterial3: true,
          ),
          themeMode: ThemeService.themeMode.value,
          home: const AuthWrapper(),
        );
      },
    );
  }
}
