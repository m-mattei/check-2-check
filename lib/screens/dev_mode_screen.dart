import 'package:flutter/material.dart';
import 'package:check_2_check/utils/feature_flags.dart';

class DevModeScreen extends StatefulWidget {
  const DevModeScreen({super.key});

  @override
  State<DevModeScreen> createState() => _DevModeScreenState();
}

class _DevModeScreenState extends State<DevModeScreen> {
  late bool _enableUsernameOnly;
  late bool _enableMainNavigationTabs;

  @override
  void initState() {
    super.initState();
    _enableUsernameOnly = FeatureFlags.enableUsernameOnlyLogin;
    _enableMainNavigationTabs = FeatureFlags.enableMainNavigationTabs;
  }

  Future<void> _toggleUsernameLogin(bool value) async {
    await FeatureFlags.setEnableUsernameOnlyLogin(value);
    setState(() {
      _enableUsernameOnly = value;
    });
  }

  Future<void> _toggleMainNavigation(bool value) async {
    await FeatureFlags.setEnableMainNavigationTabs(value);
    setState(() {
      _enableMainNavigationTabs = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Options'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Username-Only Login Bypass'),
            subtitle: const Text('Bypasses all Firebase auth requirements for fast development.'),
            value: _enableUsernameOnly,
            onChanged: _toggleUsernameLogin,
          ),
          SwitchListTile(
            title: const Text('Enable Main Navigation Tabs'),
            subtitle: const Text('Shows the Bottom Navigation Bar and multiple tabs instead of just the Calendar screen.'),
            value: _enableMainNavigationTabs,
            onChanged: _toggleMainNavigation,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/');
        },
        icon: const Icon(Icons.rocket_launch),
        label: const Text('Launch App'),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
