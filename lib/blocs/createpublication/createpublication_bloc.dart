import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'createpublication_event.dart';
part 'createpublication_state.dart';

class CreatepublicationBloc extends Bloc<CreatepublicationEvent, CreatepublicationState> {
  CreatepublicationBloc() : super(CreatepublicationState());

  @override
  Stream<CreatepublicationState> mapEventToState(
    CreatepublicationEvent event,
  ) async* {
   if(event is UpdateName){
  yield* this._updateName(event);
   }else if(event is UpdateDesc){
  yield* this._updateDesc(event);
   }else if(event is UpdateCategory){
  yield* this._updateCategory(event);
   }else if(event is UpdateLocations){
  yield* this._updateLocations(event);   
   }else if(event is UpdateImgs){
  yield* this._updateImgs(event);
   }else if(event is CleanData){
  yield* this._cleanData(); 
   }
  }

  Stream<CreatepublicationState> _updateName(event)async*{
    yield state.copyWith(name:event.name);
  }
  
  Stream<CreatepublicationState> _updateDesc(event)async*{
    yield state.copyWith(desc:event.desc);
  }
  Stream<CreatepublicationState> _updateCategory(event)async*{
    yield state.copyWith(category:event.category);
  }
  Stream<CreatepublicationState> _updateImgs(event)async*{
    yield state.copyWith(imgRef:event.imgRef);
  }
  Stream<CreatepublicationState> _updateLocations(event)async*{
    yield state.copyWith(locations:event.locations);
  }
  Stream<CreatepublicationState> _cleanData()async*{
    yield CreatepublicationState(name: '',desc:'',category: 'ADOPCIÓN', imgRef: [], locations: []);
  }
}
