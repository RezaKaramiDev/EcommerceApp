import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/favorite_manager.dart';

import 'package:nike/data/product.dart';
import 'package:nike/ui/product/details.dart';

import 'package:nike/ui/widgets/image.dart';

class ProductItem extends StatefulWidget {
  final BorderRadius borderRadius;
  final ProductEntity product;
  final double itemWidth;
  final double itemHeight;
  const ProductItem(
      {super.key,
      required this.product,
      required this.borderRadius,
      this.itemWidth = 176,
      this.itemHeight = 189});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        borderRadius: widget.borderRadius,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                    product: widget.product,
                  )));
        },
        child: SizedBox(
          width: widget.itemWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 0.93,
                    child: ImageLoadingService(
                      imageUrl: widget.product.imageUrl,
                      borderRadius: widget.borderRadius,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        if (!favoriteManager.isFavorite(widget.product)) {
                          favoriteManager.addFavorite(widget.product);
                        } else {
                          favoriteManager.delete(widget.product);
                        }

                        setState(() {});
                      },
                      child: Container(
                          height: 32,
                          width: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: favoriteManager.isFavorite(widget.product)
                              ? const Icon(
                                  CupertinoIcons.heart_fill,
                                  size: 20,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  CupertinoIcons.heart,
                                  size: 20,
                                )),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  widget.product.previousPrice.withPriceLabel,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .apply(decoration: TextDecoration.lineThrough),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                child: Text(widget.product.price.withPriceLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
