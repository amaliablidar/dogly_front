part of 'dog_bloc.dart';

@immutable
abstract class DogState extends Equatable {}

class DogsLoaded extends DogState {
  final List<Dog> dogs;
  final bool isLoading;

  DogsLoaded({required this.dogs, required this.isLoading});

  DogsLoaded copyWith({List<Dog>? dogs, bool? isLoading}) => DogsLoaded(
      dogs: dogs ?? this.dogs, isLoading: isLoading ?? this.isLoading);

  @override
  List<Object?> get props => [dogs, isLoading];
}
