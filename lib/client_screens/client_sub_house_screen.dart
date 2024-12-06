import 'package:casacare/client_screens/client_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/login_screen.dart';
import 'client_services_screen.dart';
import 'dart:convert';
import 'client_add_house_screen.dart';
import 'package:casacare/custom_widgets/select_house_dropdown.dart';
import 'package:intl/intl.dart';


class HouseSubScreen extends StatefulWidget {
  const HouseSubScreen({super.key});

  @override
  State<HouseSubScreen> createState() => _HouseSubScreenState();
}

class _HouseSubScreenState extends State<HouseSubScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final email = Supabase.instance.client.auth.currentUser?.email;
  String? selectedHouse;
   Future<void> _subscribe(BuildContext context) async {
        
        if(selectedHouse!=null){
           final subscribed =await supabase.from('houses').select('houseSubscribed').eq('House_id', selectedHouse.toString());
        bool check =subscribed[0]['houseSubscribed'];

        if (check== false){
          DateTime today = DateTime.now();
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
        
          await supabase.from('houses').update({'Services_to_Do': jsonString,'houseSubscribed': true}).eq('House_id', selectedHouse.toString());
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscribed',textScaler: TextScaler.linear(2),)));
        } else{
                  ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('House Already Subscribed',textScaler: TextScaler.linear(2),)));
        }
        }
       else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No House Selected',textScaler: TextScaler.linear(2),)));
       }

    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen(),),
      (route) => false,

    );
  }
void handleSelection(String value) {
    selectedHouse=value;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscribe'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
             Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen(),),
      (route) => false,

    );
          },
        ),
        
      ),
      body: 
        Column(
          children: [
          HouseDropdownArrayWidget(
            rowId: email.toString(), 
            onValueSelected: handleSelection,
          ),
          ElevatedButton(
              onPressed: () => _subscribe(context),
              child: const Text('Subscribe'),
            ),
        ],
        ),
        backgroundColor: Colors.white,
        
      );
  }
}