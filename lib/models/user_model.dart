import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
String name;
String email;
String imgRef;
String pass;
String id;
String token;
List follows;
List evaluationsID;
List notifications;
Timestamp patreon;
 UserModel({this.id,this.email,this.name, this.pass,this.imgRef, this.follows,this.evaluationsID, this.token, this.notifications, this.patreon});
   UserModel.fromJsonMap(Map<String, dynamic> json,uid) {
    id=uid;    
    name = json['name'];
     email=json['email'];
     imgRef=json['imgRef'];
     patreon=json['patreon'];
     notifications=json['notifications'];
    follows = json['follows'];
    evaluationsID = json['evaluationsID'];  
  }
}

