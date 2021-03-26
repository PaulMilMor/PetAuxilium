
class EvaluationModel {
  String id;
  String userID;
  String publicationID;
  String username;
  String score;
  String comment;
  EvaluationModel(
      {this.id,
      this.userID,
      this.publicationID,
      this.username,
      this.score,
      this.comment});

  EvaluationModel.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    publicationID = json['publicationID'];
    username = json['username'];
    score = json['score'];
    comment = json['comment'];
  }
}