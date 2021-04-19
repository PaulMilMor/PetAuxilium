class UserModel{
String name;
String email;
String pass;
String birthday;
String imgRef;
String id;
String token;
List follows;
List evaluationsID;
List notifications;
 UserModel({this.id,this.email,this.pass, this.name, this.birthday, this.imgRef, this.follows,this.evaluationsID, this.token});
   UserModel.fromJsonMap(Map<String, dynamic> json) {
    name = json['name'];

    follows = json['follows'];
    evaluationsID = json['evaluationsID'];  
  }
}

