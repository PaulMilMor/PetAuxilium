class ComplaintModel {
  String title;
  List<dynamic> location;
  String description;
  String userID;
  List<dynamic> imgRef;

  ComplaintModel(
      {this.title, this.description, this.location, this.userID, this.imgRef});

  ComplaintModel.fromJsonMap(Map<String, dynamic> json) {
    title = json['title'];
    location = json['location'];
    description = json['description'];
    userID = json['userID'];
  }
}
