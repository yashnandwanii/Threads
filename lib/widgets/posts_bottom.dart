import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/controller/thread_controller.dart';
import 'package:threads/models/post_model.dart';
import 'package:threads/routes/routes_name.dart';
import 'package:threads/services/supabase_services.dart';

class PostCardBottombar extends StatefulWidget {
  final PostModel post;
  const PostCardBottombar({required this.post, super.key});

  @override
  State<PostCardBottombar> createState() => _PostCardBottombarState();
}

class _PostCardBottombarState extends State<PostCardBottombar> {
  final ThreadController controller = Get.find<ThreadController>();
  final SupabaseServices supabaseService = Get.find<SupabaseServices>();
  String likeStatus = "";

  void likeDislike(String status) async {
    setState(() {
      likeStatus = status;
    });
    if (likeStatus == "0") {
      widget.post.likes = [];
    }
    await controller.likeDislike(status, widget.post.id!, widget.post.userId!,
        supabaseService.currentUser.value!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            likeStatus == "1"
                ? IconButton(
                    onPressed: () {
                      likeDislike("0");
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red[700]!,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      likeDislike("1");
                    },
                    icon: const Icon(Icons.favorite_outline),
                  ),
            IconButton(
              onPressed: () {
                Get.toNamed(RoutesName.addreply, arguments: widget.post);
              },
              icon: const Icon(Icons.chat_bubble_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send_outlined),
            )
          ],
        ),
        Row(
          children: [
            Text("${widget.post.commentCount!} replies"),
            const SizedBox(
              width: 10,
            ),
            Text("${widget.post.likeCount} likes")
          ],
        )
      ],
    );
  }
}
