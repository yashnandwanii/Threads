import 'package:flutter/material.dart';
import 'package:threads/models/post_model.dart';
import 'package:threads/utils/helper.dart';

class PostsTopBar extends StatelessWidget {
  final PostModel post;
  PostsTopBar({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          post.user!.metadata!.name!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        Row(
          children: [
            Text(formateDateFromNow(post.createdAt!)),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.more_horiz,
            ),
          ],
        )
      ],
    );
  }
}
