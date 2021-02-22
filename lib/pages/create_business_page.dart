import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

class CreateBusinessPage extends StatefulWidget {
  @override
  _CreateBusinessPageState createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends State<CreateBusinessPage> {
  TextEditingController _nameTxtController;
  TextEditingController _dirTxtController;
  TextEditingController _descTxtController;
  final prefs = new preferencesUtil();
  Set<Marker> _markers = new Set<Marker>();
  final _db = dbUtil();
  String _name;
  String _desc;
  List<String> _dir;
  List<LatLng> _locations;
  final MapsUtil mapsUtil = MapsUtil();
  @override
  void initState() {
    super.initState();

    _name = prefs.businessName ?? ' ';
    _desc = prefs.businessDescription;
    _nameTxtController = TextEditingController(text: _name);
    _dirTxtController = TextEditingController();
    _descTxtController = TextEditingController(text: _desc);
  }

  @override
  Widget build(BuildContext context) {
    _markers = ModalRoute.of(context).settings.arguments;
    _locations = mapsUtil.getLocations(_markers);
    getDir(_locations);
    //  _dir=mapsUtil.getDir(_locations);
    return Scaffold(
      body: _businessForm(context),
    );
  }

  Widget _businessForm(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            'PUBLICAR NEGOCIO',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          _nameTxt(),
          _descriptionTxt(),
          _dirTxt(),
          _buttons()
        ],
      ),
    );
  }

  Widget _nameTxt() {
    return Container(
        child: TextField(
      controller: _nameTxtController,
      decoration: InputDecoration(labelText: 'Nombre'),
      onChanged: (value) {
        setState(() {
          prefs.businessName = value;
          _name = value;
        });
      },
    ));
  }

  Widget _dirTxt() {
    return Container(
        child: TextField(
      controller: _dirTxtController,
      decoration: InputDecoration(labelText: 'Direccion'),
      onTap: () {
        Navigator.pushNamed(context, 'map', arguments: _markers);
      },
    ));
  }

  Widget _buttons() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_saveBtn()],
      ),
    );
  }

  Widget _descriptionTxt() {
    return TextField(
      maxLines: 8,
      controller: _descTxtController,
      decoration: InputDecoration.collapsed(hintText: "Descripcion"),
      onChanged: (value) {
        setState(() {
          prefs.businessDescription = value;
          _desc = value;
        });
      },
    );
  }
//TODO: cambiar el userID por el que este usando el usuario 
  Widget _saveBtn() {
    return Container(
      child: RaisedButton(
          onPressed: () async {
            print(mapsUtil.locationtoString(_locations));
            BusinessModel business = BusinessModel(
                name: _name,
                //location: mapsUtil.locationtoString(_locations),
                userID: 'miidxd',
                description: _desc);
            _db.addBusiness(business);
            //print(_dir);
          },
          child: Text('Guardar')),
    );
  }

//FIXME: optimizar este sector
  void getDir(List<LatLng> locations) {
    if (locations != null) {
      locations.forEach((LatLng element) async {
        String place = "";
        List<Placemark> placemarks =
            await placemarkFromCoordinates(element.latitude, element.longitude);
        placemarks.forEach((Placemark element) {
          place = place +
              "\n" +
              element.street +
              " " +
              element.subLocality +
              ", " +
              element.locality;
        });
        setState(() {
          _dirTxtController.text = place;
        });
      });
    }
  }
}
