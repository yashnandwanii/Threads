import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/utils/helper.dart';

class ReplyController extends GetxController {
  var loading = false.obs;
  final TextEditingController replyController = TextEditingController(text: "");
  var reply = "".obs;

  void addReply(String userId, int postId, String postUserId) async {
    try {
      loading.value = true;

      //* Increase the post comment count
      await SupabaseServices.client.rpc(
        "comment_increment",
        params: {
          "count": 1,
          "row_id": postId,
        },
      );

      // Add a notification
      await SupabaseServices.client.from("notifications").insert({
        "user_id": userId,
        "notification": "Commented on your post",
        "to_user_id": postUserId,
        "post_id": postId,
      });

      // * add comment in table
      if (reply.value.trim().isEmpty) {
        showSnackBar("Error", "Reply cannot be empty!");
        return;
      }

      await SupabaseServices.client.from("comments").insert(
          {"posts_id": postId, "user_id": userId, "reply": reply.value.trim()});

      loading.value = false;
      showSnackBar(
        "Success",
        "Comment added successfully",
      );
    } catch (e) {
      loading.value = false;
      showSnackBar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    replyController.dispose();
    reply.value = "";

    super.onClose();
  }
}
