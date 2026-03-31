import 'package:flutter/material.dart';
import 'package:check_2_check/services/auth_service.dart';
import 'package:check_2_check/main.dart';
import 'package:check_2_check/widgets/auth_wrapper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  UserProfile? _profile;
  ThemeMode _currentThemeMode = ThemeService.themeMode.value;
  Color _primaryColor = ThemeService.primaryColor.value;
  Color _secondaryColor = ThemeService.secondaryColor.value;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    ThemeService.themeMode.addListener(_onThemeChanged);
    ThemeService.primaryColor.addListener(_onPrimaryColorChanged);
    ThemeService.secondaryColor.addListener(_onSecondaryColorChanged);
  }

  @override
  void dispose() {
    ThemeService.themeMode.removeListener(_onThemeChanged);
    ThemeService.primaryColor.removeListener(_onPrimaryColorChanged);
    ThemeService.secondaryColor.removeListener(_onSecondaryColorChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {
        _currentThemeMode = ThemeService.themeMode.value;
      });
    }
  }

  void _onPrimaryColorChanged() {
    if (mounted) {
      setState(() {
        _primaryColor = ThemeService.primaryColor.value;
      });
    }
  }

  void _onSecondaryColorChanged() {
    if (mounted) {
      setState(() {
        _secondaryColor = ThemeService.secondaryColor.value;
      });
    }
  }

  Future<void> _loadProfile() async {
    final profile = _authService.isFirebaseUser
        ? _authService.getCurrentProfile()
        : await _authService.getLocalProfile();
    if (mounted) {
      setState(() {
        _profile = profile;
      });
    }
  }

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This feature is coming soon. Account deletion functionality will be available in a future update.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleThemeToggle(ThemeMode mode) {
    ThemeService.setThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        children: [
          _buildUserHeader(),
          const Divider(),
          _buildAppearanceSection(),
          const Divider(),
          _buildAccountSection(),
          const Divider(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    final displayName = _profile?.displayName ?? 'Loading...';
    final email = _profile?.email;
    final photoURL = _profile?.photoURL;
    final isFirebaseUser = _profile?.isFirebaseUser ?? false;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: photoURL == null
                ? Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 40),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (email != null) ...[
            const SizedBox(height: 4),
            Text(
              email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isFirebaseUser
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              isFirebaseUser ? 'Firebase User' : 'Local User',
              style: TextStyle(
                color: isFirebaseUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.brightness_6),
          title: const Text('Theme'),
          subtitle: Text(_getThemeLabel(_currentThemeMode)),
          trailing: PopupMenuButton<ThemeMode>(
            initialValue: _currentThemeMode,
            onSelected: _handleThemeToggle,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ThemeMode.system,
                child: Text('System'),
              ),
              const PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
              const PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.palette),
          title: const Text('Primary Color'),
          subtitle: Text(_colorName(_primaryColor)),
          trailing: GestureDetector(
            onTap: () => _showColorPicker(true),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text('Secondary Color'),
          subtitle: Text(_colorName(_secondaryColor)),
          trailing: GestureDetector(
            onTap: () => _showColorPicker(false),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _secondaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showColorPicker(bool isPrimary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isPrimary ? 'Primary Color' : 'Secondary Color'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ThemeService.availableColors.map((color) {
                  final isSelected = isPrimary
                      ? _primaryColor == color
                      : _secondaryColor == color;
                  return GestureDetector(
                    onTap: () {
                      if (isPrimary) {
                        ThemeService.setPrimaryColor(color);
                      } else {
                        ThemeService.setSecondaryColor(color);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.colorize),
                title: const Text('Custom Color...'),
                onTap: () {
                  Navigator.pop(context);
                  _showCustomColorPicker(isPrimary);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCustomColorPicker(bool isPrimary) {
    final currentColor = isPrimary ? _primaryColor : _secondaryColor;
    var selectedColor = currentColor;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Pick a Custom Color'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              Slider(
                value: selectedColor.r,
                onChanged: (v) {
                  setDialogState(() {
                    selectedColor = Color.fromRGBO(
                      (v * 255).round(),
                      (selectedColor.g * 255).round(),
                      (selectedColor.b * 255).round(),
                      selectedColor.a,
                    );
                  });
                },
                label: 'R: ${(selectedColor.r * 255).round()}',
              ),
              Slider(
                value: selectedColor.g,
                onChanged: (v) {
                  setDialogState(() {
                    selectedColor = Color.fromRGBO(
                      (selectedColor.r * 255).round(),
                      (v * 255).round(),
                      (selectedColor.b * 255).round(),
                      selectedColor.a,
                    );
                  });
                },
                label: 'G: ${(selectedColor.g * 255).round()}',
              ),
              Slider(
                value: selectedColor.b,
                onChanged: (v) {
                  setDialogState(() {
                    selectedColor = Color.fromRGBO(
                      (selectedColor.r * 255).round(),
                      (selectedColor.g * 255).round(),
                      (v * 255).round(),
                      selectedColor.a,
                    );
                  });
                },
                label: 'B: ${(selectedColor.b * 255).round()}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (isPrimary) {
                  ThemeService.setPrimaryColor(selectedColor);
                } else {
                  ThemeService.setSecondaryColor(selectedColor);
                }
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Account',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Sign Out'),
          onTap: _handleSignOut,
        ),
        ListTile(
          leading: Icon(
            Icons.delete_forever,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            'Delete Account',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          onTap: _handleDeleteAccount,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Text(
          'Version 1.0.0+1',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  String _colorName(Color color) {
    final presetNames = {
      Colors.blue: 'Blue',
      Colors.red: 'Red',
      Colors.green: 'Green',
      Colors.orange: 'Orange',
      Colors.purple: 'Purple',
      Colors.teal: 'Teal',
      Colors.pink: 'Pink',
      Colors.indigo: 'Indigo',
      Colors.amber: 'Amber',
      Colors.cyan: 'Cyan',
    };
    return presetNames[color] ?? 'Custom';
  }
}
