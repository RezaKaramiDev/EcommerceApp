import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository productRepository;
  ProductListBloc(this.productRepository) : super(ProductListLoading()) {
    on<ProductListEvent>((event, emit) async {
      if (event is ProductListStarted) {
        emit(ProductListLoading());
        try {
          final products = event.searchTerm.isEmpty
              ? await productRepository.getAll(event.sort)
              : await productRepository.search(event.searchTerm);
          if (products.isNotEmpty) {
            emit(ProductListSuccess(products, event.sort, ProductSort.name));
          } else {
            emit(const ProductListEmpty(
                'محصولی مشابه عبارت مورد جستجوی شما یافت نشد'));
          }
        } catch (e) {
          emit(ProductListError(AppException()));
        }
      }
    });
  }
}
