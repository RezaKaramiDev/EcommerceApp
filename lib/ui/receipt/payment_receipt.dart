import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/repo/order_repository.dart';

import 'package:nike/theme.dart';
import 'package:nike/ui/receipt/bloc/payment_receipt_bloc.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;
  const PaymentReceiptScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('رسید پرداخت'),
          centerTitle: true,
        ),
        body: BlocProvider<PaymentReceiptBloc>(
          create: (context) {
            final bloc = PaymentReceiptBloc(orderRepository);
            bloc.add(PaymentReceiptStarted(orderId));
            return bloc;
          },
          child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
            builder: (context, state) {
              if (state is PaymentReceiptSuccess) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: themeData.dividerColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            state.paymentReceiptData.purchaseSuccess
                                ? 'پرداخت با موفقیت انجام شد'
                                : 'پرداخت ناموفق',
                            style: themeData.textTheme.headlineSmall!
                                .apply(color: LightThemeColors.primaryColor),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'وضعیت سفارش',
                                style: TextStyle(
                                    color: LightThemeColors.secondaryTextColor),
                              ),
                              Text(
                                state.paymentReceiptData.paymentStatus,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          const Divider(
                            height: 32,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'مبلغ',
                                style: TextStyle(
                                    color: LightThemeColors.secondaryTextColor),
                              ),
                              Text(
                                state.paymentReceiptData.payablePrice
                                    .withPriceLabel,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: const Text('بازکشت به صفحه اصلی'))
                  ],
                );
              } else if (state is PaymentReceiptLoading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else if (state is PaymentReceiptError) {
                return Center(
                  child: Text(state.exception.message),
                );
              } else {
                throw Exception('state is not supported');
              }
            },
          ),
        ));
  }
}
