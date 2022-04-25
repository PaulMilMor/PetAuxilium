import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
final _instancia = dbUtil().instancia;
  final preferencesUtil _prefs = preferencesUtil();
class PublicacionProvider{
  CollectionReference _business=_instancia.collection('business');
  
  

}