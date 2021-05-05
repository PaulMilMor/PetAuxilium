  
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'editbusiness_event.dart';
part 'editbusiness_state.dart';

class EditbusinessBloc extends Bloc<EditbusinessEvent, EditbusinessState> {
  EditbusinessBloc() : super(EditbusinessState());

  @override
  Stream<EditbusinessState> mapEventToState(
    EditbusinessEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if(event is UpdateName){
  yield* this._updateName(event);
   }else if(event is UpdateDesc){
  yield* this._updateDesc(event);
   }/*else if(event is UpdateCategory){
  yield* this._updateCategory(event);
   }*/else if(event is EditUpdateLocations){
  yield* this._updateLocations(event);   
   }else if(event is UpdateImgs){
  yield* this._updateImgs(event);
   }else if(event is CleanData){
  yield* this._cleanData(); 
   }
  }

  Stream<EditbusinessState> _updateName(event)async*{
    yield state.copyWith(name:event.name);
  }
  
  Stream<EditbusinessState> _updateDesc(event)async*{
    yield state.copyWith(desc:event.desc);
  }
  
  Stream<EditbusinessState> _updateImgs(event)async*{
    yield state.copyWith(imgRef:event.imgRef);
  }
  Stream<EditbusinessState> _updateLocations(event)async*{
    yield state.copyWith(locations:event.locations);
  }
  Stream<EditbusinessState> _cleanData()async*{
    yield EditbusinessState(name: '',desc:'', imgRef: [], locations:Set<Marker>());
  }
}