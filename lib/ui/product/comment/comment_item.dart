import 'package:flutter/material.dart';
import 'package:nike/data/comment.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  const CommentItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: theme.dividerColor.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.title,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    comment.email,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
              Text(
                comment.date,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            comment.content,
            style: const TextStyle(height: 1.8),
          ),
        ],
      ),
    );
  }
}
