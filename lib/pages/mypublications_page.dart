import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';

class MypublicationsPage extends StatefulWidget {
  @override
  _MypublicationsPageState createState() => _MypublicationsPageState();
}

class _MypublicationsPageState extends State<MypublicationsPage> {
  final preferencesUtil _prefs = preferencesUtil();
  final dbUtil _db = dbUtil();

  @override
  void initState() {
    super.initState();
  }

  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MIS PUBLICACIONES'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(49, 232, 93, 1),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _followedList(),
    );
  }

  Widget _followedList() {
    return StreamBuilder(
      stream: _db.getMypublications(_prefs.userID),
      builder: (BuildContext context, AsyncSnapshot<List<PublicationModel>> publications) {
        if (publications.connectionState != ConnectionState.waiting) {
          return publications.data.isEmpty
              ? Center(
                  child: Text('No tienes ninguna publicación'),
                )
              : StreamBuilder(
                  stream: _db.mypublic(publications.data),
                  builder: (context, snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Center(child: CircularProgressIndicator())
                        : ListFeed(
                            snapshot: snapshot,
                            //follows: follow.data,
                            voidCallback: callback);
                  },
                );
        } else {
          return Container();
        }
      },
    );
  }
}
