import 'package:flutter/material.dart';
import '../client_screens/notification_message.dart'; 
import 'package:badges/badges.dart' as badges;
class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Map<int, String> routes;
  final BuildContext parentContext;
  final int notificationCount;
  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.routes,
    required this.parentContext,
    this.notificationCount=0,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true, 
      currentIndex: currentIndex,
       selectedLabelStyle: const TextStyle(fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      onTap: (index) {
        final route = routes[index];
        if (route != null && route.isNotEmpty) {
          Navigator.pushNamed(parentContext, route);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Settings',
        ),
      ],
       selectedItemColor: Colors.blue, // Customize selected item color
      unselectedItemColor: Colors.black,
      
    );
  }
}
