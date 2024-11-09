import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/product.dart';
import 'package:nike/ui/widgets/image.dart';

class OrderHistoryDetails extends StatelessWidget {
  final List<ProductEntity> items;
  final OrderEntity orders;

  const OrderHistoryDetails({
    super.key,
    required this.items,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جزییات سوابق خرید'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];

          return Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                SizedBox(
                  width: 134,
                  child: ImageLoadingService(
                    borderRadius: BorderRadius.circular(8),
                    imageUrl: item.imageUrl,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(item.price.withPriceLabel),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
