part of 'editpublication_bloc.dart';

 class EditpublicationState {
   final String name;
   final String category;
   final String desc;
   final Set<Marker> locations;
   final  List<Object>  imgRef;

  EditpublicationState({this.name='', this.category='ADOPCIÓN', this.desc='', this.locations, this.imgRef});
  EditpublicationState copyWith({
    String name,
    String category, 
    String desc, 
    Set<Marker> locations,
    List imgRef
  })=>EditpublicationState(
    name: name ?? this.name,
    category:  category ?? this.category,
    desc: desc ?? this.desc,
    locations: locations ?? this.locations,
    imgRef: imgRef ?? this.imgRef

  );


 }

