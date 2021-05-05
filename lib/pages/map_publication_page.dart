import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_auxilium/blocs/createpublication/createpublication_bloc.dart';

import 'package:pet_auxilium/utils/prefs_util.dart';

class MapPagePublication extends StatefulWidget {
  @override
  _MapPagePublicationState createState() => _MapPagePublicationState();
}

//TODO: asignar punto inicial 
//TODO: solo utilizar un mapa
class _MapPagePublicationState extends State<MapPagePublication> {
  LatLng _initialcameraposition = LatLng(29.115967, -111.025490);
  // String _name;
var bloc;

  final prefs = preferencesUtil();
  LocationData _currentPosition;
  Location location = Location();
  GoogleMapController _controller;
  //Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = new Set<Marker>();
  // BusinessModel business = BusinessModel(location: 'geo:29,-111');
  @override
  void initState() {
    // if(prefs.previousPage=='publication'){
    //   bloc= BlocProvider.of<CreatepublicationBloc>(context);
    // print('xd');

    // }
    
    super.initState();
    getLoc();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _controller;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
  bloc=ModalRoute.of(context).settings.arguments;
    //if (ModalRoute.of(context).settings.arguments != null)
      _markers =bloc.state.locations??this._markers;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                prefs.selectedIndex==2;
                if (bloc.runtimeType==CreatepublicationBloc) {
                   bloc.add(UpdateLocations(_markers));
                   print(bloc.state.locations);
                 Navigator.popAndPushNamed(context, 'PublicationPage');
                } else if (prefs.selectedIndex == 4) {
                  Navigator.popAndPushNamed(context, 'complaintPage',
                      arguments: _markers);
                }
              })
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: _markers,
        onTap: _addMarker,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _initialcameraposition,
          zoom: 17.5,
        ),
        /*initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },*/
      ),
    );
  }

//TODO:limitar los markers
  _addMarker(
    LatLng point,
  ) async {
    if (_markers.length < 1) {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          onTap: () {
            _markers.remove(_markers
                .firstWhere((Marker marker) => marker.position == point));
                bloc.add(UpdateLocations(_markers));
          },
          infoWindow: InfoWindow(
            title: bloc.state.name,
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));
      });
    }
  }

  getLoc() async {
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

    // _currentPosition = await location.getLocation();
    // _initialcameraposition =
    //     LatLng(_currentPosition.latitude, _currentPosition.longitude);
    // location.onLocationChanged.listen((LocationData currentLocation) {

    //   setState(() {
    //     _currentPosition = currentLocation;
    //     _initialcameraposition =
    //         LatLng(_currentPosition.latitude, _currentPosition.longitude);
    //   });
    // });
  }
}
