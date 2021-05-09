part of 'createcomplaint_bloc.dart';

class CreatecomplaintState{
     final String name;
   final String desc;
   final Set<Marker> locations;
   final List<Object> imgRef;
      //final List<String> services;

  CreatecomplaintState({this.name, this.desc, this.locations, this.imgRef/*, this.services*/});

   CreatecomplaintState copyWith({
    String name,
    String desc, 
    Set<Marker> locations,
    List imgRef,
    //List<String> services,
  })=>CreatecomplaintState(
    name: name ?? this.name,
    //services: services??this.services, 
    desc: desc ?? this.desc,
    locations: locations ?? this.locations,
    imgRef: imgRef ?? this.imgRef

  );
}