part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<ProductEntity> latestProducts;
  final List<ProductEntity> popularProducts;
  final List<BannerEntity> banners;

  const HomeSuccess(
      {required this.latestProducts,
      required this.popularProducts,
      required this.banners});
  @override
  List<Object> get props => [latestProducts, popularProducts, banners];
}

final class HomeError extends HomeState {
  final AppException exception;

  const HomeError({required this.exception});
  @override
  List<Object> get props => [exception];
}
