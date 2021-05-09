import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'createcomplaint_event.dart';
part 'createcomplaint_state.dart';

class CreatecomplaintBloc extends Bloc<CreatecomplaintEvent, CreatecomplaintState> {
  CreatecomplaintBloc() : super(CreatecomplaintState());

  @override
  Stream<CreatecomplaintState> mapEventToState(
    CreatecomplaintEvent event,
  ) async* {
   // TODO: implement mapEventToState
    if(event is UpdateName){
  yield* this._updateName(event);
   }else if(event is UpdateDesc){
  yield* this._updateDesc(event);
   }else if(event is UpdateComplaintLocations){
  yield* this._updateLocations(event);   
   }else if(event is UpdateImgs){
  yield* this._updateImgs(event);
   }else if(event is CleanData){
  yield* this._cleanData(); 
   }
  }

  Stream<CreatecomplaintState> _updateName(event)async*{
    yield state.copyWith(name:event.name);
  }
  
  Stream<CreatecomplaintState> _updateDesc(event)async*{
    yield state.copyWith(desc:event.desc);
  }
  
  Stream<CreatecomplaintState> _updateImgs(event)async*{
    yield state.copyWith(imgRef:event.imgRef);
  }
  Stream<CreatecomplaintState> _updateLocations(event)async*{
    yield state.copyWith(locations:event.locations);
  }
  Stream<CreatecomplaintState> _cleanData()async*{
    yield CreatecomplaintState(name: '',desc:'', imgRef: [], locations:Set<Marker>());
  }
}
