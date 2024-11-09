part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  final bool isLoginMode;
  const AuthState(this.isLoginMode);
  @override
  List<Object> get props => [isLoginMode];
}

final class AuthInitial extends AuthState {
  const AuthInitial(super.isLoginMode);
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  const AuthLoading(super.isLoginMode);
  @override
  List<Object> get props => [];
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(super.isLoginMode);
  @override
  List<Object> get props => [];
}

final class AuthError extends AuthState {
  final AppException exception;
  const AuthError(super.isLoginMode, this.exception);
  @override
  List<Object> get props => [];
}
