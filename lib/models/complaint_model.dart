class ComplaintModel {
  String name;
  List<dynamic> location;
  String description;
  String category;
  String userID;
  List<dynamic> imgRef;

  List<dynamic> followers;
  DateTime date;
  ComplaintModel(
      {this.name,
      this.description,
      this.location,
      this.userID,
      this.imgRef,
      this.date,
      this.category,
      this.followers});

  ComplaintModel.fromJsonMap(Map<String, dynamic> json) {
    name = json['title'];
    location = json['location'];
    description = json['description'];
    userID = json['userID'];
    category = json['category'];
    date = json['date'].toDate();

    followers = json['followers'];
  }
}
