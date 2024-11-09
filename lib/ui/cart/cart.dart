import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/auth/auth.dart';
import 'package:nike/ui/cart/bloc/cart_bloc.dart';
import 'package:nike/ui/cart/cart_items_ui.dart';
import 'package:nike/ui/cart/price_info.dart';
import 'package:nike/ui/shipping/shipping.dart';

import 'package:nike/ui/widgets/empty_state.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  final RefreshController _refreshController = RefreshController();
  StreamSubscription? stateStreamSubscription;
  bool stateIsSuccess = false;

  @override
  void initState() {
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    super.initState();
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    stateStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('سبد خرید'),
      ),
      floatingActionButton: Visibility(
        visible: stateIsSuccess,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 48,
          child: FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              onPressed: () {
                final state = cartBloc!.state;
                if (state is CartSuccess) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShippingScreen(
                            payablePrice: state.cartResponse.payablePrice,
                            shippingCost: state.cartResponse.shippingCost,
                            totalPrice: state.cartResponse.totalPrice,
                          )));
                }
              },
              label: Text(
                'پرداخت',
                style: Theme.of(context).textTheme.titleMedium,
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocProvider<CartBloc>(
        create: (context) {
          final bloc = CartBloc(cartRepository, authRepository);
          cartBloc = bloc;
          stateStreamSubscription = bloc.stream.listen((state) {
            setState(() {
              stateIsSuccess = state is CartSuccess;
            });
            if (_refreshController.isRefresh) {
              if (state is CartSuccess) {
                _refreshController.refreshCompleted();
              }
              if (state is CartError) {
                _refreshController.refreshFailed();
              }
            }
          });

          bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
          return bloc;
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is CartSuccess) {
              return SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  cartBloc?.add(CartStarted(
                      AuthRepository.authChangeNotifier.value,
                      isRefreshing: true));
                },
                child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 60),
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.cartResponse.cartItems.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.cartResponse.cartItems.length) {
                        final data = state.cartResponse.cartItems[index];
                        return CartItem(
                          data: data,
                          onDeleteButtonClick: () {
                            cartBloc?.add(CartDeleteButtonClicked(data.id));
                          },
                          onIncreaseCountButtonClick: () {
                            if (data.count < 5) {
                              cartBloc?.add(
                                  CartIncreaseCountButtonClicked(data.id));
                            }
                          },
                          onDecreaseCountButtonClick: () {
                            if (data.count > 1) {
                              cartBloc?.add(
                                  CartDecreaseCountButtonClicked(data.id));
                            }
                          },
                        );
                      } else {
                        final fee = state.cartResponse;
                        return PriceInfo(
                          totalPrice: fee.totalPrice,
                          shippingCost: fee.shippingCost,
                          payablePrice: fee.payablePrice,
                        );
                      }
                    }),
              );
            } else if (state is CartAuthRequired) {
              return EmptyView(
                message: 'لطفا برای مشاهده سبد خرید وارد حساب کاربری خود شوید',
                image: SvgPicture.asset(
                  'assets/img/auth_required.svg',
                  width: 140,
                ),
                callToAction: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => const AuthScreen()));
                  },
                  child: const Text('ورود به حساب کاربری'),
                ),
              );
            } else if (state is CartEmpty) {
              return EmptyView(
                  message:
                      'تا کنون هیج محصولی را به سبد خرید خود اضافه نکرده اید',
                  image: SvgPicture.asset('assets/img/empty_cart.svg',
                      width: 200));
            } else {
              throw Exception('state is not valid');
            }
          },
        ),
      ),

      // ValueListenableBuilder<AuthInfo?>(
      //   valueListenable: AuthRepository.authChangeNotifier,
      //   builder: (context, authState, child) {
      //     bool isAuthenticated =
      //         authState != null && authState.accessToken.isNotEmpty;
      //     return SizedBox(
      //         width: MediaQuery.of(context).size.width,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Text(isAuthenticated
      //                 ? 'خوش آمدید'
      //                 : 'لطفا وارد حساب کاربری خود شوید'),
      //             isAuthenticated
      //                 ? ElevatedButton(
      //                     onPressed: () {
      //                       authRepository.sighOut();
      //                     },
      //                     child: Text('خروج از حساب کاربری'))
      //                 : ElevatedButton(
      //                     onPressed: () {
      //                       Navigator.of(context, rootNavigator: true).push(
      //                           MaterialPageRoute(
      //                               builder: (context) => const AuthScreen()));
      //                     },
      //                     child: Text('ورود'))
      //           ],
      //         ));
      //   },
      // ),
    );
  }
}
