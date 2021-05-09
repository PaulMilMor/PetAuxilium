import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'editcomplaint_event.dart';
part 'editcomplaint_state.dart';

class EditcomplaintBloc extends Bloc<EditcomplaintEvent, EditcomplaintState> {
  EditcomplaintBloc() : super(EditcomplaintState());

  @override
  Stream<EditcomplaintState> mapEventToState(
    EditcomplaintEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if(event is UpdateName){
  yield* this._updateName(event);
   }else if(event is UpdateDesc){
  yield* this._updateDesc(event);
   }else if(event is EditComplaintUpdateLocations){
  yield* this._updateLocations(event);   
   }else if(event is UpdateImgs){
  yield* this._updateImgs(event);
   }else if(event is CleanData){
  yield* this._cleanData(); 
   }
  }

  Stream<EditcomplaintState> _updateName(event)async*{
    yield state.copyWith(name:event.name);
  }
  
  Stream<EditcomplaintState> _updateDesc(event)async*{
    yield state.copyWith(desc:event.desc);
  }
  
  Stream<EditcomplaintState> _updateImgs(event)async*{
    yield state.copyWith(imgRef:event.imgRef);
  }
  Stream<EditcomplaintState> _updateLocations(event)async*{
    yield state.copyWith(locations:event.locations);
  }
  Stream<EditcomplaintState> _cleanData()async*{
    yield EditcomplaintState(name: '',desc:'', imgRef: [], locations:Set<Marker>());
  }
}
