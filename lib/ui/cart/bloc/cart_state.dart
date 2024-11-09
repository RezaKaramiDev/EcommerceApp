part of 'cart_bloc.dart';

sealed class CartState {
  const CartState();
}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  final CartResponse cartResponse;

  const CartSuccess(this.cartResponse);
}

final class CartError extends CartState {
  final AppException exception;
  const CartError(this.exception);
}

final class CartAuthRequired extends CartState {}

final class CartEmpty extends CartState {}
