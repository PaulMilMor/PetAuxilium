import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'dart:convert';


String businessModelToJson(BusinessModel data) => json.encode(data.toJson());

class BusinessModel {
    BusinessModel({
        this.id,
        this.category,
        this.name,
        this.location,
        this.description,
        this.userID,
        this.imgRef,
        this.services,
        this.followers,
        this.pricing,
        this.nevaluations,
        this.score,
        this.date,
    });

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
    num score;
    DateTime date;

    factory BusinessModel.fromJson(Map<String, dynamic> json, id) => BusinessModel(
        id: id,
        category: json["category"],
        name: json["name"],
        location: List<dynamic>.from(json["location"].map((x) => x)),
        description: json["description"],
        userID: json["userID"],
        imgRef: List<dynamic>.from(json["imgRef"].map((x) => x)),
        services: List<dynamic>.from(json["services"].map((x) => x)),
        followers: List<dynamic>.from(json["followes"].map((x) => x)),
        pricing: json["pricing"],
        nevaluations: json["nevaluations"],
        score: json["score"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "name": name,
        "location": List<dynamic>.from(location.map((x) => x)),
        "description": description,
        "userID": userID,
        "imgRef": List<dynamic>.from(imgRef.map((x) => x)),
        "services": List<dynamic>.from(services.map((x) => x)),
        "followes": List<dynamic>.from(followers.map((x) => x)),
        "pricing": pricing,
        "nevaluations": nevaluations,
        "score": score,
        "date": date.toIso8601String(),
    };

  BusinessModel.fromPublication(PublicationModel publication) {
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
