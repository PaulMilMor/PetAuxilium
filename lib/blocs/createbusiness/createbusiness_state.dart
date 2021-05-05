part of 'createbusiness_bloc.dart';


class CreatebusinessState{
     final String name;
   final String desc;
   final Set<Marker> locations;
   final List imgRef;
      final List<String> services;

  CreatebusinessState({this.name, this.desc, this.locations, this.imgRef, this.services});

   CreatebusinessState copyWith({
    String name,
    String desc, 
    Set<Marker> locations,
    List imgRef,
    List<String> services,
  })=>CreatebusinessState(
    name: name ?? this.name,
     services: services??this.services, 
    desc: desc ?? this.desc,
    locations: locations ?? this.locations,
    imgRef: imgRef ?? this.imgRef

  );
}
