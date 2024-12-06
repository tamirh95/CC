import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'client_services_screen.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final  Map<String, dynamic> serviceHash;
  final  String? selectedValue;
  const BookingScreen({super.key, required this.service, required this.serviceHash, required this.selectedValue});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
    final SupabaseClient supabase = Supabase.instance.client;
  final email = Supabase.instance.client.auth.currentUser?.email;
 

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _bookService() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both a date and a time')),
      );
      return;
    }

     final bookingDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    
      await Supabase.instance.client.rpc('insert_order_from_client3', params: {
      'client_email': email,
      'house_id': widget.selectedValue,
      'service_name': widget.service['Service_Name'],
      'booking_time': bookingDateTime.toIso8601String(),
    });

  
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking successful!',textScaler: TextScaler.linear(2),)));

    // Return to Home Screen
    widget.serviceHash[widget.service['Service_Name']]['Status']="Scheduled";
    String jsonString=jsonEncode(widget.serviceHash);
     await supabase.from('houses').update({
    'Services_to_Do': jsonString, 
  }).eq('House_id',widget.selectedValue.toString());

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ClientServicesScreen()),
      (route) => false, // Remove all routes in the stack
    );
  
  }
   Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.service['Service_Name']),backgroundColor: Colors.blue,centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
            Text(widget.service['Service_Description']),
            const SizedBox(height: 20),
             Text('Services Remaining: ${widget.serviceHash[widget.service['Service_Name']]['Amount']}'),
            const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectDate,
                child: Text(selectedDate == null
                    ? 'Select Date'
                    : 'Selected Date: ${DateFormat('MM/dd/yyyy').format(selectedDate!)}'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: selectedDate == null
                    ? null // Disable time selection until date is selected
                    : _selectTime,
                child: Text(selectedTime == null
                    ? 'Select Time'
                    : 'Selected Time: ${selectedTime!.format(context)}'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _bookService,
                child: const Text('Book Now'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}