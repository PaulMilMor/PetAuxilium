import 'package:pet_auxilium/models/publication_model.dart';

class ComplaintModel {
  String id;
  String name;
  List<dynamic> location;
  String description;
  String category;
  String userID;
  List<dynamic> imgRef;
  int nevaluations;
  var score;
  List<dynamic> followers;
  DateTime date;
  ComplaintModel(
      {this.id,
      this.name,
      this.description,
      this.location,
      this.userID,
      this.imgRef,
      this.date,
      this.category,
      this.followers,
      this.score,
      this.nevaluations});

  ComplaintModel.fromJsonMap(Map<String, dynamic> json, String cid) {
    id = cid;
    name = json['title'];
    location = json['location'];
    description = json['description'];
    userID = json['userID'];
    category = json['category'];
    date = json['date'].toDate();
    score = json['score'];
    nevaluations = json['nevaluations'];
    followers = json['followers'];
  }
  ComplaintModel.fromPublication(PublicationModel publication) {
    id = publication.id;
    category = publication.category;
    name = publication.name;
    location = publication.location;
    imgRef = publication.imgRef;
    description = publication.description;
    userID = publication.userID;
    date = publication.date;
    score = publication.score;
    nevaluations = publication.nevaluations;
    followers = publication.followers;
    //FIXME: Debería poderse comentar estas cosas?
/*    pricing = publication.pricing;
    score = publication.score;
    nevaluations = publication.nevaluations;*/
  }
}
