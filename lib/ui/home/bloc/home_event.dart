part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStarted extends HomeEvent {
  @override
  List<Object> get props => [];
}

class HomeRefresh extends HomeEvent {
  @override
  List<Object> get props => [];
}
