import 'package:flutter/material.dart';

class ClientCompleteScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  const ClientCompleteScreen({super.key, required this.service});

  @override
  State<ClientCompleteScreen> createState() => _ClientCompleteScreenState();
}

class _ClientCompleteScreenState extends State<ClientCompleteScreen> {
  


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
             const Text('All Services Completed'),
            const SizedBox(height: 20),
            
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}