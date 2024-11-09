import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/banner_repository.dart';
import 'package:nike/data/repo/product_repository.dart';
import 'package:nike/ui/home/bloc/home_bloc.dart';
import 'package:nike/ui/list/list.dart';
import 'package:nike/ui/product/product_item.dart';
import 'package:nike/ui/widgets/error.dart';

import 'package:nike/ui/widgets/slider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
            productRepository: productRepository,
            bannerRepository: bannerRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        // backgroundColor: Colors.blue.shade100,
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                return ListView.builder(
                    itemCount: 5,
                    physics: defaultScrollPhysics,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Column(
                            children: [
                              Container(
                                height: 56,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/img/nike_logo.png',
                                  height: 24,
                                ),
                              ),
                              Container(
                                height: 56,
                                margin:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    label: const Text('جستجو'),
                                    isCollapsed: false,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: IconButton(
                                          onPressed: () {
                                            _search(context);
                                          },
                                          icon: const Icon(
                                              CupertinoIcons.search)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(58),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(58),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .dividerColor
                                                .withOpacity(0.3))),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (value) {
                                    _search(context);
                                  },
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              )
                            ],
                          );
                        case 2:
                          return BannerSlider(
                            banners: state.banners,
                          );
                        case 3:
                          return _HorizontalProdcutList(
                            title: 'جدیدترین',
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ProductListScreen(
                                      sort: ProductSort.latest)));
                            },
                            products: state.latestProducts,
                          );

                        case 4:
                          return _HorizontalProdcutList(
                              title: 'پربازدیدترین',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductListScreen(
                                            sort: ProductSort.popular)));
                              },
                              products: state.popularProducts);

                        default:
                          return Container();
                      }
                    });
              } else if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HomeError) {
                return AppErrorWidget(
                  exception: state.exception,
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  },
                );
              } else {
                throw Exception('state is not supported...');
              }
            },
          ),
        ),
      ),
    );
  }

  void _search(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ProductListScreen.search(searchTerm: _searchController.text)));
  }
}

class _HorizontalProdcutList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;
  const _HorizontalProdcutList(
      {required this.title, required this.onTap, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TextButton(onPressed: onTap, child: const Text('مشاهده همه'))
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ListView.builder(
                itemCount: products.length,
                physics: defaultScrollPhysics,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductItem(
                    product: product,
                    borderRadius: BorderRadius.circular(12),
                  );
                }),
          ),
        )
      ],
    );
  }
}
