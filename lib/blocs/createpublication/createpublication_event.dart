part of 'createpublication_bloc.dart';

@immutable
abstract class CreatepublicationEvent {}
class UpdateName extends CreatepublicationEvent{
  final String name;

  UpdateName(this.name);
}
class UpdateDesc extends CreatepublicationEvent{
  final String desc;

  UpdateDesc(this.desc);
}
class UpdateCategory extends CreatepublicationEvent{
  final String category;

  UpdateCategory(this.category);
}

class UpdateLocations extends CreatepublicationEvent{
  final Set<Marker> locations;

  UpdateLocations(this.locations);
}
class UpdateImgs extends CreatepublicationEvent{
  final  List<Object>  imgRef;

  UpdateImgs(this.imgRef);
}
class CleanData extends CreatepublicationEvent{}