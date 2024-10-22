import 'package:flutter/material.dart';
import 'package:to_do_app/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task To Do',
      theme: ThemeData(
        scaffoldBackgroundColor:Colors.white,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.),
        // useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}


