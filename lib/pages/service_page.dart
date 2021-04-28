import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/business_model.dart';

import 'package:geocoding/geocoding.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';

import 'detail_page.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  String _service;

  TextEditingController _searchTxtController;
  String _query;
  final dbUtil _db = dbUtil();
  final preferencesUtil _prefs = preferencesUtil();
  @override
  Widget build(BuildContext context) {
    String _service = ModalRoute.of(context).settings.arguments;
    String _category = getCategory(_service);
    return Scaffold(
        appBar: AppBar(
          title: Text(_service),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 7),
          child: StreamBuilder(
            stream: _db.getFollows(_prefs.userID),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> follow) {
              return StreamBuilder(
                  stream: _getFeed(_category),
                  //future: _db.getPublications('publications', _category),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListFeed(snapshot: snapshot, follows: follow.data);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            },
          ),
        ));
  }

  String getCategory(String service) {
    switch (service) {
      case 'Adopción':
        return 'ADOPCIÓN';
        break;
      case 'Animales\nPerdidos':
        return 'ANIMAL PERDIDO';
        break;
      case 'Animales\nCallejeros':
        return 'SITUACIÓN DE CALLE';
        break;
      case 'Cuidados\nEspeciales':
        return 'CUIDADOS ESPECIALES';
        break;
      case 'Consultoría':
        return 'CONSULTORÍA';
        break;
      case 'Estética':
        return 'ESTÉTICA';
        break;
      case 'Entrenamiento':
        return 'ENTRENAMIENTO';
        break;
      case 'Guardería/Hotel\nde animales':
        return 'GUARDERÍA / HOTEL ANIMAL';
        break;
      case 'Servicios de\nSalud':
        return 'SERVICIOS DE SALUD';
        break;
      case 'Servicios de\nLimpieza':
        return 'LIMPIEZA / ASEO';
        break;
      case 'Ventas':
        return 'VENTAS';
        break;
      case 'Veterinarias':
        return 'VETERINARIA';
        break;
      case 'Denuncias':
        return 'DENUNCIA';
        break;
      default:
        return '';
    }
  }

  Stream _getFeed(String service) {
    switch (service) {
      case 'ADOPCIÓN':
      case 'ANIMAL PERDIDO':
      case 'SITUACIÓN DE CALLE':
        return _db.streamPubsServices(service);
        //return _db.getPublications('publications', service);
        break;
      case 'CUIDADOS ESPECIALES':
      case 'GUARDERÍA / HOTEL ANIMAL':
      case 'LIMPIEZA / ASEO':
        return _db.serviceFeed(service);
        break;
      case 'CONSULTORÍA':
      case 'ENTRENAMIENTO':
      case 'SERVICIOS DE SALUD':
        return _db.streamKeepersServices(service);
        //return _db.getKeepers(service);
        break;
      case 'ESTÉTICA':
      case 'VETERINARIA':
      case 'VENTAS':
        return _db.streamBusinessServices(service);
        break;
      case 'DENUNCIA':
        return _db.streamComplaintsServices(service);
    }
  }

  Widget _searchArea() {
    //_search('');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(_service),
        TextField(
          controller: _searchTxtController,
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
        _searchResults(),
        /*ListView.builder(
          itemCount: _results.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(_results[index].name);
          },
        ),*/
      ],
    );
  }

  Widget _searchResults() {
    return StreamBuilder<QuerySnapshot>(
        stream: (_query != "" && _query != null)
            ? FirebaseFirestore.instance
                .collection('business')
                //estas dos condiciones son para buscar cualquier string que contenga la query
                //TODO: Hacer que la búsqueda sea insensible a Case (Mayus, minus)
                .where('name', isGreaterThanOrEqualTo: _query)
                .where('name', isLessThanOrEqualTo: '$_query\uF7FF')
                .snapshots()
            : FirebaseFirestore.instance.collection('business').snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    return Text(data['name']);
                  });
        });
  }
}
