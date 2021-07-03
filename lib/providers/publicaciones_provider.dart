import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

class PublicacionProvider{
  final _firestoreInstance = FirebaseFirestore.instance;
  final preferencesUtil _prefs = preferencesUtil();

}