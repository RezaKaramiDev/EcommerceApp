import 'package:dio/dio.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/payment_receipt_data.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> create(CreateOrderParams params);
  Future<PaymentReceiptData> getPaymentReceipt(int orderId);
  Future<List<OrderEntity>> getOrders();
}

class OrderRemoteDataSource implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async {
    final response = await httpClient.post('order/submit', data: {
      "first_name": params.firstName,
      "last_name": params.lastName,
      "postal_code": params.postalCode,
      "mobile": params.mobile,
      "address": params.address,
      "payment_method": params.paymentMethod == PaymentMethod.online
          ? "online"
          : "cash_on_delivery",
    });
    return CreateOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    return PaymentReceiptData.fromJson(response.data);
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    final response = await httpClient.get('order/list');
    return (response.data as List)
        .map((item) => OrderEntity.fromJson(item))
        .toList();
  }
}
