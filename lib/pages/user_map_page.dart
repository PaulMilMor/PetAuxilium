import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_auxilium/utils/db_util.dart';
class UserMapPage extends StatefulWidget {
  
  @override
  _UserMapPageState createState() => _UserMapPageState();
}

class _UserMapPageState extends State<UserMapPage> {
  LatLng tempLocation = LatLng(29.115967, -111.025490);
   Completer<GoogleMapController> _controller = Completer();
  final db=dbUtil();
  @override
  Widget build(BuildContext context) {
  db.getAllLocations();
    //TODO: Tambien aqui poner lo de la geolocalisacion
      final CameraPosition puntoInicial = CameraPosition(
      target: tempLocation,
      zoom: 17.5,
    );
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      
    );
  }
}