import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsUtil{

    List<LatLng> getLocations(Set<Marker> markers) {
    if (markers != null) {
      print("hay markers");
      List<LatLng> listLocations = List<LatLng>();
      markers.forEach((Marker element) {
        listLocations.add(element.position);
      });
      return listLocations;
    } else {
      return null;
    }
  }

List<String> locationtoString(List<LatLng> locations) {
    List<String> stringlocations = List<String>();
    locations.forEach((LatLng element) {
      stringlocations.add(
          element.latitude.toString() + ',' + element.longitude.toString());
    });
    return stringlocations;
  }
  /*List <String> locationtoString(List<LatLng> locations){
   List<String> stringlocations=List<String>();
   locations.forEach((element) { 
   stringlocations.add(element.toString());

   });
    return stringlocations;

  }*/
}