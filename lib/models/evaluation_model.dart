class EvaluationModel {
  String userID;
  String publicationID;
  String username;
  String score;
  String comment;
  EvaluationModel(
      {this.userID,
      this.publicationID,
      this.username,
      this.score,
      this.comment});

  EvaluationModel.fromJsonMap(Map<String, dynamic> json) {
    userID = json['userID'];
    publicationID = json['publicationID'];
    username = json['username'];
    score = json['score'];
    comment = json['comment'];
  }
}
