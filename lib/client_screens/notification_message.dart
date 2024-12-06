import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class NotificationMessage {
  final String id;
  final String title;
  final String body;

  NotificationMessage({
    required this.id,
    required this.title,
    required this.body,
  });

  factory NotificationMessage.fromRemoteNotification(RemoteNotification? notification) {
   

    return NotificationMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: notification?.title ?? 'No Title',
      body: notification?.body ?? 'No Body',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
  };

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
  
}

class NotificationProvider with ChangeNotifier {
  List<NotificationMessage> _messages = [];
  int _notificationCount = 0;

  int get notificationCount => _notificationCount;
  
  List<NotificationMessage> get messages => _messages;


  void addNotification(NotificationMessage message) {
    _notificationCount++;
    _messages.add(message);
    notifyListeners();
  }

  void removeNotification(String id) {
    _notificationCount--;
    _messages.removeWhere((msg) => msg.id == id);
    notifyListeners();
  }

  void clearNotifications() {
     _notificationCount = 0;
    _messages = [];
    notifyListeners();
  }
}