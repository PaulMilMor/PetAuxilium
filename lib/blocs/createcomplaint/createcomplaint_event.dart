part of 'createcomplaint_bloc.dart';

@immutable
abstract class CreatecomplaintEvent {}
class UpdateName extends CreatecomplaintEvent{
  final String name;

  UpdateName(this.name);
}
class UpdateDesc extends CreatecomplaintEvent{
  final String desc;

  UpdateDesc(this.desc);
}
/*class UpdateServices extends EditcomplaintEvent{
  final List<String> services;

  UpdateServices(this.services);
}*/

class UpdateComplaintLocations extends CreatecomplaintEvent{
  final Set<Marker> locations;

  UpdateComplaintLocations(this.locations);
}
class UpdateImgs extends CreatecomplaintEvent{
  final List<Object> imgRef;

  UpdateImgs(this.imgRef);
}
class CleanData extends CreatecomplaintEvent{}