part of 'createbusiness_bloc.dart';


class CreatebusinessState{
     final String name;
   final String desc;
   final List<LatLng> locations;
   final List imgRef;

  CreatebusinessState({this.name, this.desc, this.locations, this.imgRef});

   CreatebusinessState copyWith({
    String name,
    String desc, 
    List<LatLng> locations,
    List imgRef
  })=>CreatebusinessState(
    name: name ?? this.name,
 
    desc: desc ?? this.desc,
    locations: locations ?? this.locations,
    imgRef: imgRef ?? this.imgRef

  );
}
