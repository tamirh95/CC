import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'booking_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  var services = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    final response= await supabase.from('services').select('Service_Name');
      setState(() {
        services = response;
        print(services);
      });

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
          return ListTile(
            title: Text(service['Service_Name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(service: service),
                ),
              );
            },
          );
        },
      ),
    );
  }
}