// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pet_auxilium/models/evaluation_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';

class Opinions extends StatefulWidget {
  Opinions({@required this.id, @required this.category});
  String id;
  String category;
  @override
  _OpinionsState createState() => _OpinionsState();
}

class _OpinionsState extends State<Opinions> {
  final dbUtil _db = dbUtil();
  String _score;
  String _comment;
  FocusNode _focusNode;
  final prefs = new preferencesUtil();
  List<String> evaluations;
  var _commentController = TextEditingController();
  String promedio = "0.0";
  double temp = 0.0;
  double suma = 0.0;
  double prom = 0.0;
  int contador1;
  String contador = "0";
  EvaluationModel _myEvaluation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    promedio = "5";
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _db.getOpinions(this.widget.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<EvaluationModel>> snapshot) {
          print('POOL SNAPSHOT');
          print(snapshot.data[0].userID);
          _checkEvaluations(snapshot);
          if (snapshot.hasData) {
            print("joder con la actualizacion de pantalla");
            return _opinion(snapshot);
          } else {
            return _makeOpinion('0');
          }
        });
  }

//TODO: Darle formato correcto a las evaluaciones
//FIXME: Así como está, si un comentario tiene más de una linea, el
//nombre del usuario sale en vertical
//FIXME: El área donde están los comentarios no se puede hacer scroll
  Widget _listEvaluations(snapshot) {
    suma = 0;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, index) {
          EvaluationModel opinion = snapshot.data.elementAt(index);

          temp = double.parse(opinion.score);
          print("El temporal");
          print(temp);
          print("La perra suma");
          suma = temp + suma;
          print(suma);

          print("el pinchi promedio");
          prom = suma / snapshot.data.length;
          //contador++;
          print(prom);
          contador1 = snapshot.data.length;
          promedio = prom.toStringAsFixed(1);
          contador = contador1.toString();
          //print(promedio);
          return Container(
              child: SingleChildScrollView(
                  child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                          // alignment: Alignment.topLeft,
                          child: Column(children: <Widget>[
                        Container(
                            height: 17,
                            width: 330,
                            child: Text.rich(TextSpan(
                              style: TextStyle(
                                fontSize: 13.5,
                              ),
                              children: [
                                TextSpan(
                                  text: opinion.username + "  ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                WidgetSpan(
                                  child: Icon(
                                    Icons.star_rate_rounded,
                                    color: Colors.greenAccent[400],
                                    size: 17,
                                  ),
                                ),
                                TextSpan(
                                  text: opinion.score,
                                ),
                              ],
                            ))),
                        Container(
                          width: 330,
                          alignment: Alignment.topLeft,
                          child: Text(opinion.comment,
                              textAlign: TextAlign.justify,
                              style: new TextStyle()),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                      ])))));
        });
  }

  Widget _makeOpinion(length) {
    return Container(
        child: Material(
            type: MaterialType.transparency,
            child: Container(
                width: 345,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Align(
                    alignment: Alignment.center,
                    // alignment: Alignment.center,

                    //padding: EdgeInsets.all(1),
                    child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                      Container(
                        width: 290,
                        height: 40,
                        child: Row(children: [
                          Icon(
                            Icons.star_rate_rounded,
                            color: Colors.greenAccent[400],
                            size: 25,
                          ),
                          Text(promedio),
                          Text(" (" + contador + ")")
                        ]),
                      ),
                      Container(
                        width: 290,
                        height: 40,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            length == '1'
                                ? length + ' Opinión'
                                : length + ' Opiniones',
                            //maxLines: 3,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),

                      //FIXME: El GrayTextFormField es para usarse gris, en lugares donde encaja el campo gris
                      // Para todo lo demás se usa un TextField o TextFormField normal
                      //FIXME: No se ve el campo de texto al escribir
                      TextFormField(
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        // cursorColor: Theme.of(context).cursorColor,
                        maxLength: 140,
                        focusNode: _focusNode,
                        onTap: _requestFocus,
                        maxLines: 1,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.comment,
                            color: Colors.white,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: "Escribe una opinión...",
                        ),
                        controller: _commentController,
                      ),

                      Container(
                        child: Align(
                          alignment: Alignment(-0.7, -1.0),
                          child: RatingBar.builder(
                            initialRating: 2.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0),
                            itemBuilder: (context, _) => Icon(
                                Icons.star_rounded,
                                color: Colors.greenAccent[400]),
                            onRatingUpdate: (rating) {
                              print("sumadre");
                              print(rating);
                              _score = rating.toString();
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            print('PUBLICAR');
                            _evaluacion();
                            setState(() {});
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'PUBLICAR',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 11,
                      ),

                      //_opinionList(),
                    ]))))));
  }

  Widget _showOpinion(length, snapshot) {
    return Container(
        child: Material(
            type: MaterialType.transparency,
            child: Container(
                width: 345,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                      Container(
                        width: 290,
                        height: 40,
                        child: Row(children: [
                          Icon(
                            Icons.star_rate_rounded,
                            color: Colors.greenAccent[400],
                            size: 25,
                          ),
                          Text(promedio),
                          Text(" (" + contador + ")")
                        ]),
                      ),
                      Container(
                        width: 290,
                        height: 40,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            length == '1'
                                ? length + ' Opinión'
                                : length + ' Opiniones',
                            //maxLines: 3,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        width: 290,
                        height: 60,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(children: <Widget>[
                            Row(children: [
                              Text(
                                prefs.userName,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.justify,
                              ),
                              Icon(
                                Icons.star_rate_rounded,
                                color: Colors.greenAccent[400],
                                size: 20,
                              ),
                              Text(
                                _score,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.justify,
                              ),

                            ]),
                            Text(
                              _comment,
                              textAlign: TextAlign.left,
                            ),
                          ]),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            print('Eliminar comentario');
                            //_evaluacion();
                            setState(() {});
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'ELIMINAR EVALUACIÓN',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 11,
                      ),

                      //_opinionList(),
                    ]))))));
  }

  void _evaluacion() {
    EvaluationModel evaluation = EvaluationModel(
      userID: prefs.userID,
      publicationID: this.widget.id,
      username: prefs.userName,
      score: _score,
      comment: _commentController.text,
    );
    _db.addEvaluations(evaluation);

    _addevaluation(/*detailDocument.id,*/ evaluations);
  }

  void _addevaluation(evaluations) async {
    if (evaluations.contains(this.widget.id)) {
      evaluations.remove(this.widget.id);
    } else {
      evaluations.add(this.widget.id);
    }
    _db.updateEvaluations(evaluations);
  }

  Widget _opinion(snapshot) {
    if (this.widget.category.toString().contains('CUIDADOR')) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //FIXME: Así como está no muestra el número de opiniones
            _myEvaluation == null
                ? _makeOpinion(snapshot.data.length.toString())
                : _showOpinion(snapshot.data.length.toString(),
                    snapshot), //Text('Ya has evaluado'),
            _listEvaluations(snapshot),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_makeOpinion(),

            _listEvaluations(snapshot)
          ],
        ),
      );
    }
  }

  void _checkEvaluations(snapshot) {
    for (EvaluationModel evaluation in snapshot.data) {
      if (evaluation.userID == prefs.userID) {
        _myEvaluation = evaluation;
        _comment = _myEvaluation.comment;
        _score = _myEvaluation.score;
      }
    }
  }
}
