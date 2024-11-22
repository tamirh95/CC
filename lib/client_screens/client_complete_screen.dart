import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'client_home_screen.dart';
import 'package:intl/intl.dart';

class ClientCompleteScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  const ClientCompleteScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<ClientCompleteScreen> createState() => _ClientCompleteScreenState();
}

class _ClientCompleteScreenState extends State<ClientCompleteScreen> {
  


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
             const Text('All Services Completed'),
            const SizedBox(height: 20),
            
            ],
          ),
        ),
      ),
    );
  }
}