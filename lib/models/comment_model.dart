class CommentModel {
  String userID;
  String publicationID;
  String username;
  String comment;
  DateTime date;
  CommentModel(
      {this.userID,
      this.publicationID,
      this.username,
      this.comment,
      this.date});

  CommentModel.fromJsonMap(Map<String, dynamic> json) {
    userID = json['userID'];
    publicationID = json['publicationID'];
    username = json['username'];
    comment = json['comment'];
    date = json['date'].toDate();
  }
}
