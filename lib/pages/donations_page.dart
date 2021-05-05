import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'package:pet_auxilium/models/donations_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

class DonationsPage extends StatelessWidget {
  final dbUtil _db = dbUtil();
  final preferencesUtil _prefs = preferencesUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromRGBO(30, 215, 96, 1),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          /*actions: [
            if(_prefs.userID == 'gmMu6mxOb1RN9D596ToO2nuFMKQ2')
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Color.fromRGBO(210,210,210,1),
              )
              itemBuilder: ()
            ),
                      
          ]*/
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            children: [
              Text(
                'Organizaciones y fundaciones animalistas a las que puedes apoyar',
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 24),
              Expanded(child: Container(child: _donationsList())),
            ],
          ),
        ),
        floatingActionButton: Builder(
            builder: (context) =>
                _prefs.userID != 'gmMu6mxOb1RN9D596ToO2nuFMKQ2'
                    ? Container()
                    : FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'add_donation_page');
                        },
                        tooltip: 'Añadir Organización',
                        child: Icon(Icons.add, color: Colors.white),
                        backgroundColor: Color.fromRGBO(30, 215, 96, 1),
                      )));
  }

  Widget _donationsList() {
    return StreamBuilder(
        stream: _db.getDonations(),
        builder: (BuildContext context,
            AsyncSnapshot<List<DonationModel>> snapshot) {
          if (snapshot.hasData) {
            snapshot.data.sort(
                (DonationModel a, DonationModel b) => a.name.compareTo(b.name));
            return GridView.count(
              childAspectRatio: 0.75,
              physics: AlwaysScrollableScrollPhysics(),
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: List.generate(snapshot.data.length, (index) {
                DonationModel donation = snapshot.data.elementAt(index);
                return _donationCard(donation, context);
              }),
              /*itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, index) {
                DonationModel donation = snapshot.data.elementAt(index);
                return Container(
                  child: Column(
                    children: [
                      Text(donation.name),
                      //Text(donation.description),
                      //Text(donation.img),
                      //Text(donation.website),
                    ],
                  ),
                );
              },*/
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(30, 215, 96, 1),
            ));
          }
        });
  }

  Widget _donationCard(DonationModel donation, BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 9,
          child: Container(
            //height: 226,
            // width: 250,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Column(
                children: [
                  Flexible(
                    flex: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      child: Image.network(
                        donation.img,
                        height: 100,
                        width: 175,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              donation.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              donation.description,
                              style: TextStyle(
                                fontSize: 8,
                                color: Color.fromRGBO(105, 105, 105, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _prefs.userID != 'gmMu6mxOb1RN9D596ToO2nuFMKQ2'
                            ? SizedBox()
                            : IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteDonation(donation, context);
                                },
                              ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Color.fromRGBO(49, 232, 93, 0.5)),
                            ),
                            onPressed: () {
                              FlutterWebBrowser.openWebPage(
                                  url: donation.website);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'VER MÁS',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: Color.fromRGBO(49, 232, 93, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
              // height: 24,
              ),
        )
      ],
    );
  }

  _deleteDonation(DonationModel donation, BuildContext context) {
    _db.deleteDocument(donation.id, 'donations');
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Se eliminó la organización'),
          action: SnackBarAction(
            label: "DESHACER",
            textColor: Color.fromRGBO(49, 232, 93, 1),
            onPressed: () {
              _db.addDonation(donation);
            },
          ),
        ),
      );
  }

  /*_openBrowserTab(String url) {
    print('POOOOOOOOOOOOOOOOOL BROWSER');
    FlutterWebBrowser.openWebPage(url: url);
  }*/
}
