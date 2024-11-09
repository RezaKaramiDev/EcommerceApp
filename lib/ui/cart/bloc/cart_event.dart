part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefreshing;

  const CartStarted(this.authInfo, {this.isRefreshing = false});
  @override
  List<Object> get props => [authInfo!, isRefreshing];
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;
  const CartAuthInfoChanged(this.authInfo);
  @override
  List<Object> get props => [authInfo!];
}

class CartDeleteButtonClicked extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonClicked(this.cartItemId);
  @override
  List<Object> get props => [cartItemId];
}

class CartIncreaseCountButtonClicked extends CartEvent {
  final int cartItemId;
  const CartIncreaseCountButtonClicked(this.cartItemId);
  @override
  List<Object> get props => [cartItemId];
}

class CartDecreaseCountButtonClicked extends CartEvent {
  final int cartItemId;
  const CartDecreaseCountButtonClicked(this.cartItemId);
  @override
  List<Object> get props => [cartItemId];
}
