class UserModel{
String name;
String email;
String pass;
String birthday;
String imgRef;
String id;
List follows;
List evaluationsID;
 UserModel({this.id,this.email,this.pass, this.name, this.birthday, this.imgRef, this.follows,this.evaluationsID});
   UserModel.fromJsonMap(Map<String, dynamic> json) {
    name = json['name'];

    follows = json['follows'];
    evaluationsID = json['evaluationsID'];  
  }
}

