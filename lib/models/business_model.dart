import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessModel{
    int name;
    String location;
    String description;
    BusinessModel({this.name,this.description,this.location});
    LatLng getLatLng() {

      final latLng = this.location.substring(4).split(',');
      final lat = double.parse( latLng[0] );
      final lng = double.parse( latLng[1] );

      return LatLng( lat, lng );
    }
}