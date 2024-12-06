import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/login_screen.dart';
import 'client_add_house_screen.dart';
import 'client_sub_house_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:casacare/custom_widgets/nav_bar.dart';
import 'client_notifcation_page.dart';
import 'notification_message.dart'; 
import 'package:provider/provider.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

final routes = {
      0: '/Home', 
      1: '/Appointments', 
      2: '/Services',
      3: '/Notifications',
      4: '/Settings',
    };
  Future<void> _clearSelectedValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_house'); // Clear the saved value
  }
  


  Future<void> _logout(BuildContext context) async {
    await _clearSelectedValue();
 
    await Supabase.instance.client.auth.signOut();
     final provider = Provider.of<NotificationProvider>(context, listen: false);

  // Clear notifications from provider
  provider.clearNotifications();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'),backgroundColor: Colors.blue,centerTitle: true,automaticallyImplyLeading: false,),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HouseSubScreen()),
          ),
              child: const Text('Subscribe Home'),
            ),
             ElevatedButton(
              onPressed: () =>  Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AddHouseScreen()),
          ),
              child: const Text('Add Home'),
            ),
            
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
       bottomNavigationBar: CustomNavigationBar(
        currentIndex: 4, // Search tab index
        routes: routes, // Pass routes map
        parentContext: context,
      ),
    );
  }
}