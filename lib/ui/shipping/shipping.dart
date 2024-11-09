import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/repo/order_repository.dart';
import 'package:nike/ui/cart/price_info.dart';
import 'package:nike/ui/payment_webview.dart';

import 'package:nike/ui/receipt/payment_receipt.dart';
import 'package:nike/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: "کوین");

  final TextEditingController lastNameController =
      TextEditingController(text: "فابیان");

  final TextEditingController mobileController =
      TextEditingController(text: "09129120912");

  final TextEditingController postalCodeController =
      TextEditingController(text: "1234567890");

  final TextEditingController addressController =
      TextEditingController(text: "sadsadsadasdasdasdasdasdasd");

  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
        centerTitle: false,
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((state) {
            if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            } else if (state is ShippingSuccess) {
              if (state.result.bankGatewayUrl.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentGatewayScreen(
                        bankGatewayUrl: state.result.bankGatewayUrl)));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentReceiptScreen(
                          orderId: state.result.orderId,
                        )));
              }
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(label: Text('نام ')),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(label: Text('نام خانوادگی')),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(label: Text('شماره تماس')),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: postalCodeController,
                decoration: const InputDecoration(label: Text('کد پستی')),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(label: Text('آدرس')),
              ),
              const SizedBox(
                height: 16,
              ),
              PriceInfo(
                  totalPrice: widget.totalPrice,
                  shippingCost: widget.shippingCost,
                  payablePrice: widget.payablePrice),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                      ShippingCreateOrder(CreateOrderParams(
                                          firstNameController.text,
                                          lastNameController.text,
                                          mobileController.text,
                                          postalCodeController.text,
                                          addressController.text,
                                          PaymentMethod.cashOnDelivery)));
                                },
                                child: const Text('پرداخت در محل')),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                      ShippingCreateOrder(CreateOrderParams(
                                          firstNameController.text,
                                          lastNameController.text,
                                          mobileController.text,
                                          postalCodeController.text,
                                          addressController.text,
                                          PaymentMethod.online)));
                                },
                                child: const Text('پرداخت اینترنتی'))
                          ],
                        );
                },
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
