import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../profile/models/user_notifier.dart';
import '../../services/services.dart';
import '../models/dog.dart';

part 'dog_event.dart';
part 'dog_state.dart';

class DogBloc extends Bloc<DogEvent, DogState> {
  DogBloc(String token) : super(DogsLoaded(dogs: const [], isLoading: true)) {
    on<DogsFetch>(_onDogsFetch);
    on<DogsReload>(_onDogsReload);
    on<DogsSave>(_onDogsSave);
    on<DogsDelete>(_onDogsDelete);
    on<DogsEdit>(_onDogsEdit);
    add(DogsFetch());
  }

  Future<void> _onDogsFetch(DogsFetch event, Emitter<DogState> emit) async {
    final s = state;
    if(s is DogsLoaded) {
      emit(s.copyWith(isLoading: true));
      String? username = "";
      var instance = await SharedPreferences.getInstance();
      username = instance.getString("username");
      List<Dog> dogs = await Services.getDogs(username??'');
      emit(s.copyWith(dogs: dogs, isLoading: false));
    }
  }

  Future<void> _onDogsReload(DogsReload event, Emitter<DogState> emit) async {
    final s = state;
    if(s is DogsLoaded) {
      emit(s.copyWith(isLoading: true));
      String? username = "";
      var instance = await SharedPreferences.getInstance();
      username = instance.getString("username");
      List<Dog> dogs = await Services.getDogs(username??'');
      emit(s.copyWith(dogs: dogs, isLoading: false));
      event.onFinished?.call();
    }
  }

  Future<void> _onDogsSave(DogsSave event, Emitter<DogState> emit) async {
    final s = state;
    if(s is DogsLoaded) {
      emit(s.copyWith(isLoading: true));
      print(event.dog);
      await Services.saveDog(event.dog);
      add(DogsReload(onFinished: event.onFinished));
    }
  }

  Future<void> _onDogsEdit(DogsEdit event, Emitter<DogState> emit) async {
    try {
      final s = state;
      if (s is DogsLoaded) {
        emit(s.copyWith(isLoading: true));
        print(event.dog);
        await Services.editDog(event.dog);
        add(DogsReload(onFinished: event.onFinished));
      }
    }
    catch(e){
      print(e);
    }
  }

  Future<void> _onDogsDelete(DogsDelete event, Emitter<DogState> emit) async {
    final s = state;
    if(s is DogsLoaded) {
      emit(s.copyWith(isLoading: true));
      await Services.deleteDog(event.dogId);
      add(DogsReload(onFinished: event.onFinished));
    }
  }
}
