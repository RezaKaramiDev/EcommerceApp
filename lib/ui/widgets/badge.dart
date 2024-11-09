import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  final int value;
  const CartBadge({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: value > 0,
      child: Container(
        width: 18,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 1.5,
          ),
          child: Text(
            value.toString(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
