part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

final class ProductListLoading extends ProductListState {}

final class ProductListSuccess extends ProductListState {
  final List<ProductEntity> products;
  final int sort;
  final List<String> sortNames;

  const ProductListSuccess(this.products, this.sort, this.sortNames);
  @override
  List<Object> get props => [sort, products, sortNames];
}

final class ProductListError extends ProductListState {
  final AppException exception;

  const ProductListError(this.exception);
  @override
  List<Object> get props => [exception];
}

final class ProductListEmpty extends ProductListState {
  final String emptyMessage;

  const ProductListEmpty(this.emptyMessage);
  @override
  List<Object> get props => [emptyMessage];
}
