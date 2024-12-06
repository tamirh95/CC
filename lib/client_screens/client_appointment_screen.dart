import 'package:casacare/client_screens/client_add_house_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:casacare/custom_widgets/nav_bar.dart';
import 'client_add_house_screen.dart';
class AppointmentsScreen extends StatefulWidget {
 

  const AppointmentsScreen({super.key,});

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {  
  final SupabaseClient supabase = Supabase.instance.client;
  final email = Supabase.instance.client.auth.currentUser?.email;
  Map<String, dynamic> houseServices = {}; // House ID -> List of Services
  List<Map<String, dynamic>> houseID=[];
  Map<String, dynamic> houseAddress = {};
bool isLoading = true;
  bool houseCount=false;
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
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    
setState(() {
        isLoading = true;
      });

      // Fetch services for the given house IDs
      final response = await supabase
          .from('clients')
          .select('House_ID')
          .eq('Client_Email', email.toString());
      houseID = List<Map<String, dynamic>>.from(response);   
      
    if(houseID[0]['House_ID'].isNotEmpty){
    setState(() {
      houseID = List<Map<String, dynamic>>.from(response);   
        houseCount=true;
      });
       
        Map<String, dynamic> groupedServices = {};
        Map<String, dynamic> groupedHouses = {};
      for (var houseInfo in houseID[0]['House_ID']) {
        
        final response = await supabase
            .from('house_services')
            .select()
            .eq('house_id', houseInfo);
          final response2 = await supabase
            .from('houses')
            .select('Home_Address,houseSubscribed')
            .eq('House_id', houseInfo);

        // change when able
        if (response.isNotEmpty) {
          if (groupedServices[houseInfo] == null) {
            groupedServices[houseInfo] = [];
          }
         
          groupedServices[houseInfo]!.addAll(response);
        } 
         if (response2.isNotEmpty) {
          if (groupedHouses[houseInfo] == null) {
            groupedHouses[houseInfo] = [];
          }
         
          groupedHouses[houseInfo]!.addAll(response2);
        } 
    }
        

    
        setState(() {
          houseServices = groupedServices;
          houseAddress=groupedHouses;
        });
        
      }
      
      
   setState(() {
        isLoading = false;
      });
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false
      ),
      body: isLoading
        ?const Center(child: CircularProgressIndicator()) 
        :houseCount
              
            ? ListView.builder(
                itemCount: houseID[0]['House_ID'].length,
                itemBuilder: (context, index) {
                  final houseId = houseID[0]['House_ID'].elementAt(index);
                 final address = houseAddress[houseId]?? [];
                  final services = houseServices[houseId] ?? [];
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // House Header
                      
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        color: Colors.blue[100],
                        
                        child: ListTile(
                          title: Text(
                            'House Address: ${address[0]['Home_Address']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: address[0]['houseSubscribed']
                          ?const Icon(Icons.check_circle_outline)
                          :const Icon(Icons.unpublished),
                        ),
                      ),
                      // Services List
                      ...services.map((service) {
                        return ListTile(
                          title: Text(service['Service_Name']),
                          subtitle: Text('Date: ${service['Booking_Time']}'),
                          leading: const Icon(Icons.schedule),
                        );
                      }).toList(),
                      const Divider(height: 1, thickness: 1),
                    ],
                  );
                },
              )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.house,
                  size: 100,  // Adjust the size to fit your design
                  color: Colors.grey[300],  // Soft color for the icon
                ),
                const SizedBox(height: 20),  // Space between icon and text
                Text(
                  'No houses added',
                  style: TextStyle(
                    fontSize: 24,  // Larger font size for clear readability
                    fontWeight: FontWeight.bold,  // Bold text for emphasis
                    color: Colors.grey[600],  // Soft color for the text
                  ),
                ),
            
     
          ],
        ),
        
      ),
       
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 1, // Search tab index
        routes: routes, // Pass routes map
        parentContext: context,
      ),
    );
  }
}
