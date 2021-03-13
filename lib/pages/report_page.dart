import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/models/report_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}
final _db=dbUtil();
class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:FutureBuilder(
          future:_db.getreports() ,
        
          builder: (BuildContext context, AsyncSnapshot<List<ReportModel>> reports) {
            if(reports.hasData){
   return ListView.builder(
              itemCount: reports.data.length,
              itemBuilder: (BuildContext context, index){
              var report=reports.data[index];
               var id=report.publicationid;
               print(id);
   return FutureBuilder(
                  future: _db.getPublication(id),
                  
                  builder: (BuildContext context, AsyncSnapshot<PublicationModel> snapshot) {
                    if(snapshot.hasData){
 PublicationModel publication=snapshot.data;
                    String foto = publication.imgRef.first;
                    String location = publication.location.first;
                    String tagName = location;
                    List<String> split = tagName.split(',');
                    Map<int, String> values = {
                      for (int i = 0; i < split.length; i++) i: split[i]
                    };
                    print(values);
                    String latitude = values[0];
                    String longitude = values[1];
                    String value3 = values[2];
                    String latitude2 = latitude.replaceAll(RegExp(','), '');
                    var lat = num.tryParse(latitude2)?.toDouble();
                    var long = num.tryParse(longitude)?.toDouble();
                      getAddress(lat, long);

                    return Card(
                          child: Stack(
                          
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      foto,
                                      width: 145,
                                      height: 150,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      
            
                                        Text(
                                          publication.name,
                                          style: TextStyle(
                                            fontSize: 21,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          publication.category,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: 150,
                                          child: Text(
                                            publication.pricing,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                 _getLocationText(lat, long),
                                        SizedBox(
                                          height: 34,
                                        ),
                                      Row(
                                       
                                        children: [
                                        
                                        Icon(Icons.comment, size: 15,),
                                         SizedBox(width:150),
                                        Icon(Icons.error, color: Colors.red,size: 15,), 
                                        Text(report.nreports, style: TextStyle(color: Colors.red),)
                                      ],)
                                      ],
                                      
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                            
                               
                  ],
                              ),
                              Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _optionsPopup(publication.id, publication, report)
                                 
                                    ],
                                  ),
                            ],
                          ),
                        );

                    }else{
                      return Container();
                    }
                   
                  },
                );
             
            
              }
              
              );
            }
          else{
               return Container();
             }
          },
        ),
      )
    );
  }
 Widget _optionsPopup(id, publication, report) {
    return PopupMenuButton<int>(
        icon: Icon(
          Icons.more_vert,
          color: Color.fromRGBO(210, 210, 210, 1),
        ),
        itemBuilder: (BuildContext context) => [
         PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 11,
                            color: Colors.grey,
                          ),
                          Text(
                            'Eliminar',
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      value: 1,
                    ),
            ],
        onSelected: (value) {
          switch (value) {
            case 1:
              

              
              _deletePublication(publication,report);
              break;
            case 2:
              // PublicationModel selectedPublication =
              //     PublicationModel.fromJsonMap(publications);

              // print(publications);
          }
        });
  }

//FIXME: Al eliminar una publicación y darle a deshacer, se cambia el orden,
// y se pierde la userid y la id original
  _deletePublication(publication,report) {
    dbUtil().deleteDocument(publication.id, "publications");
    dbUtil().deleteDocument(report.id,'reports');
    setState(() {});
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Se eliminó la publicación'),
          action: SnackBarAction(
            label: "DESHACER",
            textColor: Color.fromRGBO(49, 232, 93, 1),
            onPressed: () {
              setState(() {
                
                dbUtil().addPublication(publication);
                dbUtil().addReport(report);
              });
            },
          ),
        ),
      );
  }
   
  Widget _getLocationText(double lat, double long) {
    if(lat==29.115967 && long==-111.025490){
      print('debio entrar aqui');
   return Container(
              width: 150,
              child: Text(
                ' ',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                ),
              ),
            );
    }else{
      print('no aqui' +lat.toString()+'  '+long.toString());
    return FutureBuilder( future: getAddress(lat, long),
        builder:
            (BuildContext context, AsyncSnapshot<List<Placemark>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: 150,
              child: Text(
                snapshot.data.first.street + " " + snapshot.data.first.locality,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            return Container(
              width: 150,
              child: Text(
                ' ',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                ),
              ),
            );
          }
        });
    }

  }
  
  Future<List<Placemark>> getAddress(lat, long) async {

    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    return newPlace;
  }
}