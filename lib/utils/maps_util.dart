import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsUtil {
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

  Widget getLocationText(String location) {
 List<String> loc=location.split(',');
 double lat= double.parse(loc[0].replaceAll('(', ''));
 double long=double.parse(loc[1].replaceAll(')', ''));
    if (lat == 29.115967 && long == -111.025490) {
      print('debio entrar aqui');
      return Container(
        width: 150,
        child: Text(
          ' ',
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      print('no aqui' + lat.toString() + '  ' + long.toString());
      return FutureBuilder(
          future: getAddress(lat, long),
          builder:
              (BuildContext context, AsyncSnapshot<List<Placemark>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                width: 150,
                child: Text(
                  snapshot.data.first.street +
                      " " +
                      snapshot.data.first.locality,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
              );
            } else {
              return Container(
                width: 150,
                child: Text(
                  ' ',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
              );
            }
          });
    }
  }
Future<List<Placemark>> getAddress(lat, long) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    return newPlace;
  }

  
}
