part of 'editcomplaint_bloc.dart';

@immutable
abstract class EditcomplaintEvent {}
class UpdateName extends EditcomplaintEvent{
  final String name;

  UpdateName(this.name);
}
class UpdateDesc extends EditcomplaintEvent{
  final String desc;

  UpdateDesc(this.desc);
}
/*class UpdateServices extends EditcomplaintEvent{
  final List<String> services;

  UpdateServices(this.services);
}*/

class EditUpdateLocations extends EditcomplaintEvent{
  final Set<Marker> locations;

  EditUpdateLocations(this.locations);
}
class UpdateImgs extends EditcomplaintEvent{
  final List<Object> imgRef;

  UpdateImgs(this.imgRef);
}
class CleanData extends EditcomplaintEvent{}