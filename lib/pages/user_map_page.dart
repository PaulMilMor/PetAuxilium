import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
class UserMapPage extends StatefulWidget {
  
  @override
  _UserMapPageState createState() => _UserMapPageState();
}

class _UserMapPageState extends State<UserMapPage> {
  LatLng tempLocation = LatLng(29.115967, -111.025490);
  List<BusinessModel> business=List<BusinessModel>();
   Completer<GoogleMapController> _controller = Completer();
   Set<Marker> _markers = new Set<Marker>();
  final db=dbUtil();

  @override
  Widget build(BuildContext context) {

  getMarkers();
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
  void getMarkers() async{
business=await  db.getAllLocations() ;
business.forEach((BusinessModel business) { 
business.location.forEach((element) { 
 setState(() {
   
       _markers.add(Marker(
        markerId: MarkerId(element),
        position: LatLng(29.115967, -111.025490),
       infoWindow: InfoWindow(
          title: business.name
        ),
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
     });

});

});


 
  
    //element[]

    

  }
}