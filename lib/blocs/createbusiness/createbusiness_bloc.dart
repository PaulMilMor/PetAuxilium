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
     if(event is UpdateBusinessName){
  yield* this._updateBusinessName(event);
   }else if(event is UpdateBusinessDesc){
  yield* this._updateBusinessDesc(event);
   }else if(event is UpdateBusinessServices){
  yield* this._updateBusinessServices(event);
   }else if(event is UpdateBusinessLocations){
  yield* this._updateBusinessLocations(event);   
   }else if(event is UpdateBusinessImgs){
  yield* this._updateBusinessImgs(event);
   }else if(event is CleanData){
  yield* this._cleanData(); 
   }
  }

  Stream<CreatebusinessState> _updateBusinessName(event)async*{
    yield state.copyWith(name:event.name);
  }
  
  Stream<CreatebusinessState> _updateBusinessDesc(event)async*{
    yield state.copyWith(desc:event.desc);
  }
  
  Stream<CreatebusinessState> _updateBusinessImgs(event)async*{
    yield state.copyWith(imgRef:event.imgRef);
  }
  Stream<CreatebusinessState> _updateBusinessLocations(event)async*{
    yield state.copyWith(locations:event.locations);
  }
  
  Stream<CreatebusinessState> _updateBusinessServices(event)async*{
    yield state.copyWith(services: event.services);
  }
  Stream<CreatebusinessState> _cleanData()async*{
    yield CreatebusinessState(name: '',desc:'',services: [], imgRef: [], locations: Set<Marker>());
  }
}
