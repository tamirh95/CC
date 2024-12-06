import 'package:flutter/material.dart';

class NotReadyScreen extends StatefulWidget {
  final Map<String, dynamic> service;
 final  Map<String, dynamic> serviceHash;
  const NotReadyScreen({super.key, required this.service, required this.serviceHash});

  @override
  State<NotReadyScreen> createState() => _NotReadyScreenState();
}

class _NotReadyScreenState extends State<NotReadyScreen> {
  


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
            Text('Service Avaiable to Schedule on ${widget.serviceHash[widget.service['Service_Name']]['Notification_Date']}',textAlign: TextAlign.center,),
            const SizedBox(height: 20),
            
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}