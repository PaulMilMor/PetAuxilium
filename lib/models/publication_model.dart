import 'package:google_maps_flutter/google_maps_flutter.dart';

class PublicationModel {
  String id;
  String category;
  String name;
  String description;
  List<dynamic> location;
  List<dynamic> imgRef;
  String userID;
  String pricing;
  int nevaluations;
  DateTime date;
  var score;
  List<dynamic> services;
  PublicationModel(
      {this.id,
      this.category,
      this.name,
      this.description,
      this.location,
      this.imgRef,
      this.userID,
      this.pricing,
      this.nevaluations,
      this.score,
      this.services,
      this.date});

  PublicationModel.fromJsonMap(Map<String, dynamic> json, String id) {
    id = id;
    category = json['category'];
    name = json['name'];
    description = json['description'];
    location = json['location'];
    imgRef = json['imgRef'];
    pricing = json['pricing'];
    userID = json['userID'];
    //nevaluations = json['nevaluations'];
    //score = json['score'].toDouble();
    services = json['services'];
    score = json['score'];
    nevaluations = json['nevaluations'];
    date = json['date'].toDate();
  }
}
