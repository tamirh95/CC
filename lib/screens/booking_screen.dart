import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const BookingScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  DateTime? selectedTime;

  Future<void> _bookService() async {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a booking time')),
      );
      return;
    }

   
    final data= await supabase.from('clients').select('Email,Home_Address,City,State,Zip_Code,Country');
    
    final response = await supabase.from('orders').insert({
      'Client_Email': data[0]['Email'],
      'Home_Address': data[0]['Home_Address'],
      'City': data[0]['City'],
      'State': data[0]['State'],
      'Zip_Code': data[0]['Zip_Code'],
      'Country': data[0]['Country'],
      'Service_Name': widget.service['Service_Name'],
      'Booking_Time': selectedTime!.toIso8601String(),
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.service['Service_Name']),backgroundColor: Colors.green,centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final time = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (time != null) {
                  setState(() {
                    selectedTime = time;
                  });
                }
              },
              child: const Text('Select Booking Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bookService,
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}