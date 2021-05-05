part of 'editcomplaint_bloc.dart';


class EditcomplaintState{
     final String name;
   final String desc;
   final Set<Marker> locations;
   final List<Object> imgRef;
      //final List<String> services;

  EditcomplaintState({this.name, this.desc, this.locations, this.imgRef/*, this.services*/});

   EditcomplaintState copyWith({
    String name,
    String desc, 
    Set<Marker> locations,
    List imgRef,
    //List<String> services,
  })=>EditcomplaintState(
    name: name ?? this.name,
    //services: services??this.services, 
    desc: desc ?? this.desc,
    locations: locations ?? this.locations,
    imgRef: imgRef ?? this.imgRef

  );
}
