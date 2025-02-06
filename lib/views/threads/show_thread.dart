import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/controller/thread_controller.dart';
import 'package:threads/widgets/comment_card.dart';
import 'package:threads/widgets/post_card.dart';

class ShowThread extends StatefulWidget {
  const ShowThread({super.key});

  @override
  State<ShowThread> createState() => _ShowThreadState();
}

class _ShowThreadState extends State<ShowThread> {
  final int postId = Get.arguments;
  final ThreadController threadController = Get.put(ThreadController());

  @override
  void initState() {
    threadController.show(postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Thread"),
      ),
      body: Obx(() => threadController.showThreadLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  PostCard(post: threadController.post.value),
                  const SizedBox(
                    height: 20,
                  ),
                  // Comments
                  if (threadController.showThreadLoading.value)
                    const Center(child: CircularProgressIndicator())
                  else if (threadController.comments.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: threadController.comments.length,
                      itemBuilder: (context, index) {
                        return CommentCard(
                            comment: threadController.comments[index]!);
                      },
                    )
                  else
                    const Center(child: Text("No Comments found.")),
                ],
              ),
            )),
    );
  }
}
