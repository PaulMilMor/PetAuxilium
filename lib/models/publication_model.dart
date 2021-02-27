import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAdoption {
  String id;
  String category;
  String name;
  String description;
  List<dynamic> location;
  List<dynamic> imgRef;
  AddAdoption(
      {this.id,
      this.category,
      this.name,
      this.description,
      this.location,
      this.imgRef});

  AddAdoption.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    description = json['category'];
    name = json['name'];
    description = json['description'];
    location = json['location'];
    imgRef = json['imgRef'];
  }
}
