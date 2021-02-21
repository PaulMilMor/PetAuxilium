import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

//TODO: asignar punto inicial
class _MapPageState extends State<MapPage> {
  LatLng tempLocation = LatLng(29.115967, -111.025490);
  // String _name;
  final prefs = preferencesUtil();
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = new Set<Marker>();
 // BusinessModel business = BusinessModel(location: 'geo:29,-111');
  @override
  void initState() {
    super.initState();
    
   
  
  }

  @override
  Widget build(BuildContext context) {
    //_name=ModalRoute.of(context).settings.arguments;
    if ( ModalRoute.of(context).settings.arguments != null) _markers =ModalRoute.of(context).settings.arguments;
    final CameraPosition puntoInicial = CameraPosition(
      target: tempLocation,
      zoom: 17.5,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
              
                Navigator.pushNamed(context, 'CreateBusiness',
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
        initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
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

 
}
