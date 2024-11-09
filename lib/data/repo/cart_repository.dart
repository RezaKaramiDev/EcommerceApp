import 'package:flutter/material.dart';
import 'package:nike/data/add_to_cart_response.dart';
import 'package:nike/data/cart_response.dart';
import 'package:nike/data/source/cart_data_source.dart';
import 'package:nike/common/http_client.dart';

final cartRepository = CartRepository(CartRemoteDataSource(httpClient));

abstract class ICartRepository extends ICartDataSource {}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static ValueNotifier<int> cartItemCountNotifier = ValueNotifier(0);

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) => dataSource.add(productId);

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) =>
      dataSource.changeCount(cartItemId, count);

  @override
  Future<int> count() async {
    final count = await dataSource.count();
    cartItemCountNotifier.value = count;
    return count;
  }

  @override
  Future<void> delete(int cartItemId) => dataSource.delete(cartItemId);

  @override
  Future<CartResponse> getAll() => dataSource.getAll();
}
