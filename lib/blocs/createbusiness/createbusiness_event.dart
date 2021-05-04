part of 'createbusiness_bloc.dart';

@immutable
abstract class CreatebusinessEvent {}
class UpdateName extends CreatebusinessEvent{
  final String name;

  UpdateName(this.name);
}
class UpdateDesc extends CreatebusinessEvent{
  final String desc;

  UpdateDesc(this.desc);
}
class UpdateCategory extends CreatebusinessEvent{
  final String category;

  UpdateCategory(this.category);
}

class UpdateLocations extends CreatebusinessEvent{
  final List<LatLng> locations;

  UpdateLocations(this.locations);
}
class UpdateImgs extends CreatebusinessEvent{
  final List imgRef;

  UpdateImgs(this.imgRef);
}
class CleanData extends CreatebusinessEvent{}