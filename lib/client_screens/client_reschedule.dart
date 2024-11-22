import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

/*class ClientRescheduleScreen extends StatefulWidget {

  final Map<String, dynamic> service;
  final  Map<String, dynamic> serviceHash;
  const ClientRescheduleScreen({Key? key, required this.service, required this.serviceHash}) : super(key: key);

  @override
  _ClientRescheduleScreenState createState() => _ClientRescheduleScreenState();
}

class _ClientRescheduleScreenState extends State<ClientRescheduleScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final email =  Supabase.instance.client.auth.currentUser?.email;
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
     // Default to current booking time
      _getBookingTimeBooking();
  }

  Future<void> _getBookingTimeBooking() async {
    final response=await supabase.from('orders').select('Booking_Time').eq('Client_Email',email.toString()).eq('Service_Name',widget.service['Service_Name']).single();
    selectedDateTime=new DateFormat("yyyy-MM-dd hh:mm:ss").parse(response.toString());
    print(selectedDateTime);
  }
  Future<void> _rescheduleBooking() async {
    if (selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a new date and time')),
      );
      return;
    }

    final response = await supabase
        .from('bookings')
        .update({'booking_time': selectedDateTime!.toIso8601String()})
        ;

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking rescheduled successfully')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    }
  }

  Future<void> _cancelBooking() async {
    final response = await supabase
        .from('bookings')
        .delete()
        ;

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking canceled successfully')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    }
  }

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
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
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Booking Time: ',
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
    );
  }
}*/
