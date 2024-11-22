import 'dart:convert';

import 'package:casacare/client_screens/client_not_subscribed.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'client_booking_screen.dart';
import 'client_settings_screen.dart';
import 'client_complete_screen.dart';
import 'client_not_subscribed.dart';
import 'client_not_ready.dart';
import 'client_reschedule.dart';





class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({Key? key}) : super(key: key);

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final email =  Supabase.instance.client.auth.currentUser?.email;
  var services = [];
  bool subscribed=false;
  Map<String, dynamic> serviceHash=<String, dynamic>{};//update when adding services

  
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Fetch all required data
    await Future.wait([
      _fetchServices(),
      _fetchSubscribed(),
      _fetchHash(),
    ]);
  }

  Future<void> _fetchServices() async {
    
    final response= await supabase.from('services').select('Service_Name, Service_Description');
      setState(() {
        services = response;
        //print(services);
      });

  }
  Future<void> _fetchSubscribed() async {
    
    
    final response =await supabase.from('clients').select('isSubscribed').eq('Client_Email', email.toString());
      setState(() {
        subscribed=response[0]['isSubscribed'];
        //print(subscribed);
      });
  }
    Future<void> _fetchHash() async {
    final check =await supabase.from('clients').select('isSubscribed').eq('Client_Email', email.toString());
    if(check[0]['isSubscribed']==true){
      
      final response =await supabase.from('clients').select('Services_To_Do').eq('Client_Email', email.toString());
      setState(() {
       serviceHash=jsonDecode(response[0]['Services_To_Do']);

      });
    }
    
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Service Booking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          Color textColor=Colors.white;
          if(!subscribed){
            textColor=Colors.black;
          } else if(serviceHash[service['Service_Name']]?["Amount"] == 0){
            textColor=Colors.blue;
          }
          else if(serviceHash[service['Service_Name']]?["Status"] == "Not Ready"){
            textColor=Colors.red;
          }
          else if(serviceHash[service['Service_Name']]?["Status"] == "Ready to Schedule"){
            textColor=Colors.yellow;
          }
          else if(serviceHash[service['Service_Name']]?["Status"] == "Scheduled"){
            textColor=Colors.green;
          }
          return ListTile(
            title: Text(
              service['Service_Name'],
              style: TextStyle(color: textColor),
              ),
            onTap: () {
              if(textColor==Colors.black){
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotSubScreen(service: service),
                ),
              );
              } else if(textColor==Colors.yellow){
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(service: service, serviceHash: serviceHash),
                ),
              );
              } else if(textColor==Colors.blue){
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientCompleteScreen(service: service),
                ),
              );
              }  else if(textColor==Colors.red){
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotReadyScreen(service: service, serviceHash: serviceHash),
                ),
              );
              } else if(textColor==Colors.green){
                /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientRescheduleScreen(service: service, serviceHash: serviceHash)
                ),
              );*/   
              }
            },
          );
        },
      ),
    );
  }
}