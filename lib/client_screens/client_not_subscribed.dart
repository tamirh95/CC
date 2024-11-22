import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'client_home_screen.dart';
import 'package:intl/intl.dart';

class NotSubScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  const NotSubScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<NotSubScreen> createState() => _NotSubScreenState();
}

class _NotSubScreenState extends State<NotSubScreen> {
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.service['Service_Name']),backgroundColor: Colors.green,centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
            Text(widget.service['Service_Description']),
            const SizedBox(height: 20),
             const Text('Service Unavailable. You are not subscribed'),
            const SizedBox(height: 20),
             ElevatedButton(
                onPressed: (){Navigator.pop(context);},
                child: const Text('Return Home'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}