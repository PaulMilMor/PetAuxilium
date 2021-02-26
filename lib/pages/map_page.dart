import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

//TODO: asignar punto inicial
class _MapPageState extends State<MapPage> {
  LatLng _initialcameraposition = LatLng(29.115967, -111.025490);
  // String _name;
   String _dateTime;
  LocationData _currentPosition;
    Location location = Location();
      GoogleMapController _controller;
  final prefs = preferencesUtil();

  Set<Marker> _markers = new Set<Marker>();
  // BusinessModel business = BusinessModel(location: 'geo:29,-111');
  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    getLoc();
   
  
=======
>>>>>>> Pool
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
  @override
  Widget build(BuildContext context) {
    //_name=ModalRoute.of(context).settings.arguments;
    if ( ModalRoute.of(context).settings.arguments != null) _markers =ModalRoute.of(context).settings.arguments;
   

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                Navigator.popAndPushNamed(
                    context, 'CreateBusiness',
                    arguments: _markers);
                // final GoogleMapController controller =
                //     await _controller.future;
                // controller.animateCamera(CameraUpdate.newCameraPosition(
                //     CameraPosition(target:tempLocation)));
              })
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: _markers,
        onTap: _addMarker,
        myLocationEnabled: true,
        initialCameraPosition:  CameraPosition(
      target:_initialcameraposition,
      zoom: 17.5,
    ),
        onMapCreated: _onMapCreated,
      ),
    );
  }

//TODO:limitar los markers
  _addMarker(LatLng point) async {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: prefs.businessName,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    });
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
