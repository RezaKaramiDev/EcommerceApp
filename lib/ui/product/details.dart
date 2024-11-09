import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/favorite_manager.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/product/bloc/product_bloc.dart';
import 'package:nike/ui/product/comment/comment_list.dart';
import 'package:nike/ui/product/comment/insert/insert_comment_dialog.dart';
import 'package:nike/ui/widgets/image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductEntity product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('یا موفقیت به سبد خرید افزوده شد')));
            } else if (state is ProductAddToCartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return FloatingActionButton.extended(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context)
                            .add(CartAddButtonClick(widget.product.id));
                      },
                      label: state is ProductAddToCartLoading
                          ? CupertinoActivityIndicator(
                              color: Theme.of(context).colorScheme.onSecondary)
                          : Text(
                              'افزودن به سبد خرید',
                              style: Theme.of(context).textTheme.titleMedium,
                            ));
                },
              ),
            ),
            body: CustomScrollView(
              physics: defaultScrollPhysics,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.7,
                  flexibleSpace: ImageLoadingService(
                    imageUrl: widget.product.imageUrl,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          if (!favoriteManager.isFavorite(widget.product)) {
                            favoriteManager.addFavorite(widget.product);
                          } else {
                            favoriteManager.delete(widget.product);
                          }

                          setState(() {});
                        },
                        icon: favoriteManager.isFavorite(widget.product)
                            ? const Icon(
                                CupertinoIcons.heart_fill,
                                size: 20,
                                color: Colors.red,
                              )
                            : const Icon(
                                CupertinoIcons.heart,
                                size: 20,
                              )),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.title,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.product.previousPrice.withPriceLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                Text(widget.product.price.withPriceLabel)
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                            'این کتانی شدیدا برای دویدن و راه رفتن مناسب است و تقریبا نمی گذارد که هیچ فشار مخربی به پا و یا زانوان شما انتقال داده شود'),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نظرات کاربران',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      useRootNavigator: true,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: InsertCommentDialog(
                                            productId: widget.product.id,
                                            scaffoldMessenger:
                                                _scaffoldKey.currentState,
                                          ),
                                        );
                                      });
                                },
                                child: const Text('ثبت نظر'))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.product.id)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
