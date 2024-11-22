import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/login_screen.dart';
import 'client_home_screen.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  
  


  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
    
  }
   Future<void> _subscribe(BuildContext context) async {
        final SupabaseClient supabase = Supabase.instance.client;
  final email = Supabase.instance.client.auth.currentUser?.email;
   final subscribed =await supabase.from('clients').select('isSubscribed').eq('Client_Email', email.toString());
    bool check =subscribed[0]['isSubscribed'];

    if (check== false){
      DateTime today = new DateTime.now();
      final Map<String, dynamic> servicesHashTable = {
          "Water Heater/Tank Flush": {"Amount": 1, "Notification_Date": today.add(const Duration(days: 1)).toIso8601String(), "Status": "Not Ready"},
          "Smoke and CO2 Detector Battery Replacement": {"Amount": 2, "Notification_Date": today.add(const Duration(days: 2)).toIso8601String(), "Status": "Not Ready"},
          "HVAC Maintenence": {"Amount": 2, "Notification_Date": today.add(const Duration(days: 3)).toIso8601String(), "Status": "Not Ready"},
          "Free Car Wash": {"Amount": 4, "Notification_Date": today.add(const Duration(days: 4)).toIso8601String(), "Status": "Not Ready"},
          "Sewer Line Cleanout (Hydrojet)": {"Amount": 1, "Notification_Date": today.add(const Duration(days: 45)).toIso8601String(), "Status": "Not Ready"},
          "Airduct Cleaning": {"Amount": 1, "Notification_Date": today.add(const Duration(days: 180)).toIso8601String(), "Status": "Not Ready"},
          "Power Wash Home Exterior": {"Amount": 1, "Notification_Date": today.add(const Duration(days: 200)).toIso8601String(), "Status": "Not Ready"},
      };
      String jsonString = jsonEncode(servicesHashTable);
     
      await supabase.from('clients').update({'Services_To_Do': jsonString,'isSubscribed': true}).eq('Client_Email', email.toString());
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Subscribed',textScaler: TextScaler.linear(2),)));
    } else{
               ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Already Subscribed',textScaler: TextScaler.linear(2),)));
    }

    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ClientHomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _subscribe(context),
              child: const Text('Subscribe'),
            ),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}