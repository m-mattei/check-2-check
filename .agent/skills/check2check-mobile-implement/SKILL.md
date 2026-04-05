---
name: check2check-mobile-implement
description: Implement features in the Check-2-Check Flutter mobile app. Use when adding new screens, widgets, services, or modifying existing mobile functionality.
license: MIT
compatibility: Requires Flutter SDK and Dart.
metadata:
  author: check2check
  version: "1.0"
  generatedBy: opencode
---

# Check-2-Check Mobile Implementation Skill

Implement features in the Check-2-Check Flutter mobile app following project conventions.

## Context

This skill is for the **Flutter mobile** project located at `check-2-check/`.

**Tech Stack:**
- Flutter/Dart
- Firebase Authentication
- HTTP client for API calls
- Provider/BLoC for state management (check existing patterns)

**Architecture:**
- Screens: `lib/screens/<name>_screen.dart`
- Services: `lib/services/<name>_service.dart`
- Models: `lib/models/<name>.dart`
- Utils: `lib/utils/<name>.dart`
- Widgets: `lib/widgets/<name>.dart`

## Workflow

### 1. OpenSpec Compliance (REQUIRED)

Before ANY code changes:
```bash
# Check for existing changes
ls openspec/changes/

# If no existing change covers the work, create one:
mkdir -p openspec/changes/<change-name>
# Create: .openspec.yaml, proposal.md, design.md, tasks.md, specs/
```

**Never write code without an OpenSpec change tracking it.**

### 2. Understand the Pattern

**Screens:**
- Named `<name>_screen.dart`
- Extend `StatefulWidget` or `StatelessWidget`
- Use theme from existing patterns
- Support dark/light mode if applicable

**Services:**
- Singleton pattern (like `AuthService`)
- Handle API calls to backend
- Error handling and loading states

**Models:**
- Match API DTOs from backend
- Include `fromJson()` and `toJson()` methods
- Handle timestamps properly

**State Management:**
- Check existing patterns (ValueNotifier, Provider, BLoC)
- Follow consistency with existing screens

### 3. Implementation Steps

For **new feature**:
1. Create model in `lib/models/`
2. Create service in `lib/services/` (if needed)
3. Create screen in `lib/screens/`
4. Add navigation routes
5. Add feature flag in `lib/utils/feature_flags.dart`
6. Add Dev Mode toggle in `lib/screens/dev_mode_screen.dart`

For **UI changes**:
1. Update existing screen or create new widget
2. Follow existing theme patterns
3. Test on both iOS and Android layouts

### 4. Code Conventions

- **No comments** unless explicitly requested
- Follow existing patterns (singleton services, ValueNotifier for theme)
- Use **feature flags** for new features
- No deprecated APIs
- Consistent naming with existing code

### 5. Feature Flags

Every new feature MUST have:
1. Toggle in `lib/utils/feature_flags.dart`
2. Dev Mode access in `lib/screens/dev_mode_screen.dart`

Example:
```dart
static bool get newFeature => _prefs.getBool('new_feature') ?? false;
static Future<void> setNewFeature(bool value) => _prefs.setBool('new_feature', value);
```

### 6. Testing

Before declaring done:
```bash
flutter analyze
flutter test
```

### 7. Documentation Sync

After code changes:
1. Update `tasks.md` in the openspec change: `- [ ]` → `- [x]`
2. Update docs: `docs/src/content/docs/features/<feature>.md`
3. Update index if needed: `docs/src/content/docs/index.md`
4. Archive when complete: `/opsx:archive <change-name>`

## Common Patterns

### New Screen
```dart
class <Name>Screen extends StatefulWidget {
  const <Name>Screen({super.key});
  
  @override
  State<<Name>Screen> createState() => _<Name>ScreenState();
}

class _<Name>ScreenState extends State<<Name>Screen> {
  // State and build method
}
```

### New Service (Singleton)
```dart
class <Name>Service {
  static final <Name>Service _instance = <Name>Service._internal();
  factory <Name>Service() => _instance;
  <Name>Service._internal();
  
  // Methods
}
```

### API Call Pattern
```dart
final response = await _client.get('/api/...');
if (response.statusCode == 200) {
  return Model.fromJson(json.decode(response.body));
} else {
  throw ApiException('Error message');
}
```

## Guardrails

- ALWAYS check OpenSpec first - no code without a change
- Run `flutter analyze` before declaring done
- Add feature flags for all new features
- Update documentation after changes
- Test on both platforms if UI changes
- Never commit without testing

## Commands

```bash
# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Build for release
flutter build apk --release  # Android
flutter build ios --release  # iOS
```
