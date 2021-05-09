import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/optionspopup_widget.dart';

class ListFeed extends StatefulWidget {
  ListFeed(
      {
      //this.itemCount,
      @required this.snapshot,
      this.follows,
      this.voidCallback,
      this.category,
      this.physics,
      this.orderBy});

  final VoidCallback voidCallback;
  var snapshot;
  List<String> follows;
  String category;
  ScrollPhysics physics;
  String orderBy;
  @override
  _ListFeedState createState() => _ListFeedState();
}

class _ListFeedState extends State<ListFeed> {
  MapsUtil mapsUtil = MapsUtil();

  final preferencesUtil _prefs = preferencesUtil();
  @override
  Widget build(BuildContext context) {
    _sortList();
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: this.widget.physics,
        itemCount: this.widget.snapshot.data.length,
        itemBuilder: (BuildContext context, index) {
          PublicationModel _data = this.widget.snapshot.data[index];

          List<dynamic> _fotos = _data.imgRef;
          String _foto = _fotos.first;

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => DetailPage(
                        _data, this.widget.follows, this.widget.voidCallback)),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      _foto,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_data.name,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis),
                            Text(
                              _data.category,
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
                                _data.pricing,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),

                            Container(
                                alignment: Alignment.centerLeft,
                                width: 171,
                                child: mapsUtil
                                    .getLocationText(_data.location.first)),
                            SizedBox(
                              height: 20,
                            ),
                            //Aquí está el promedio we
                            // if (_data['category'] == 'CUIDADOR')
                            //   _rating(_data['nevaluations'], _data['score']),
                            _rating(_data),
                          ],
                        )),
                  ),
                  Spacer(),
                  _prefs.userID == ' '
                      ? Text('')
                      : OptionPopup(
                          publication: _data,
                          follows: widget.follows,
                          voidCallback: widget.voidCallback,
                        )
                ],
              ),
            ),
          );
        });
  }

  _sortList() {
    if (this.widget.orderBy == null) {
      this.widget.snapshot.data.sort(
          (PublicationModel a, PublicationModel b) => b.date.compareTo(a.date));
    } else {
      switch (this.widget.orderBy) {
        case 'Más recientes':
          this.widget.snapshot.data.sort(
              (PublicationModel a, PublicationModel b) =>
                  b.date.compareTo(a.date));
          break;
        /* case 'Más antiguas':
          this.widget.snapshot.data.sort(
              (PublicationModel a, PublicationModel b) =>
                  a.date.compareTo(b.date));
          break;*/
        case 'Más populares':
          this.widget.snapshot.data.sort(
              (PublicationModel a, PublicationModel b) =>
                  b.nevaluations.compareTo(a.nevaluations));
          break;

        case 'Mejor valorados':
          this
              .widget
              .snapshot
              .data
              .sort((PublicationModel a, PublicationModel b) {
            /*if (b.score == 0 && b.score < a.score) {
              return -1;
            }*/
            /*if (b.nevaluations == 0 && b.nevaluations < a.nevaluations) {
              return 1;
            }*/
            if (a.score == 0 && b.score == 0) {
              return b.nevaluations.compareTo(a.nevaluations);
            } else if (b.nevaluations == 0) {
              return (b.score / (b.nevaluations + 1))
                  .compareTo(a.score / a.nevaluations);
            } else if (a.nevaluations == 0) {
              return (b.score / b.nevaluations)
                  .compareTo(a.score / (a.nevaluations + 1));
            }
            return (b.score / b.nevaluations)
                .compareTo(a.score / a.nevaluations);
          });
          break;
        /*case 'Mejor tarifa':
          this.widget.snapshot.data.sort(
              (PublicationModel a, PublicationModel b) =>
                  b.pricing.compareTo(a.pricing));
          break;*/
      }
    }
  }

  Widget _rating(publication) {
    bool isCuidador =
        publication.category == 'CUIDADOR' || publication.category == 'NEGOCIO';
    double mean = 0;
    if (isCuidador) mean = publication.score / publication.nevaluations;
    return Row(
      children: [
        if (isCuidador)
          Row(
            children: [
              Icon(
                Icons.star_rate_rounded,
                color: Color.fromRGBO(210, 210, 210, 1),
                size: 25,
              ),
              Text(
                publication.nevaluations == 0 ? 'N/A' : mean.toStringAsFixed(1),
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        Icon(
          Icons.comment,
          color: Color.fromRGBO(210, 210, 210, 1),
          size: 20,
        ),
        Text(
          " ${publication.nevaluations}",
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class DestacadosList extends StatefulWidget {
  DestacadosList(
      {
      //this.itemCount,
      @required this.snapshot,
      this.follows,
      this.voidCallback,
      this.category,
      this.physics,
      this.orderBy});

  final VoidCallback voidCallback;
  var snapshot;
  List<String> follows;
  String category;
  ScrollPhysics physics;
  String orderBy;
  @override
  _DestacadosListState createState() => _DestacadosListState();
}

class _DestacadosListState extends State<DestacadosList> {
  MapsUtil mapsUtil = MapsUtil();
  final preferencesUtil _prefs = preferencesUtil();
  @override
  Widget build(BuildContext context) {
    _sortList();
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: this.widget.physics,
        itemCount: this.widget.snapshot.data.length,
        itemBuilder: (BuildContext context, index) {
          PublicationModel _data = this.widget.snapshot.data[index];

          List<dynamic> _fotos = _data.imgRef;
          String _foto = _fotos.first;

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => DetailPage(
                        _data, this.widget.follows, this.widget.voidCallback)),
              );
            },
            child: Container(
              width: 160,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        child: Image.network(
                          _foto,
                          width: 160,
                          //height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_data.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis),
                            Spacer(),
                            _prefs.userID == ' '
                                ? Text('')
                                : Container(
                                    width: 35,
                                    child: OptionPopup(
                                        publication: _data,
                                        follows: widget.follows,
                                        voidCallback: widget.voidCallback,
                                        size: 'small'),
                                  )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Text(
                            _data.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green,
                            ),
                          ),
                          Icon(Icons.verified, color: Colors.green, size: 10),
                        ],
                      ),
                    )),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _data.pricing,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[700],
                              ),
                            ),
                            mapsUtil.getLocationText(_data.location.first),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                        child: _rating(_data),
                      ),
                    )
                    /* Flexible(
                      flex: 5,
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_data.name,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                _data.category,
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
                                  _data.pricing,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),

                              Container(
                                  alignment: Alignment.centerLeft,
                                  width: 171,
                                  child: mapsUtil
                                      .getLocationText(_data.location.first)),
                              SizedBox(
                                height: 20,
                              ),
                              //Aquí está el promedio we
                              // if (_data['category'] == 'CUIDADOR')
                              //   _rating(_data['nevaluations'], _data['score']),
                              _rating(_data),
                            ],
                          )),
                    ),
                    Spacer(),
                    _prefs.userID == ' '
                        ? Text('')
                        : OptionPopup(
                            publication: _data,
                            follows: widget.follows,
                            voidCallback: widget.voidCallback,
                          )*/
                  ],
                ),
              ),
            ),
          );
        });
  }

  _sortList() {
    if (this.widget.orderBy == null) {
      this.widget.snapshot.data.sort(
          (PublicationModel a, PublicationModel b) => b.date.compareTo(a.date));
    } else {
      switch (this.widget.orderBy) {
        case 'Más recientes':
          this.widget.snapshot.data.sort(
              (PublicationModel a, PublicationModel b) =>
                  b.date.compareTo(a.date));
          break;
        /* case 'Más antiguas':
          this.widget.snapshot.data.sort(
              (PublicationModel a, PublicationModel b) =>
                  a.date.compareTo(b.date));
          break;*/
        case 'Más populares':
          this.widget.snapshot.data.sort(
              (PublicationModel a, PublicationModel b) =>
                  b.nevaluations.compareTo(a.nevaluations));
          break;

        case 'Mejor valorados':
          this
              .widget
              .snapshot
              .data
              .sort((PublicationModel a, PublicationModel b) {
            /*if (b.score == 0 && b.score < a.score) {
              return -1;
            }*/
            /*if (b.nevaluations == 0 && b.nevaluations < a.nevaluations) {
              return 1;
            }*/
            if (a.score == 0 && b.score == 0) {
              return b.nevaluations.compareTo(a.nevaluations);
            } else if (b.nevaluations == 0) {
              return (b.score / (b.nevaluations + 1))
                  .compareTo(a.score / a.nevaluations);
            } else if (a.nevaluations == 0) {
              return (b.score / b.nevaluations)
                  .compareTo(a.score / (a.nevaluations + 1));
            }
            return (b.score / b.nevaluations)
                .compareTo(a.score / a.nevaluations);
          });
          break;
        /*case 'Mejor tarifa':
          this.widget.snapshot.data.sort(
              (PublicationModel a, PublicationModel b) =>
                  b.pricing.compareTo(a.pricing));
          break;*/
      }
    }
  }

  Widget _rating(publication) {
    bool isCuidador =
        publication.category == 'CUIDADOR' || publication.category == 'NEGOCIO';
    double mean = 0;
    if (isCuidador) mean = publication.score / publication.nevaluations;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isCuidador)
          Row(
            children: [
              Icon(
                Icons.star_rate_rounded,
                color: Color.fromRGBO(210, 210, 210, 1),
                size: 15,
              ),
              Text(
                publication.nevaluations == 0 ? 'N/A' : mean.toStringAsFixed(1),
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        Icon(
          Icons.comment,
          color: Color.fromRGBO(210, 210, 210, 1),
          size: 12,
        ),
        Text(
          " ${publication.nevaluations}",
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
