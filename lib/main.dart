import 'package:casacare/client_screens/client_notifcation_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'client_screens/client_home_screen.dart';
import 'client_screens/client_services_screen.dart';
import 'client_screens/client_settings_screen.dart';
import 'client_screens/client_appointment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'api/firebase_api.dart';
import 'client_screens/client_notifcation_page.dart';
import 'package:provider/provider.dart';
import 'client_screens/notification_message.dart';
Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  await FirebasApi().initNotifications();
  await Supabase.initialize(
    url: '',
    anonKey: '',
  );
  await _resetDropdownOnStartup();
    runApp( MyApp());

}

Future<void> _resetDropdownOnStartup() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove('selected_house'); // Clear the saved value
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationProvider(),
      child: MaterialApp(
        title: 'Task Scheduler',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login', // Start at the login screen
        routes: {
          '/login': (context) => const LoginScreen(),
          '/Home': (context) => const ClientHomeScreen(),
          '/Appointments': (context) => const AppointmentsScreen(),
          '/Services': (context) => const ClientServicesScreen(),
          '/Notifications':(context) =>  NotificationsPage(),
          '/Settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
