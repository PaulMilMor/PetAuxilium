import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';

class UserMapPage extends StatefulWidget {
  @override
  _UserMapPageState createState() => _UserMapPageState();
}

class _UserMapPageState extends State<UserMapPage> {
  LatLng _initialcameraposition = LatLng(29.115967, -111.025490);
  // String _name;
   String _dateTime;
  LocationData _currentPosition;
    Location location = Location();
      GoogleMapController _controller;
  List<BusinessModel> business=List<BusinessModel>();

   Set<Marker> _markers = new Set<Marker>();
  final db=dbUtil();
  @override
  
  @override
  Widget build(BuildContext context) {
 getMarkers();
  
    //TODO: Tambien aqui poner lo de la geolocalisacion
 
    return GoogleMap(
      mapType: MapType.normal,
      markers: _markers,
        myLocationEnabled: true,
        initialCameraPosition:  CameraPosition(
      target:_initialcameraposition,
      zoom: 17.5,
    ),
      onMapCreated:_onMapCreated
    );
  }
    void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _controller;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
        ),
      );
    });
  }
  void getMarkers() async{
business=await  db.getAllLocations() ;
print("negocios "+business.toString());
 business.forEach((BusinessModel business) { 
business.location.forEach((element) {
  String  location= element.toString();
  print( element.toString().split(',')); 
   _markers.add(Marker(
        markerId: MarkerId(element),
        position: LatLng(double.parse(location.substring(0,location.indexOf(',')).trim()
          
        ) ,double.parse(location.substring(location.indexOf(',')+1).trim()
          
        )),
       infoWindow: InfoWindow(
          title: business.name
        ),
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));

});


});

setState(() {
  
});

  
    //element[]
  }
 getLoc() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);

   
      });
    });
  }

}
