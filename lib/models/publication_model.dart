import 'package:google_maps_flutter/google_maps_flutter.dart';
class PublicationModel{
String id;
String category;
String name;
String description;
List<String> location;
List<String> imgRef;
String userID;
PublicationModel({this.id,this.category,this.name,this.description, this.location, this.imgRef, this.userID});

}