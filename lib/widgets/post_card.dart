import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/models/post_model.dart';
import 'package:threads/widgets/circle_image.dart';
import 'package:threads/widgets/post_card_image.dart';
import 'package:threads/widgets/posts_bottom.dart';
import 'package:threads/widgets/posts_top_bar.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: context.width * 0.12,
                child: CircleImage(
                  imageUrl: post.user!.metadata!.image,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: context.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostsTopBar(
                      post: post,
                    ),
                    Text(post.content!),
                    SizedBox(
                      height: 10,
                    ),
                    if (post.image != null) PostCardImage(url: post.image!),
                    PostsBottom(post: post),
                  ],
                ),
              )
            ],
          ),
          const Divider(
            color: Color(0xff242424),
          )
        ],
      ),
    );
  }
}
