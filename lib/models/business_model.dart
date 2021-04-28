import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessModel {
  String id;
  String category;
  String name;
  List<dynamic> location;
  String description;
  String userID;
  List<dynamic> imgRef;
  List<dynamic> services;
  List<dynamic> followers;
  String pricing;
  int nevaluations;
  var score;
  DateTime date;

  BusinessModel(
      {this.id,
      this.category,
      this.name,
      this.description,
      this.location,
      this.userID,
      this.imgRef,
      this.services,
      this.pricing,
      this.nevaluations,
      this.score, //});
      this.date,
      this.followers});
  // LatLng getLatLng() {

  //   final latLng = this.location.substring(4).split(',');
  //   final lat = double.parse( latLng[0] );
  //   final lng = double.parse( latLng[1] );

  //   return LatLng( lat, lng );
  // }

  BusinessModel.fromJsonMap(Map<String, dynamic> json) {
    name = json['name'];
    location = json['location'];
    description = json['description'];
    userID = json['userID'];
    this.services = json['services'];
    this.date = json['date'].toDate();

    followers = json['followers'];
  }
}
