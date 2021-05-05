part of 'editbusiness_bloc.dart';

class EditbusinessState {
  final String name;
  final String desc;
  final Set<Marker> locations;
  final List<Object> imgRef;
  final List<String> services;

  EditbusinessState(
      {this.name, this.desc, this.locations, this.imgRef, this.services});

  EditbusinessState copyWith({
    String name,
    String desc,
    Set<Marker> locations,
    List imgRef,
    List<String> services,
  }) =>
      EditbusinessState(
          name: name ?? this.name,
          services: services ?? this.services,
          desc: desc ?? this.desc,
          locations: locations ?? this.locations,
          imgRef: imgRef ?? this.imgRef);
}
