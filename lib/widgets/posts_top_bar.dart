import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/models/post_model.dart';
import 'package:threads/routes/routes_name.dart';
import 'package:threads/utils/helper.dart';
import 'package:threads/utils/type_def.dart';

class PostsTopBar extends StatelessWidget {
  final PostModel post;
  final bool isAuthPost;
  final DeleteCallback? callback;
  const PostsTopBar({
    required this.post,
    this.isAuthPost = false,
    this.callback,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.toNamed(
            RoutesName.showProfile,
            arguments: post.userId,
          ),
          child: Text(
            post.user!.metadata!.name!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
            isAuthPost
                ? GestureDetector(
                    onTap: () {
                      confirmDialog("Are you sure?",
                          "Once it's deleted you can't recover it.", () {
                        callback!(post.id!);
                      });
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                : const Icon(Icons.more_horiz),
          ],
        )
      ],
    );
  }
}
