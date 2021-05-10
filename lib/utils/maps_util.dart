import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//FIXME: Este método se llama en Build, lo que ocasiona un bucle infinito
class MapsUtil {
  List<LatLng> getLocations(Set<Marker> markers) {
    if (markers != null) {
      List<LatLng> listLocations = [];
      markers.forEach((Marker element) {
        listLocations.add(element.position);
      });
      return listLocations;
    } else {
      return null;
    }
  }

  List<String> locationtoString(List<LatLng> locations) {
    List<String> stringlocations = [];
    locations.forEach((LatLng element) {
      stringlocations.add(
          element.latitude.toString() + ',' + element.longitude.toString());
    });
    return stringlocations;
  }

  Widget getLocationText(String location, {String size = ''}) {
    List<String> loc = location.split(',');
    double lat = double.parse(loc[0].replaceAll('(', ''));
    double long = double.parse(loc[1].replaceAll(')', ''));
    if (lat == 29.115967 && long == -111.025490) {
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
      return FutureBuilder(
          future: getAddress(lat, long),
          builder:
              (BuildContext context, AsyncSnapshot<List<Placemark>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                //alignment: Alignment.centerLeft,
                //width: 171,
                child: Text(
                  snapshot.data.first.street +
                      ", " +
                      snapshot.data.first.locality,
                  style: TextStyle(
                    fontSize: size == 'small' ? 8 : 13,
                    color: Colors.black54,
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
