import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'editpublication_event.dart';
part 'editpublication_state.dart';

class EditpublicationBloc extends Bloc<EditpublicationEvent, EditpublicationState> {
  EditpublicationBloc() : super(EditpublicationState());
  
  @override
  Stream<EditpublicationState> mapEventToState(
    EditpublicationEvent event,
  ) async* {
   if(event is UpdateName){
  yield* this._updateName(event);
   }else if(event is UpdateDesc){
  yield* this._updateDesc(event);
   }else if(event is UpdateCategory){
  yield* this._updateCategory(event);
   }else if(event is EditUpdateLocations){
  yield* this._updateLocations(event);   
   }else if(event is UpdateImgs){
  yield* this._updateImgs(event);
   }else if(event is CleanData){
  yield* this._cleanData(); 
   }
  }

  Stream<EditpublicationState> _updateName(event)async*{
    yield state.copyWith(name:event.name);
  }
  
  Stream<EditpublicationState> _updateDesc(event)async*{
    yield state.copyWith(desc:event.desc);
  }
  Stream<EditpublicationState> _updateCategory(event)async*{
    yield state.copyWith(category:event.category);
  }
  Stream<EditpublicationState> _updateImgs(event)async*{
    yield state.copyWith(imgRef:event.imgRef);

  }
  Stream<EditpublicationState> _updateLocations(event)async*{
    yield state.copyWith(locations:event.locations);
  }
  Stream<EditpublicationState> _cleanData()async*{
    yield EditpublicationState(name: '',desc:'',category: 'ADOPCIÓN', imgRef: ["Add Image"], locations:Set<Marker>());
  }
}
