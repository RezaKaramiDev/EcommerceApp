import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/theme.dart';

class PriceInfo extends StatelessWidget {
  final int totalPrice;
  final int shippingCost;
  final int payablePrice;

  const PriceInfo(
      {super.key,
      required this.totalPrice,
      required this.shippingCost,
      required this.payablePrice});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, right: 12),
          child: Text(
            'جزییات خرید',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(4, 8, 4, 32),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                )
              ]),
          child: Column(
            children: [
              PriceRow(
                text: 'کل مبلغ خرید',
                richText: RichText(
                    text: TextSpan(
                        text: totalPrice.separateByComma,
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(color: LightThemeColors.secondaryTextColor),
                        children: const [
                      TextSpan(text: ' تومان', style: TextStyle(fontSize: 10))
                    ])),
              ),
              Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('هزینه ارسال'),
                    Text(shippingCost.withPriceLabel),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              PriceRow(
                text: 'مبلغ قابل پرداخت',
                richText: RichText(
                    text: TextSpan(
                        text: payablePrice.separateByComma,
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontWeight: FontWeight.bold),
                        children: const [
                      TextSpan(
                          text: ' تومان',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.normal))
                    ])),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PriceRow extends StatelessWidget {
  const PriceRow({
    super.key,
    required this.text,
    required this.richText,
  });

  final String text;
  final RichText richText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(text), richText],
      ),
    );
  }
}
