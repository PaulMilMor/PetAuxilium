import 'package:flutter/material.dart';
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
  final prefs = new preferencesUtil();
  List<String> evaluations;
  var _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _db.getOpinions(this.widget.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<EvaluationModel>> snapshot) {
          if (snapshot.hasData) {
            return _opinion(snapshot);
          } else {
            return _makeOpinion('0');
          }
        });
  }

  Widget _listEvaluations(snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, index) {
          EvaluationModel opinion = snapshot.data.elementAt(index);
          return Container(
              child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(1),
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[
                          Container(
                            child: ListTile(
                              title: Text(opinion.username),
                              trailing: Text(opinion.comment),
                            ),
                          ),
                        ],
                      )))));
        });
  }

  Widget _makeOpinion(length) {
    return Container(
        child: Material(
            type: MaterialType.transparency,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(1),
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        length + ' Opiniones',
                        //maxLines: 3,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  //FIXME: El GrayTextFormField es para usarse gris, en lugares donde encaja el campo gris
                  // Para todo lo demás se usa un TextField o TextFormField normal
                  //FIXME: No se ve el campo de texto al escribir
                  GrayTextFormField(
                    // cursorColor: Theme.of(context).cursorColor,
                    maxLength: 140,

                    maxLines: 1,
                    decoration: InputDecoration(
                      icon: Icon(Icons.comment),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      disabledBorder: UnderlineInputBorder(
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
                        itemSize: 24,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0),
                        itemBuilder: (context, _) => Icon(Icons.star_rounded,
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
                    height: 24,
                  ),

                  //_opinionList(),
                ])))));
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
            _makeOpinion(snapshot.data.length.toString()),
            _listEvaluations(snapshot)
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
}
