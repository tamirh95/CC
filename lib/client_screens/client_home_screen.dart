import 'package:flutter/material.dart';
import 'package:casacare/custom_widgets/nav_bar.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = {
      0: '/Home', 
      1: '/Appointments', 
      2: '/Services',
      3: '/Notifications',
      4: '/Settings',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),backgroundColor: Colors.blue,centerTitle: true,automaticallyImplyLeading: false
      ),
      body: SingleChildScrollView(
      
        child: Column(

          children: <Widget>[
            Image.asset('assets/home_page_home.jpg'), // Main feature image
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Image.asset('assets/fake_logo.jpg', height: 80), // Logo image
                  const Text(
                    'Casa Care',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Keep your home in perfect shape',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  // Example bullet points
                  const BulletPoint(text: 'Quality and reliability'),
                  const BulletPoint(text: 'Fix your issues before they ever happen'),
                  const BulletPoint(text: 'Knowledgeable and friendly'),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 0, // Home tab index
        routes: routes, // Pass routes map
        parentContext: context,
      ),
    );
  }
}
class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('• ', style: TextStyle(fontSize: 20, height: 1.2)),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 16, height: 1.2)),
        ),
      ],
    );
  }
}
