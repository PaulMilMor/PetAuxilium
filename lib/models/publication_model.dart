import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_auxilium/models/business_model.dart';

class PublicationModel {
  String id;
  String category;
  String name;
  String description;
  List<dynamic> location;
  List<dynamic> imgRef;
  List<dynamic> followers;
  String userID;
  String pricing;
  int nevaluations;
  DateTime date;
  num score;
  List<dynamic> services;
  bool patreon;
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
      this.date,
      this.followers,
      this.patreon});

  PublicationModel.fromJsonMap(Map<String, dynamic> json, String pid) {
    id = pid;
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
    followers = json['followers'];
    patreon = json['patreon'];
  }
  PublicationModel.fromBusiness(BusinessModel publication) {
    id = publication.id;
    category = publication.category;
    name = publication.name;
    location = publication.location;
    imgRef = publication.imgRef;
    description = publication.description;
    userID = publication.userID;
    services = publication.services;
    date = publication.date;
    followers = publication.followers;
    pricing = publication.pricing;
    score = publication.score;
    nevaluations = publication.nevaluations;
  }
}
