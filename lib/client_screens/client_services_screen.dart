import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'client_booking_screen.dart';
import 'client_complete_screen.dart';
import 'client_not_subscribed.dart';
import 'client_not_ready.dart';
import 'client_reschedule.dart';
import 'package:casacare/custom_widgets/select_house_dropdown.dart';
import 'package:casacare/custom_widgets/nav_bar.dart';

class ClientServicesScreen extends StatefulWidget {
  const ClientServicesScreen({super.key});

  @override
  State<ClientServicesScreen> createState() => _ClientServicesScreenState();
}

class _ClientServicesScreenState extends State<ClientServicesScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final email = Supabase.instance.client.auth.currentUser?.email;

  List<dynamic> services = []; // List of services
  bool subscribed = false;
  Map<String, dynamic> serviceHash = {};
  String? selectedValue; // Selected house ID
  final routes = {
      0: '/Home', 
      1: '/Appointments', 
      2: '/Services',
      3: '/Notifications',
      4: '/Settings',
    };

  @override
  void initState() {
    super.initState();
    _loadSelectedValue();
    _fetchServices();
  }
  Future<void> _loadSelectedValue() async {

    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getString('selected_house');
    if (savedValue != null) {
      setState(() {
        selectedValue = savedValue;
      });
      // Fetch data for the saved selection
      _fetchSubscribed();
      _fetchHash();
    }
  }
   Future<void> _saveSelectedValue(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_house', value);
  }

  Future<void> _fetchServices() async {
    
    try {
      final response = await supabase.from('services').select('Service_Name, Service_Description');
      setState(() {
        services = response;
      });
    } catch (e) {
      print('Error fetching services: $e');
      
    }
  }

  Future<void> _fetchSubscribed() async {
    try {
      final response = await supabase
          .from('houses')
          .select('houseSubscribed')
          .eq('House_id', selectedValue.toString())
          .single();

      setState(() {
        subscribed = response['houseSubscribed'];
      });
    } catch (e) {
      print('Error fetching subscription status: $e');
    }
  }

  Future<void> _fetchHash() async {
    try {
      final check = await supabase
          .from('houses')
          .select('houseSubscribed')
          .eq('House_id', selectedValue.toString())
          .single();

      if (check['houseSubscribed'] == true) {
        final response = await supabase
            .from('houses')
            .select('Services_to_Do')
            .eq('House_id', selectedValue.toString())
            .single();

        setState(() {
          serviceHash = jsonDecode(response['Services_to_Do']);
        });
      }
    } catch (e) {
      print('Error fetching service hash: $e');
    }
  }

  void handleSelection(String uuid) {
    setState(() {
      selectedValue = uuid;
    });
 _saveSelectedValue(uuid);
    // Fetch subscription status and services for the selected house
    _fetchSubscribed();
    _fetchHash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Service Booking'),
        automaticallyImplyLeading: false
      ),
      body: Column(
        children: [
          // Dropdown for selecting a house
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: HouseDropdownArrayWidget(
              rowId: email.toString(),
              onValueSelected: handleSelection,
            ),
          ),
          const SizedBox(height: 16),
          // Service list
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                Color textColor = Colors.white;

                // Determine text color based on subscription and service status
                if (!subscribed) {
                  textColor = Colors.white;
                } else if (serviceHash[service['Service_Name']]?["Status"] == "Completed") {
                  textColor = Colors.blue;
                } else if (serviceHash[service['Service_Name']]?["Status"] == "Not Ready") {
                  textColor = Colors.red;
                } else if (serviceHash[service['Service_Name']]?["Status"] == "Ready to Schedule") {
                  textColor = const Color.fromARGB(255, 247, 223, 13);
                } else if (serviceHash[service['Service_Name']]?["Status"] == "Scheduled") {
                  textColor = Colors.green;
                }

                return ListTile(
                  title: SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: Card(
                      color: textColor,
                      child: Center(
                        child: Text(
                          service['Service_Name'],style:const TextStyle(fontSize: 18),textAlign: TextAlign.center,
                        ),
                      ),
                      
                    ),
                    
                  ),
                  onTap: () {
                    if (textColor == Colors.black) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotSubScreen(service: service),
                        ),
                      );
                    } else if (textColor == const Color.fromARGB(255, 247, 223, 13)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(service: service, serviceHash: serviceHash, selectedValue: selectedValue),
                        ),
                      );
                    } else if (textColor == Colors.blue) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientCompleteScreen(service: service),
                        ),
                      );
                    } else if (textColor == Colors.red) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotReadyScreen(service: service, serviceHash: serviceHash),
                        ),
                      );
                    } else if (textColor == Colors.green) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientRescheduleScreen(service: service, serviceHash: serviceHash, houseID: selectedValue),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
        
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 2, // Search tab index
        routes: routes, // Pass routes map
        parentContext: context,
      ),
    );
  }
}
