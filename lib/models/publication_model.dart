import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAdoption {
  String id;
  String category;
  String name;
  String description;
  List<String> location;
  String imgRef;
  AddAdoption(
      {this.id,
      this.category,
      this.name,
      this.description,
      this.location,
      this.imgRef});
}
