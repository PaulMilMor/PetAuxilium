import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/db_util.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

final dbUtil _db = dbUtil();

class _NotificationsState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          SizedBox(height: 21),
          Center(
            child: Text(
              'NOTIFICACIONES',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          )
        ])));
  }
}
