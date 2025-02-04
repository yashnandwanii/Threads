import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/models/post_model.dart';
import 'package:threads/routes/routes_name.dart';

class PostsBottom extends StatelessWidget {
  final PostModel post;
  const PostsBottom({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border),
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(RoutesName.addreply, arguments: post);
              },
              icon: const Icon(Icons.chat_bubble_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        Row(
          children: [
            Text("${post.likeCount} likes"),
            const SizedBox(
              width: 10,
            ),
            Text("${post.commentCount} comments"),
          ],
        ),
      ],
    );
  }
}
