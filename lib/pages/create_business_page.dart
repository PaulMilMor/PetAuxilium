import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

class CreateBusinessPage extends StatefulWidget {
  @override
  _CreateBusinessPageState createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends State<CreateBusinessPage> {
  TextEditingController _nameTxtController;
  TextEditingController _dirTxtController;
  final prefs = preferencesUtil();
  Set<Marker> _markers = new Set<Marker>();
  
  String _name;
  List<String> _dir;
  List<LatLng> _locations;
  final MapsUtil mapsUtil=MapsUtil();
  @override
  void initState() {
    super.initState();
    _name = prefs.businessName;
    //TODO: Esto es la mousekeherramienta mistoriosa, Es una herramienta que nos va ayudara mas tarde
    _nameTxtController = new TextEditingController(text: _name);
    _nameTxtController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _markers = ModalRoute.of(context).settings.arguments;
    _locations = mapsUtil.getLocations(_markers);
    _dir=mapsUtil.getDir(_locations);
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
          if(_dir==null) _dirTxt() ?? _list(_dir, context),
          
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
        Navigator.pushNamed(context, 'map');
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

  Widget _saveBtn() {
    return Container(
      child: RaisedButton(
          onPressed: () async {
           _dir=mapsUtil.getDir(_locations);
           print(_dir);
          },
          child: Text('Guardar')),
    );
  }
 List<Widget> _list(List<String> data, BuildContext context) {
    final List<Widget> opciones = [];

    data.forEach((element) {
      final widgetTemp = ListTile(
        title: Text(element),
      
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.cyanAccent,
        ),
        onTap: () {
          // final route =MaterialPageRoute(
          //   builder:(context)=> AlertPage()
          Navigator.pushNamed(context, 'map');
          // );
          // Navigator.push(context, route);
         
        },
      );
      opciones..add(widgetTemp)..add(Divider());
    });
    //print(menuProvider.opciones);
    //menuProvider.cargarData()
    return opciones;
  }

}
