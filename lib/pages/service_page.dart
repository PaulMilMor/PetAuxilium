import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/business_model.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  String _service;

  TextEditingController _searchTxtController;
  String _query;

  /*  void initState() {
    super.initState();
    _search('');
  }*/

  @override
  Widget build(BuildContext context) {
    _service = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: _searchArea(),
    );
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
