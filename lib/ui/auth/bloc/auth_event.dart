part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthButtonIsClicked extends AuthEvent {
  final String username;
  final String password;

  const AuthButtonIsClicked(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class AuthModeChangeIsClicked extends AuthEvent {
  @override
  List<Object> get props => [];
}
