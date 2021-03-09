import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  List<String> _follows = [
    '830Yobc6R1CxsoGsrrrG',
    'zpEfIbbNFKgWMivsrVjw',
    'BrXlsBwvWj3STMK53j4u',
    'CmJMGPBeGjOtM3c9DrvE',
    'MGgmkfvtdx92tl15onP4'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LISTA DE SEGUIMIENTO'),
      ),
      body: _followedList(),
    );
  }

  /*Widget _title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
      child: Text(
        'PUBLICAR NEGOCIO',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }*/

  Widget _followedList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('publications')
          .where(FieldPath.documentId, whereIn: _follows)
          .snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? Center(child: CircularProgressIndicator())
            : ListFeed(snapshot: snapshot);
      },
    );
  }
}
