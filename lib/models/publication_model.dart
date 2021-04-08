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
      this.score});

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
     score=5.0;
    nevaluations=json['nevaluations'];
  }
}
