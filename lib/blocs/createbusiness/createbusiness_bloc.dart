import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'createbusiness_event.dart';
part 'createbusiness_state.dart';

class CreatebusinessBloc extends Bloc<CreatebusinessEvent, CreatebusinessState> {
  CreatebusinessBloc() : super(CreatebusinessState());

  @override
  Stream<CreatebusinessState> mapEventToState(
    CreatebusinessEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  Stream<CreatebusinessState> _updateName(event)async*{
    yield state.copyWith(name:event.name);
  }
  
  Stream<CreatebusinessState> _updateDesc(event)async*{
    yield state.copyWith(desc:event.desc);
  }
  
  Stream<CreatebusinessState> _updateImgs(event)async*{
    yield state.copyWith(imgRef:event.imgRef);
  }
  Stream<CreatebusinessState> _updateLocations(event)async*{
    yield state.copyWith(locations:event.locations);
  }
  Stream<CreatebusinessState> _cleanData()async*{
    yield CreatebusinessState(name: '',desc:'', imgRef: [], locations: []);
  }
}
