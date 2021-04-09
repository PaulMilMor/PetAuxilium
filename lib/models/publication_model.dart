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
  double score;
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
      this.services});

// class AddAdoption {
//   String id;
//   String category;
//   String name;
//   String description;
//   List<dynamic> location;
//   List<dynamic> imgRef;
//   AddAdoption(
//       {this.id,
//       this.category,
//       this.name,
//       this.description,
//       this.location,
//       this.imgRef});

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
    score = 5.0;
    nevaluations = json['nevaluations'];
  }
}
