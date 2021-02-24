import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';

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
  String _name = " ";
  String _desc;
  List<String> _dir;
  List<LatLng> _locations;
  final MapsUtil mapsUtil = MapsUtil();
  @override
  void initState() {
    super.initState();
//FIXME: cambiar esto en proximos sprints para que esta info la obtenga de Firebase
    _name = prefs.businessName ?? '';
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
              SizedBox(height:10),
          Text('Completa los siguientes campos'),
          _nameTxt(),
          SizedBox(height:10),
          _dirTxt(),
              SizedBox(height:10),
          Text('Describa los servicios que ofrece'),
           SizedBox(height:10),
           _descriptionTxt(),
          _buttons()
        ],
      ),
    );
  }

  Widget _nameTxt() {
    return Container(
        child: GrayTextFormField(
      controller: _nameTxtController,
      hintText: 'Nombre',
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
        child:  GrayTextFormField(
      controller: _dirTxtController,
    hintText: 'Direccion',
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
        children: [_cancelBtn(),
        SizedBox(width: 5,),
        _saveBtn()],
      ),
    );
  }

  Widget _descriptionTxt() {
    return GrayTextFormField(
      maxLines: 6,
      controller: _descTxtController,
      hintText:'Descripcion',
      onChanged: (value) {
        setState(() {
          prefs.businessDescription = value;
          _desc = value;
        });
      },
    );
  }
Widget _cancelBtn(){
 return Container(
      child: FlatButton(
         color: Colors.white,
         textColor: Colors.grey,
          onPressed: () async {
           Navigator.pop(context);
            //print(_dir);
          },
          child: Text('Cancelar')),
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
                location: mapsUtil.locationtoString(_locations),
                 //TODO:poner aqui el id del usuario
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
          place = place  +
              element.street +
              " " +
              element.subLocality +
              ", " +
              element.locality+
              "\n";
        });
        setState(() {
          _dirTxtController.text = place;
        });
      });
    }
  }
}
