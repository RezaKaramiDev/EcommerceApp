import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/cart_item.dart';
import 'package:nike/ui/widgets/image.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.data,
    required this.onDeleteButtonClick,
    required this.onIncreaseCountButtonClick,
    required this.onDecreaseCountButtonClick,
  });

  final CartItemEntity data;
  final GestureTapCallback onDeleteButtonClick;
  final GestureTapCallback onIncreaseCountButtonClick;
  final GestureTapCallback onDecreaseCountButtonClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      margin: const EdgeInsets.all(4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                    width: 100,
                    height: 100,
                    child: ImageLoadingService(
                      imageUrl: data.product.imageUrl,
                      borderRadius: BorderRadius.circular(4),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(data.product.title),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('تعداد'),
                    Row(
                      children: [
                        IconButton(
                            onPressed: onIncreaseCountButtonClick,
                            icon: const Icon(CupertinoIcons.plus_rectangle)),
                        data.changeCountLoading
                            ? CupertinoActivityIndicator(
                                color:
                                    Theme.of(context).colorScheme.onBackground)
                            : Text(data.count.toString()),
                        IconButton(
                          onPressed: onDecreaseCountButtonClick,
                          icon: const Icon(CupertinoIcons.minus_rectangle),
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.product.previousPrice.withPriceLabel,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(decoration: TextDecoration.lineThrough),
                    ),
                    Text(data.product.price.withPriceLabel)
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),
          data.deleteButtonLoading
              ? const SizedBox(
                  height: 48,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : TextButton(
                  onPressed: onDeleteButtonClick,
                  child: const Text('حذف از سبد خرید'))
        ],
      ),
    );
  }
}
