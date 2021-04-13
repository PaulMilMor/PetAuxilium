import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/db_util.dart';

class Token extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Token();
}

class _Token extends State<Token> {
  dbUtil _db = dbUtil();
  final _firestoreInstance = FirebaseFirestore.instance;
  String _token;

  @override
  void initState() async {
    super.initState();
    // Get the token each time the application loads
    String token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await _db.saveTokenToDatabase(token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(_db.saveTokenToDatabase);
    print('TOKEEEEN:' + token);
  }

  @override
  Widget build(BuildContext context) {
    print('TOKEEEEN:' + _token);
  }
}
