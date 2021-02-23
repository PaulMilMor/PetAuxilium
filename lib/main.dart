import 'package:flutter/material.dart';
//import 'package:flutter/cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/app.dart';
import 'package:pet_auxilium/src/pages/feed.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
