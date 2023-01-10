part of 'dog_bloc.dart';

@immutable
abstract class DogEvent extends Equatable {}

class DogsFetch extends DogEvent {

  @override
  List<Object?> get props => [];
}

class DogsSave extends DogEvent {
  final Dog dog;
  final VoidCallback onFinished;

  DogsSave(this.dog, this.onFinished);

  @override
  List<Object?> get props => [dog, onFinished];
}

class DogsEdit extends DogEvent {
  final Dog dog;
  final VoidCallback onFinished;

  DogsEdit(this.dog, this.onFinished);

  @override
  List<Object?> get props => [dog, onFinished];
}


class DogsReload extends DogEvent {
  final VoidCallback? onFinished;

  DogsReload({this.onFinished});

  @override
  List<Object?> get props => [onFinished];
}

class DogsDelete extends DogEvent{
  final String dogId;
  final VoidCallback onFinished;
  DogsDelete(this.onFinished,this.dogId);

  @override
  List<Object?> get props => [onFinished,dogId];
}
