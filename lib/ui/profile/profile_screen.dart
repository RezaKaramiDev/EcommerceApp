import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/data/auth_info.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/auth/auth.dart';
import 'package:nike/ui/favorite/favorite_screen.dart';
import 'package:nike/ui/order/order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'پروفایل',
          style:
              Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<AuthInfo?>(
          valueListenable: AuthRepository.authChangeNotifier,
          builder: (context, authInfo, child) {
            final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 80,
                        width: 80,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.3),
                                width: 1)),
                        child: Image.asset(
                          'assets/img/nike_logo.png',
                          width: 65,
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(isLogin ? authInfo.email : 'کاربر میهمان'),
                    const SizedBox(
                      height: 12,
                    ),
                    Divider(
                      height: 0,
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const FavoriteListScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 24, right: 16, bottom: 24),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.heart,
                              size: 28,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              'لیست علاقه مندی ها',
                              style: Theme.of(context).textTheme.headlineSmall,
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const OrderHistoryScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 24, right: 16, bottom: 24),
                        child: Row(
                          children: [
                            Transform.flip(
                              flipX: true,
                              child: const Icon(
                                CupertinoIcons.cart,
                                size: 28,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              'سوابق سفارش',
                              style: Theme.of(context).textTheme.headlineSmall,
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                    ),
                    InkWell(
                      onTap: () {
                        if (isLogin) {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title: const Text('خروج از حساب کاربری'),
                                    content: const Text(
                                        'آیا می خواهید از حساب خود خارج شوید؟'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('خیر')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            CartRepository.cartItemCountNotifier
                                                .value = 0;
                                            authRepository.sighOut();
                                          },
                                          child: const Text('بله')),
                                    ],
                                  ),
                                );
                              }));
                        } else {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 24, right: 16, bottom: 24),
                        child: Row(
                          children: [
                            Icon(
                              isLogin ? Icons.logout : Icons.login,
                              size: 28,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              isLogin
                                  ? 'خروج از حساب کاربری'
                                  : 'ورود به حساب کاربری',
                              style: Theme.of(context).textTheme.headlineSmall,
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
