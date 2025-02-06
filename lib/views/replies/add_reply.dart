import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/controller/reply_controller.dart';
import 'package:threads/models/post_model.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/utils/helper.dart';
import 'package:threads/widgets/circle_image.dart';
import 'package:threads/widgets/post_card_image.dart';

class AddReply extends StatefulWidget {
  const AddReply({super.key});

  @override
  State<AddReply> createState() => _AddReplyState();
}

class _AddReplyState extends State<AddReply> {
  final ReplyController replyController = Get.put(ReplyController());
  final PostModel post = Get.arguments;
  final SupabaseServices supabaseServices = Get.find<SupabaseServices>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.close)),
        title: Text("Add Reply"),
        actions: [
          Obx(
            () => TextButton(
              onPressed: () {
                if (replyController.reply.value.isNotEmpty &&
                    supabaseServices.currentUser.value != null) {
                  replyController.addReply(
                    supabaseServices.currentUser.value!.id, // Now it's safe
                    post.id!,
                    post.userId!,
                  );
                  Get.back();
                } else {
                  showSnackBar("Error", "Reply cannot be empty!");
                }
              },
              child: replyController.loading.value
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                      "Reply",
                      style: TextStyle(
                        fontWeight: replyController.reply.isNotEmpty
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.width * 0.12,
                  child: CircleImage(
                    imageUrl: post.user?.metadata?.image,
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
                      Text(
                        post.user?.metadata?.name ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(post.content ?? ""),
                      const SizedBox(
                        height: 10,
                      ),
                      if (post.image != null) PostCardImage(url: post.image!),

                      // Add a text field here
                      TextField(
                        autofocus: true,
                        controller: replyController.replyController,
                        decoration: const InputDecoration(
                          hintText: 'Add a reply',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          replyController.reply.value = value;
                        },
                        maxLength: 100,
                        minLines: 1,
                        maxLines: 10,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
