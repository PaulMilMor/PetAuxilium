part of 'editpublication_bloc.dart';

@immutable
abstract class EditpublicationEvent {}
class UpdateName extends EditpublicationEvent{
  final String name;

  UpdateName(this.name);
}
class UpdateDesc extends EditpublicationEvent{
  final String desc;

  UpdateDesc(this.desc);
}
class UpdateCategory extends EditpublicationEvent{
  final String category;

  UpdateCategory(this.category);
}

class EditUpdateLocations extends EditpublicationEvent{
  final Set<Marker> locations;

  EditUpdateLocations(this.locations);
}
class UpdateImgs extends EditpublicationEvent{
  final  List<Object>  imgRef;

  UpdateImgs(this.imgRef);
}
class CleanData extends EditpublicationEvent{
  
}