import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:nike/data/repo/cart_repository.dart';

import 'package:nike/ui/cart/cart.dart';
import 'package:nike/ui/home/home.dart';
import 'package:nike/ui/profile/profile_screen.dart';
import 'package:nike/ui/widgets/badge.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = homeIndex;
  final _history = <int>[];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey
  };

  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedScreenNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedScreenNavigatorState.canPop()) {
      currentSelectedScreenNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            onTap: (selectedIndex) {
              setState(() {
                _history.remove(selectedScreenIndex);
                _history.add(selectedScreenIndex);
                selectedScreenIndex = selectedIndex;
              });
            },
            currentIndex: selectedScreenIndex,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'خانه'),
              BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(CupertinoIcons.cart),
                      Positioned(
                          right: -10,
                          child: ValueListenableBuilder<int>(
                              valueListenable:
                                  CartRepository.cartItemCountNotifier,
                              builder: ((context, value, child) {
                                return CartBadge(value: value);
                              }))),
                    ],
                  ),
                  label: 'سبد خرید'),
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person), label: 'پروفایل'),
            ]),
        body: IndexedStack(
          index: selectedScreenIndex,
          children: [
            _navigator(_homeKey, homeIndex, HomeScreen()),
            _navigator(_cartKey, cartIndex, const CartScreen()),
            _navigator(
              _profileKey,
              profileIndex,
              const ProfileScreen(),
            )
          ],
        ),
      ),
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => Offstage(
                      offstage: selectedScreenIndex != index,
                      child: child,
                    )),
          );
  }

  @override
  void initState() {
    cartRepository.count();
    super.initState();
  }
}
