part of 'createbusiness_bloc.dart';

@immutable
abstract class CreatebusinessEvent {}
class UpdateBusinessName extends CreatebusinessEvent{
  final String name;

  UpdateBusinessName(this.name);
}
class UpdateBusinessDesc extends CreatebusinessEvent{
  final String desc;

  UpdateBusinessDesc(this.desc);
}
class UpdateBusinessServices extends CreatebusinessEvent{
  final List<String> services;

  UpdateBusinessServices(this.services);
}

class UpdateBusinessLocations extends CreatebusinessEvent{
  final Set<Marker> locations;

  UpdateBusinessLocations(this.locations);
}
class UpdateBusinessImgs extends CreatebusinessEvent{
  final List imgRef;

  UpdateBusinessImgs(this.imgRef);
}
class CleanData extends CreatebusinessEvent{}