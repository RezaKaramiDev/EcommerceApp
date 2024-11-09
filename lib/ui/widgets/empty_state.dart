import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/ui/cart/bloc/cart_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class EmptyView extends StatelessWidget {
  final RefreshController _refreshController = RefreshController();
  final String message;
  final Widget? callToAction;
  final Widget image;

  EmptyView(
      {super.key,
      required this.message,
      this.callToAction,
      required this.image});
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      onRefresh: () {
        BlocProvider.of<CartBloc>(context).add(CartStarted(
            AuthRepository.authChangeNotifier.value,
            isRefreshing: true));
      },
      controller: _refreshController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
          Padding(
              padding: const EdgeInsets.fromLTRB(48, 24, 48, 16),
              child: Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(height: 1.4),
                textAlign: TextAlign.center,
              )),
          if (callToAction != null) callToAction!,
        ],
      ),
    );
  }
}
