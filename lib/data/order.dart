import 'package:nike/data/product.dart';

class CreateOrderResult {
  final int orderId;
  final String bankGatewayUrl;

  CreateOrderResult(this.orderId, this.bankGatewayUrl);

  CreateOrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json["order_id"],
        bankGatewayUrl = json["bank_gateway_url"];
}

class CreateOrderParams {
  final String firstName;
  final String lastName;

  final String mobile;
  final String postalCode;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParams(this.firstName, this.lastName, this.mobile, this.postalCode,
      this.address, this.paymentMethod);
}

enum PaymentMethod { online, cashOnDelivery }

class OrderEntity {
  final int id;
  final int payable;
  final String paymentStatus;
  final String date;

  final List<ProductEntity> items;

  OrderEntity(
    this.id,
    this.payable,
    this.paymentStatus,
    this.date,
    this.items,
  );

  OrderEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        payable = json["payable"],
        paymentStatus = json["payment_status"],
        date = json["date"],
        items = (json["order_items"] as List)
            .map((items) => ProductEntity.fromJson(items["product"]))
            .toList();
}
