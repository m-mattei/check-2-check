import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeatureFlags {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('FeatureFlags: Failed to initialize SharedPreferences: $e');
    }
  }

  static bool get enableUsernameOnlyLogin {
    return _prefs?.getBool('enableUsernameOnlyLogin') ?? false;
  }

  static Future<void> setEnableUsernameOnlyLogin(bool value) async {
    if (_prefs != null) {
      await _prefs!.setBool('enableUsernameOnlyLogin', value);
    }
  }

  static bool get enableMainNavigationTabs {
    return _prefs?.getBool('enableMainNavigationTabs') ?? true;
  }

  static Future<void> setEnableMainNavigationTabs(bool value) async {
    if (_prefs != null) {
      await _prefs!.setBool('enableMainNavigationTabs', value);
    }
  }

  static bool get enablePlanPage {
    return _prefs?.getBool('enablePlanPage') ?? true;
  }

  static Future<void> setEnablePlanPage(bool value) async {
    if (_prefs != null) {
      await _prefs!.setBool('enablePlanPage', value);
    }
  }
}
