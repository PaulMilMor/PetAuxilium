
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
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
        title: Text('LISTA DE SEGUIMIENTO'),
     
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
    
      stream: _db.getFollows(_prefs.userID),
      builder: (BuildContext context, AsyncSnapshot<List<String>> follow) {
if (follow.connectionState!=ConnectionState.waiting) {
    return follow.data.isEmpty
            ? Center(
                child: Text('No sigues ninguna publicación'),
              )
            : StreamBuilder(
                stream: _db.getFollowPublications(follow.data),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? Center(child: CircularProgressIndicator())
                      : //_listFeed;
                      ListFeed(
                          snapshot: snapshot,
                          follows: follow.data,
                          voidCallback: callback);
                },
              );
}else{

  return Container();
}
      
      },
    );
  }
}
