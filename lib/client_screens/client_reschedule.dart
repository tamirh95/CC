import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'client_services_screen.dart';
class ClientRescheduleScreen extends StatefulWidget {

  final Map<String, dynamic> service;
  final  Map<String, dynamic> serviceHash;
  final houseID;
  const ClientRescheduleScreen({super.key, required this.service, required this.serviceHash, required this.houseID});

  @override
  _ClientRescheduleScreenState createState() => _ClientRescheduleScreenState();
}

class _ClientRescheduleScreenState extends State<ClientRescheduleScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final email =  Supabase.instance.client.auth.currentUser?.email;
  dynamic bookingID;
  DateTime? originalTime;
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
     // Default to current booking time
      _getBookingTimeBooking();
  }

  Future<void> _getBookingTimeBooking() async {
    final response=await supabase.from('house_services').select('order_id').eq('Client_Email',email.toString()).eq('Service_Name',widget.service['Service_Name']).eq('house_id',widget.houseID).single();
    final bookingTime= await supabase.from('orders').select('Booking_Time').eq('order_id',response['order_id'] ).single();
        setState(() {
        bookingID=response['order_id'];
        originalTime = DateTime.parse(bookingTime['Booking_Time']);
      });
    
    
  }
  Future<void> _rescheduleBooking() async {
    if (selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a new date and time')),
      );
      return;
    }

     await supabase
        .from('orders')
        .update({'Booking_Time': selectedDateTime!.toIso8601String()})
        .eq('Client_Email', email.toString())
        ;

    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking rescheduled successfully')),
      );
        Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ClientServicesScreen()),
      (route) => false, // Remove all routes in the stack
    );
    
  }

  Future<void> _cancelBooking() async {
    await supabase
        .from('house_services')
        .delete().eq('order_id',bookingID);
    await supabase
        .from('orders')
        .update({'Status':"Cancelled"}).eq('order_id',bookingID);
    widget.serviceHash[widget.service['Service_Name']]['Status']="Ready to Schedule";
    String jsonString=jsonEncode(widget.serviceHash);
     await supabase.from('houses').update({
    'Services_to_Do': jsonString, 
  }).eq('House_id',widget.houseID.toString());    

   
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking canceled successfully')),
      );
        Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ClientServicesScreen()),
      (route) => false, // Remove all routes in the stack
    );
   
  }

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate:DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reschedule or Cancel Booking'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              
              originalTime == null
                  ? 'No Time'
                  : 'Current Booking Time: ${DateFormat('yyyy-MM-dd – HH:mm').format(originalTime!)}',
              //'Current Booking Time:  ${DateFormat('yyyy-MM-dd – HH:mm').format(originalTime!)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              selectedDateTime == null
                  ? 'Select New Date & Time'
                  : 'New Booking Time: ${DateFormat('yyyy-MM-dd – HH:mm').format(selectedDateTime!)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickDateTime,
              child: const Text('Pick New Date & Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _rescheduleBooking,
              child: const Text('Reschedule Booking'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red color for cancel button
              ),
              onPressed: _cancelBooking,
              child: const Text('Cancel Booking'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
