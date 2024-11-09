import 'package:flutter/material.dart';
import 'package:nike/common/exceptions.dart';

class AppErrorWidget extends StatelessWidget {
  final AppException exception;
  final GestureTapCallback onPressed;
  const AppErrorWidget({
    super.key,
    required this.exception,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(exception.message),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('دوباره تلاش کنید'),
          )
        ],
      ),
    );
  }
}
