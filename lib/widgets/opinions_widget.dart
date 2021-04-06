// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pet_auxilium/models/evaluation_model.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/textfield_widget.dart';

class Opinions extends StatefulWidget {
  Opinions(
      {@required this.id,
      @required this.category,
      @required this.pricing,
      @required this.sumscore,
      @required this.nevaluations,
      @required this.description,
      this.callback});
  VoidCallback callback;

  String id;
  String pricing;
  String category;
  var nevaluations;
  var sumscore;
  String description;
  AsyncSnapshot<QuerySnapshot> snapshot1;
  @override
  _OpinionsState createState() => _OpinionsState();

  //Opinions(this.detailDocument);
}

class _OpinionsState extends State<Opinions> {
  final dbUtil _db = dbUtil();
  String _score;
  String _comment;
  String _id = '';
  FocusNode _focusNode;
  double avgscore;
  final prefs = new preferencesUtil();
  final _firestoreInstance = FirebaseFirestore.instance;
  List<String> evaluations;
  var _commentController = TextEditingController();
  double temp = 0.0;
  double suma = 0.0;
  EvaluationModel _myEvaluation;
  UserModel modelo;
  DocumentSnapshot detailDocument;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    avgscore = this.widget.sumscore / this.widget.nevaluations;
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
          _checkEvaluations(snapshot);

