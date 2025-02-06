import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/models/post_model.dart';
import 'package:threads/routes/routes_name.dart';
import 'package:threads/utils/type_def.dart';
import 'package:threads/widgets/circle_image.dart';
import 'package:threads/widgets/post_card_image.dart';
import 'package:threads/widgets/posts_bottom.dart';
import 'package:threads/widgets/posts_top_bar.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool isAuthPost;
  final DeleteCallback? callback;
  const PostCard(
      {required this.post, this.isAuthPost = false, this.callback, super.key});

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
                      isAuthPost: isAuthPost,
                      callback: callback,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.toNamed(RoutesName.showThreads,
                              arguments: post.id);
                        },
                        child: Text(post.content!)),
                    SizedBox(
                      height: 10,
                    ),
                    if (post.image != null)
                      GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              RoutesName.showImage,
                              arguments: post.image!,
                            );
                          },
                          child: PostCardImage(url: post.image!)),
                    PostCardBottombar(post: post),
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
