import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';

class ServicesMenuPage extends StatefulWidget {
  @override
  _ServicesMenuPageState createState() => _ServicesMenuPageState();
}

//FIXME: ¿Qué es exactamente lo q se busca? xdxd Actualmente busca servicios pero ya q algunos no tienen todos los campos se tuvo q limitar
class _ServicesMenuPageState extends State<ServicesMenuPage> {
  TextEditingController _searchTxtController;
  String _query;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: _query == null || _query == ''
                ? const EdgeInsets.all(18.0)
                : const EdgeInsets.all(0.0),
            child: Column(
              children: [
                _searchBar(),
                _query == null || _query == ''
                    ? _table(context)
                    : _searchResults(),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 16, 6, 28),
      child: GrayTextFormField(
        prefixIcon: Icon(Icons.search),
        hintText: 'Buscar',
        controller: _searchTxtController,
        onChanged: (value) {
          setState(() {
            _query = value;
          });
        },
      ),
    );
  }

//FIXME: Esto no hace scroll al tocar las cards
  Widget _searchResults() {
    return StreamBuilder<QuerySnapshot>(
        stream: (_query != "" && _query != null)
            ? FirebaseFirestore.instance
                .collection('publications')
                //estas dos condiciones son para buscar cualquier string que contenga la query
                //TODO: Hacer que la búsqueda sea insensible a Case (Mayus, minus)
                .where('name', isGreaterThanOrEqualTo: _query)
                .where('name', isLessThanOrEqualTo: '$_query\uF7FF')
                .snapshots()
            : FirebaseFirestore.instance.collection('business').snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListFeed(
                  snapshot: snapshot, physics: NeverScrollableScrollPhysics());
          /*ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    List<dynamic> fotos = data['imgRef'];
                    //return Text(data['name']);
                  });*/
        });
  }

  Widget _table(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          _btnService('Adopción', context),
          _btnService('Animales\nCallejeros', context)
        ]),
        TableRow(children: [
          _btnService('Animales\nPerdidos', context),
          _btnService('Cuidados\nEspeciales', context)
        ]),
        TableRow(children: [
          _btnService('Consultaria', context),
          _btnService('Estética', context)
        ]),
        TableRow(children: [
          _btnService('Entrenamiento', context),
          _btnService('Guardería/Hotel\nde animales', context)
        ]),
        TableRow(children: [
          _btnService('Servicios de\nSalud', context),
          _btnService('Servicios de\nLimpieza', context)
        ]),
        TableRow(children: [
          _btnService('Ventas', context),
          _btnService('Veterinarias', context)
        ]),
      ],
    );
  }

  Widget _btnService(String service, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'service', arguments: service);
        print(service);
      },
      child: Container(
        height: 70,
        //margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            //color:Colors.grey[200],
            //borderRadius: BorderRadius.circular(20)
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(height:5.0),
            CircleAvatar(
                radius: 25.0,
                backgroundColor: Color.fromRGBO(49, 232, 93, 1),
                child: Icon(
                  Icons.pets,
                  color: Colors.black,
                  size: 30.0,
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                service,
                style: TextStyle(color: Colors.black),
              ),
            ),
            //SizedBox(height:5.0)
          ],
        ),
      ),
    );
  }
}
