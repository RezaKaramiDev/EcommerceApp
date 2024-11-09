import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/repo/comment_repository.dart';
import 'package:nike/ui/product/comment/insert/bloc/insert_comment_bloc.dart';

class InsertCommentDialog extends StatefulWidget {
  const InsertCommentDialog(
      {super.key, required this.productId, required this.scaffoldMessenger});
  final int productId;
  final ScaffoldMessengerState? scaffoldMessenger;

  @override
  State<InsertCommentDialog> createState() => _InsertCommentDialogState();
}

class _InsertCommentDialogState extends State<InsertCommentDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  StreamSubscription? subscription;
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InsertCommentBloc>(
      create: (context) {
        final bloc = InsertCommentBloc(commentRepository, widget.productId);

        subscription = bloc.stream.listen((state) {
          if (state is InsertCommentSuccess) {
            widget.scaffoldMessenger?.showSnackBar(const SnackBar(
              content: Text(
                  'نظر شما با موفقیت ثبت شد و بعد از تایید منتشر خواهد شد'),
            ));
          } else if (state is InsertCommentError) {
            widget.scaffoldMessenger?.showSnackBar(
                SnackBar(content: Text(state.exception.message)));
          }
        });
        return bloc;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<InsertCommentBloc, InsertCommentState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ثبت نظر',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(label: Text('عنوان')),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                        label: Text('متن نظر خود را وارد کنید')),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context.read<InsertCommentBloc>().add(
                            InsertCommentFormSubmit(_titleController.text,
                                _commentController.text));
                        Navigator.of(context).pop();
                      },
                      style: const ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4)))),
                          minimumSize: WidgetStatePropertyAll<Size?>(
                              Size.fromHeight(56))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state is InsertCommentLoading)
                            CupertinoActivityIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          const Text('ذخیره'),
                        ],
                      )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
