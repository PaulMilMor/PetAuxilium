import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'createbusiness_event.dart';
part 'createbusiness_state.dart';

class CreatebusinessBloc extends Bloc<CreatebusinessEvent, CreatebusinessState> {
  CreatebusinessBloc() : super(CreatebusinessInitial());

  @override
  Stream<CreatebusinessState> mapEventToState(
    CreatebusinessEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
