import 'package:flutter/material.dart';
import 'notification_message.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:casacare/custom_widgets/nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

String? getCurrentUserId() {
  return Supabase.instance.client.auth.currentUser?.id;
}

class NotificationsPage extends StatefulWidget {
  
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationMessage> messages = [];
  final routes = {
      0: '/Home', 
      1: '/Appointments', 
      2: '/Services',
      3: '/Notifications',
      4: '/Settings',
    };
  @override
  void initState() {
    super.initState();
    loadNotifications();
    setupFirebaseMessagingListeners();
  }

  void setupFirebaseMessagingListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      addNotification(NotificationMessage.fromRemoteNotification(message.notification));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      addNotification(NotificationMessage.fromRemoteNotification(message.notification));
    });
  }

  void addNotification(NotificationMessage message) {
    setState(() {
      messages.add(message);
    });
    saveNotifications();
  }

Future<void> loadNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  // Assume `currentUserId` is fetched from your authentication logic
  final String? currentUserId = getCurrentUserId();
  final String? notificationsJson = prefs.getString('notifications_$currentUserId');
  if (notificationsJson != null) {
    setState(() {
      messages = (json.decode(notificationsJson) as List)
          .map((e) => NotificationMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}

Future<void> saveNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final String? currentUserId = getCurrentUserId();
  final String encodedData = json.encode(messages.map((e) => e.toJson()).toList());
  await prefs.setString('notifications_$currentUserId', encodedData);
}
 void _deleteNotification(String id) {
    setState(() {
      messages.removeWhere((message) => message.id == id);
    });
    saveNotifications();
  }
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
         backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false
      ),
       body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Dismissible(
            key: Key(message.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteNotification(message.id);
            },
            child: Card(
              margin: EdgeInsets.all(5),
              elevation: 5,
              child: ListTile(
                title: Text(message.title),
                subtitle: Text(message.body),
              ),
              
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
           bottomNavigationBar: CustomNavigationBar(
        currentIndex: 3, // Home tab index
        routes: routes, // Pass routes map
        parentContext: context,
      ),
    );
  }
}
