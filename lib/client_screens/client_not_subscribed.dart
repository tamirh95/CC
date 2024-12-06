import 'package:flutter/material.dart';

class NotSubScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  const NotSubScreen({super.key, required this.service});

  @override
  State<NotSubScreen> createState() => _NotSubScreenState();
}

class _NotSubScreenState extends State<NotSubScreen> {
  


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
      backgroundColor: Colors.white,
    );
  }
}