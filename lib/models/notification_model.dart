import 'package:flutter/cupertino.dart';

class NotificationModel {
  String id;
  String notification;
  List<dynamic> receiverID;
  String senderID;
  String publicationID;
  //String chatID;
  DateTime date;
  String senderName;

  NotificationModel({
    this.id,
    this.notification,
    this.receiverID,
    this.senderID,
    this.publicationID,
    // this.chatID,
    this.date,
    this.senderName,
  });

  NotificationModel.fromJsonMap(Map<String, dynamic> json, String nid) {
    id = nid;
    notification = json['notification'];
    receiverID = json['receiverID'];
    senderID = json['senderID'];
    publicationID = json['publicationID'];
    //chatID = json['chatID'];
    date = json['date'].toDate();
    senderName = json['senderName'];
  }
}
