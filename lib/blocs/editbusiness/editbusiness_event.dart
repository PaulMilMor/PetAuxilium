part of 'editbusiness_bloc.dart';

@immutable
abstract class EditbusinessEvent {}

class UpdateName extends EditbusinessEvent {
  final String name;

  UpdateName(this.name);
}

class UpdateDesc extends EditbusinessEvent {
  final String desc;

  UpdateDesc(this.desc);
}

class UpdateServices extends EditbusinessEvent {
  final List<String> services;

  UpdateServices(this.services);
}

class EditUpdateLocations extends EditbusinessEvent {
  final Set<Marker> locations;

  EditUpdateLocations(this.locations);
}

class UpdateImgs extends EditbusinessEvent {
  final List<Object> imgRef;

  UpdateImgs(this.imgRef);
}

class CleanData extends EditbusinessEvent {}
