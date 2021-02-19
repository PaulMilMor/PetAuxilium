import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessModel{
    String name;
    List<String> location;
    String description;
    String userID;
    BusinessModel({this.name,this.description,this.location, this.userID });
    // LatLng getLatLng() {

    //   final latLng = this.location.substring(4).split(',');
    //   final lat = double.parse( latLng[0] );
    //   final lng = double.parse( latLng[1] );

    //   return LatLng( lat, lng );
    // }
}