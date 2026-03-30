import 'package:flutter/material.dart';

void main() {
  runApp(const Check2CheckApp());
}

class Check2CheckApp extends StatelessWidget {
  const Check2CheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check-2-Check',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('Check-2-Check'))),
    );
  }
}
