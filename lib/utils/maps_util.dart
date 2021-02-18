import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsUtil{

String translateDir(LatLng location){
  Future<List<Placemark>> placemark = placemarkFromCoordinates(location.latitude, location.longitude);
  
 

}

    List<String> getDir(List<LatLng> locations)  {
  if(locations!=null){

 List<String> dirs= List<String>();
    locations.forEach((LatLng element) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(element.latitude, element.longitude);
      placemarks.forEach((Placemark element) {
        dirs.add( element.street.toString());
      
      });
      
    });
    return dirs;
  }
   else{
     return null;
   }
  }

    List<LatLng> getLocations(Set<Marker> markers) {
    if (markers != null) {
      List<LatLng> listLocations = List<LatLng>();
      markers.forEach((Marker element) {
        listLocations.add(element.position);
      });
      return listLocations;
    } else {
      return null;
    }
  }
}