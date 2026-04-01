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
  late bool _enablePlanPage;
  late bool _enableApplePencilPlanner;
  late bool _enableCalendarExpenses;

  @override
  void initState() {
    super.initState();
    _enableUsernameOnly = FeatureFlags.enableUsernameOnlyLogin;
    _enableMainNavigationTabs = FeatureFlags.enableMainNavigationTabs;
    _enablePlanPage = FeatureFlags.enablePlanPage;
    _enableApplePencilPlanner = FeatureFlags.enableApplePencilPlanner;
    _enableCalendarExpenses = FeatureFlags.enableCalendarExpenses;
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

  Future<void> _togglePlanPage(bool value) async {
    await FeatureFlags.setEnablePlanPage(value);
    setState(() {
      _enablePlanPage = value;
    });
  }

  Future<void> _toggleApplePencilPlanner(bool value) async {
    await FeatureFlags.setEnableApplePencilPlanner(value);
    setState(() {
      _enableApplePencilPlanner = value;
    });
  }

  Future<void> _toggleCalendarExpenses(bool value) async {
    await FeatureFlags.setEnableCalendarExpenses(value);
    setState(() {
      _enableCalendarExpenses = value;
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
            subtitle: const Text(
              'Bypasses all Firebase auth requirements for fast development.',
            ),
            value: _enableUsernameOnly,
            onChanged: _toggleUsernameLogin,
          ),
          SwitchListTile(
            title: const Text('Enable Main Navigation Tabs'),
            subtitle: const Text(
              'Shows the Bottom Navigation Bar and multiple tabs instead of just the Calendar screen.',
            ),
            value: _enableMainNavigationTabs,
            onChanged: _toggleMainNavigation,
          ),
          SwitchListTile(
            title: const Text('Enable Plan Page'),
            subtitle: const Text(
              'Shows the Plan tab in the bottom navigation bar.',
            ),
            value: _enablePlanPage,
            onChanged: _togglePlanPage,
          ),
          SwitchListTile(
            title: const Text('Enable Apple Pencil Planner Mode'),
            subtitle: const Text(
              'Shows a traditional paper planner layout on iOS/iPadOS.',
            ),
            value: _enableApplePencilPlanner,
            onChanged: _toggleApplePencilPlanner,
          ),
          SwitchListTile(
            title: const Text('Enable Calendar Expenses'),
            subtitle: const Text(
              'Shows expenses on the calendar alongside paychecks.',
            ),
            value: _enableCalendarExpenses,
            onChanged: _toggleCalendarExpenses,
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