          if (snapshot.hasData) {
            return _opinion(snapshot);
            print('POOL SNAPSHOT');
            //print(snapshot.data[0].userID);
            if (snapshot.connectionState == ConnectionState.done) {
              _checkEvaluations(snapshot);
            }
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
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, index) {
          EvaluationModel opinion = snapshot.data.elementAt(index);

          return Container(
              child: SingleChildScrollView(
                  child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                          // alignment: Alignment.topLeft,
                          child: Column(children: <Widget>[
                        Container(
                            height: 17,
                            width: 350,
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
                          width: 350,
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
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Align(
                    alignment: Alignment.center,
                    // alignment: Alignment.center,

                    //padding: EdgeInsets.all(1),
                    child: SingleChildScrollView(
                        reverse: true,
                        child: Column(children: <Widget>[
                          prefs.userID == ' '
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                      'Inicia sesión para hacer una evaluación.',
                                      style: TextStyle(fontSize: 16)),
                                )
                              : TextFormField(
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  // cursorColor: Theme.of(context).cursorColor,
                                  maxLength: 140,
                                  focusNode: _focusNode,
                                  onTap: _requestFocus,

                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey[400],
                                        size: 19,
                                      ),
                                      onPressed: () {
                                        _commentController.clear();
                                      },
                                    ),
                                    /*icon: Icon(
                                Icons.comment,
                                color: Colors.white,
                              ),*/
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    hintText: "Escribe una opinión...",
                                    contentPadding: EdgeInsets.fromLTRB(
                                        1, 17, 10, 0), // control yo
                                  ),
                                  controller: _commentController,
                                  onEditingComplete: () => _focusNode.unfocus(),
                                ),
                          SizedBox(height: 10),

                          if (prefs.userID != ' ')
                            Container(
                              child: Align(
                                //alignment: Alignment(-0.7, -1.0),
                                alignment: Alignment.centerLeft,
                                child: RatingBar.builder(
                                  initialRating: 2.5,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
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
//FIXME: Ya hay un widget q hace esto...
                          prefs.userID == ' '
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(49, 232, 93, 1),
                                      ),
                                      onPressed: () {
                                        Navigator.popUntil(context,
                                            ModalRoute.withName('home'));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text('Volver al inicio'),
                                      ),
                                      /* style: ButtonStyle(
                                          backgroundColor:
                                              Color.fromRGBO(49, 232, 93, 1),
                                        ),*/
                                    ),
                                  ),
                                )
                              : Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_score == null) {
                                        _score = '2.5';
                                      } else {
                                        _score = _score;
                                      }
                                      print('PUBLICAR');
                                      _evaluacion();
                                      if (this.widget.callback != null)
                                        this.widget.callback();
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
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom)),
                          SizedBox(
                            height: 21,
                          ),
                          Container(
                              width: 350,
                              child: Text.rich(TextSpan(
                                style: TextStyle(
                                  fontSize: 13.5,
                                ),
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.comment,
                                      color: Colors.black45,
                                      size: 17,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  ',
                                  ),
                                  TextSpan(
                                    text: length == '1'
                                        ? length + ' Opinión'
                                        : length + ' Opiniones',
                                    //maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ))),

                          //_opinionList(),
                        ]))))));
  }

  Widget _serviceNumbers() {
    if (this.widget.category == 'CUIDADOR') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_rate_rounded,
            color: Colors.greenAccent[400],
            size: 25,
          ),
          Text(
            avgscore.isNaN || avgscore <= 0
                ? 'N/A'
                : avgscore.toStringAsFixed(1),
          ),
          Text(" (${this.widget.nevaluations})"),
          Container(
            height: 25,
            child: VerticalDivider(
              color: Colors.black45,
              width: 20,
            ),
          ),
          Text(
            this.widget.pricing,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
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
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                            _scoredelete();
                            _db.deleteDocument(_id, "evaluations");
                            //_evaluacion();

                            _myEvaluation = null;

                            _commentController.clear();

                            this.widget.sumscore -= double.parse(_score);
                            this.widget.nevaluations--;

                            _commentController.clear();

                            setState(() {
                              avgscore = this.widget.sumscore /
                                  this.widget.nevaluations;
                            });
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

  void _scoredelete() {
    EvaluationModel evaluation = EvaluationModel(
      userID: prefs.userID,
      publicationID: this.widget.id,
      score: _score,
      comment: _commentController.text,
    );
    this.widget.nevaluations--;
    this.widget.sumscore -= double.parse(_score);
    setState(() {
      avgscore = this.widget.sumscore / this.widget.nevaluations;
    });
    _db.updateScore(evaluation);
  }

  void _evaluacion() {
    //CollectionReference docRef = _firestoreInstance.collection('evaluations');
    EvaluationModel evaluation = EvaluationModel(
      //id: docRef.doc().id,
      userID: prefs.userID,
      publicationID: this.widget.id,
      username: prefs.userName,
      score: _score,
      comment: _commentController.text,
    );
    _db.addEvaluations(evaluation);
    this.widget.sumscore += double.parse(_score);
    this.widget.nevaluations++;
    _addevaluation(/*detailDocument.id,*/ evaluations);

    setState(() {
      avgscore = this.widget.sumscore / this.widget.nevaluations;
    });
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
    print("checar la eval");
    print(_myEvaluation);
    if (this.widget.category.toString().contains('CUIDADOR')) {
      return SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //FIXME: Así como está no muestra el número de opiniones
              _serviceNumbers(),
              SizedBox(
                height: 21,
              ),
              Container(
                width: 340,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    this.widget.description,
                    //maxLines: 3,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              SizedBox(
                height: 31,
              ),
              const Divider(
                color: Colors.black12,
                height: 5,
                thickness: 2,
                indent: 1,
                endIndent: 1,
              ),
              SizedBox(
                height: 3,
              ),
              _myEvaluation == null
                  ? _makeOpinion(snapshot.data.length.toString())
                  : _showOpinion(snapshot.data.length.toString(),
                      snapshot), //Text('Ya has evaluado'),
              _listEvaluations(snapshot),
              SizedBox(
                height: 350,
              ),
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_makeOpinion(),
            const Divider(
              color: Colors.black12,
              height: 5,
              thickness: 2,
              indent: 1,
              endIndent: 1,
            ),
            SizedBox(
              height: 3,
            ),
            _listEvaluations(snapshot)
          ],
        ),
      );
    }
  }

  void _checkEvaluations(snapshot) {
    _myEvaluation = null;
    for (EvaluationModel evaluation in snapshot.data) {
      if (evaluation.userID == prefs.userID) {
        _myEvaluation = evaluation;
        _myEvaluation.id = evaluation.id;
        _id = _myEvaluation.id;
        print(_id);
        _comment = _myEvaluation.comment;
        _score = _myEvaluation.score;
        print(evaluation.comment);
      }
    }
  }
}
