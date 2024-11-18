import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hanfthixsuxjhqetiaja.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhbmZ0aGl4c3V4amhxZXRpYWphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE3MzgyMTMsImV4cCI6MjA0NzMxNDIxM30.u2WCvklAI4VNZ3PNeq_OfM3YDA6vbLFmbi3spLykx74',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Scheduler',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}