part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductAddToCartLoading extends ProductState {}

final class ProductAddToCartSuccess extends ProductState {}

final class ProductAddToCartError extends ProductState {
  final AppException exception;
  const ProductAddToCartError(this.exception);
  @override
  List<Object> get props => [exception];
}

// final class ProductAddToCartLoading extends ProductState {}

// final class ProductAddToCartSuccess extends ProductState {}

// final class ProductAddToCartError extends ProductState {
//   final AppException exception;

//   const ProductAddToCartError(this.exception);

//   @override
//   List<Object> get props => [exception];
// }
