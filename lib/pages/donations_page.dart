import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'package:pet_auxilium/models/donations_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';

class DonationsPage extends StatelessWidget {
  final dbUtil _db = dbUtil();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromRGBO(49, 232, 93, 1),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
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
        ));
  }

  Widget _donationsList() {
    return StreamBuilder(
        stream: _db.getDonations(),
        builder: (BuildContext context,
            AsyncSnapshot<List<DonationModel>> snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              childAspectRatio: 0.75,
              physics: AlwaysScrollableScrollPhysics(),
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: List.generate(snapshot.data.length, (index) {
                DonationModel donation = snapshot.data.elementAt(index);
                return _donationCard(donation);
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
            return Text('noay');
          }
        });
  }

  Widget _donationCard(DonationModel donation) {
    return Column(
      children: [
        Container(
          height: 226,
          width: 250,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50)),
            ),
            child: Column(
              children: [
                Image.network(
                  donation.img,
                  height: 100,
                  width: 175,
                  fit: BoxFit.cover,
                ),
                Padding(
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
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        FlutterWebBrowser.openWebPage(url: donation.website);
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
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 24,
        )
      ],
    );
  }

  /*_openBrowserTab(String url) {
    print('POOOOOOOOOOOOOOOOOL BROWSER');
    FlutterWebBrowser.openWebPage(url: url);
  }*/
}
