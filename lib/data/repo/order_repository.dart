import 'package:nike/common/http_client.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/payment_receipt_data.dart';

import 'package:nike/data/source/order_data_source.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) =>
      dataSource.create(params);

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) =>
      dataSource.getPaymentReceipt(orderId);

  @override
  Future<List<OrderEntity>> getOrders() => dataSource.getOrders();
}
