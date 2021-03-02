import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessModel {
  String name;
  List<dynamic> location;
  String description;
  String userID;
  List<dynamic> imgRef;
  BusinessModel(
      {this.name, this.description, this.location, this.userID, this.imgRef});
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
  }
}
