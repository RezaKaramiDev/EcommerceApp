import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/favorite_manager.dart';
import 'package:nike/data/product.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/product/details.dart';
import 'package:nike/ui/widgets/empty_state.dart';
import 'package:nike/ui/widgets/image.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست علاقه مندی ها'),
      ),
      body: ValueListenableBuilder<Box<ProductEntity>>(
        valueListenable: favoriteManager.listenable,
        builder: (context, box, child) {
          if (box.isEmpty) {
            return EmptyView(
                message:
                    'هنوز محصولی به لیست علاقه مندی های شما اضافه نشده است',
                image: SvgPicture.asset(
                  'assets/img/no_data.svg',
                  width: 200,
                ));
          } else {
            final products = box.values.toList();
            return ListView.builder(
                itemCount: products.length,
                padding: const EdgeInsets.only(top: 8, bottom: 100),
                itemBuilder: ((context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(product: product)));
                    },
                    onLongPress: () {
                      favoriteManager.delete(product);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          SizedBox(
                              height: 110,
                              width: 110,
                              child: ImageLoadingService(
                                imageUrl: product.imageUrl,
                                borderRadius: BorderRadius.circular(8),
                              )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontSize: 15,
                                          color: LightThemeColors
                                              .primaryTextColor),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  product.previousPrice.withPriceLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                Text(product.price.withPriceLabel)
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  );
                }));
          }
        },
      ),
    );
  }
}
