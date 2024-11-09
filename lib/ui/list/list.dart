import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/data/repo/product_repository.dart';
import 'package:nike/ui/cart/cart.dart';
import 'package:nike/ui/list/bloc/product_list_bloc.dart';
import 'package:nike/ui/product/product_item.dart';
import 'package:nike/ui/widgets/badge.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;
  final String searchTerm;
  const ProductListScreen(
      {super.key, required this.sort, this.searchTerm = ''});
  const ProductListScreen.search(
      {super.key, required this.searchTerm, this.sort = ProductSort.popular});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType {
  list,
  grid,
}

class _ProductListScreenState extends State<ProductListScreen> {
  ViewType viewType = ViewType.grid;
  ProductListBloc? bloc;
  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.searchTerm.isEmpty
              ? const Text('کفش های ورزشی')
              : Text('نتایج جستجو برای عبارت: ${widget.searchTerm}'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CartScreen()));
                      },
                      icon: const Icon(CupertinoIcons.bag)),
                  Positioned(
                      right: 4,
                      bottom: 16,
                      child: ValueListenableBuilder<int>(
                          valueListenable: CartRepository.cartItemCountNotifier,
                          builder: ((context, value, child) {
                            return CartBadge(value: value);
                          }))),
                ],
              ),
            )
          ],
        ),
        body: BlocProvider<ProductListBloc>(
          create: (context) {
            bloc = ProductListBloc(productRepository)
              ..add(ProductListStarted(widget.sort, widget.searchTerm));
            return bloc!;
          },
          child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
            if (state is ProductListSuccess) {
              final products = state.products;
              return Column(
                children: [
                  if (widget.searchTerm.isEmpty)
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: Border(
                              top: BorderSide(
                                  width: 1,
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.3))),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                            )
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 300,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 24, bottom: 24),
                                              child: Text(
                                                'انتخاب مرتب سازی',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount:
                                                      state.sortNames.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final selectedSortIndex =
                                                        state.sort;
                                                    return InkWell(
                                                      onTap: () {
                                                        bloc!.add(
                                                            ProductListStarted(
                                                                index,
                                                                widget
                                                                    .searchTerm));
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                16, 8, 16, 8),
                                                        child: SizedBox(
                                                          height: 32,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                state.sortNames[
                                                                    index],
                                                                style: index ==
                                                                        selectedSortIndex
                                                                    ? TextStyle(
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold)
                                                                    : const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w100),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            CupertinoIcons.sort_down)),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('مرتب سازی'),
                                        Text(
                                          ProductSort.name[state.sort],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.3),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    viewType = viewType == ViewType.grid
                                        ? ViewType.list
                                        : ViewType.grid;
                                  });
                                },
                                icon: viewType == ViewType.grid
                                    ? const Icon(
                                        CupertinoIcons.rectangle_grid_1x2)
                                    : const Icon(
                                        CupertinoIcons.square_grid_2x2)),
                          )
                        ],
                      ),
                    ),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: viewType == ViewType.grid ? 2 : 1,
                            childAspectRatio: 0.65),
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = products[index];
                          return ProductItem(
                              product: product,
                              borderRadius: BorderRadius.zero);
                        }),
                  ),
                ],
              );
            } else if (state is ProductListLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is ProductListError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is ProductListEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/img/no_data.svg',
                      width: 200,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(state.emptyMessage),
                  ],
                ),
              );
            } else {
              throw Exception(' state is not supported ');
            }
          }),
        ));
  }
}
