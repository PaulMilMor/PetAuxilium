part of 'createpublication_bloc.dart';

 class CreatepublicationState {
   final String name;
   final String category;
   final String desc;
   final Set<Marker> locations;
   final  List<Object>  imgRef;

  CreatepublicationState({this.name='', this.category='ADOPCIÓN', this.desc='', this.locations, this.imgRef});
  CreatepublicationState copyWith({
    String name,
    String category, 
    String desc, 
    Set<Marker> locations,
    List imgRef
  })=>CreatepublicationState(
    name: name ?? this.name,
    category:  category ?? this.category,
    desc: desc ?? this.desc,
    locations: locations ?? this.locations,
    imgRef: imgRef ?? this.imgRef

  );


 }

