class UserModel{
String name;
String email;
String pass;
String birthday;
String imgRef;
String id;
List follows;
 UserModel({this.id,this.email,this.pass, this.name, this.birthday, this.imgRef, this.follows});
   UserModel.fromJsonMap(Map<String, dynamic> json) {
    name = json['name'];
   
    follows = json['follows'];
   
  }
}

