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

  static bool get enableApplePencilPlanner {
    return _prefs?.getBool('enableApplePencilPlanner') ?? false;
  }

  static Future<void> setEnableApplePencilPlanner(bool value) async {
    if (_prefs != null) {
      await _prefs!.setBool('enableApplePencilPlanner', value);
    }
  }

  static bool get enableCalendarExpenses {
    return _prefs?.getBool('enableCalendarExpenses') ?? false;
  }

  static Future<void> setEnableCalendarExpenses(bool value) async {
    if (_prefs != null) {
      await _prefs!.setBool('enableCalendarExpenses', value);
    }
  }

  static bool get enableRecurringTransactions {
    return _prefs?.getBool('enableRecurringTransactions') ?? false;
  }

  static Future<void> setEnableRecurringTransactions(bool value) async {
    if (_prefs != null) {
      await _prefs!.setBool('enableRecurringTransactions', value);
    }
  }
}
