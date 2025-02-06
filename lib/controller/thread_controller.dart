import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threads/models/comment_model.dart';
import 'package:threads/models/post_model.dart';
import 'package:threads/services/navigation_services.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/utils/dotenv.dart';
import 'package:threads/utils/helper.dart';
import 'package:uuid/uuid.dart';

class ThreadController extends GetxController {
  final TextEditingController textEditingController =
      TextEditingController(text: "");
  var loading = false.obs;
  var content = "".obs;
  Rx<File?> image = Rx<File?>(null);
  var showThreadLoading = false.obs;
  Rx<PostModel> post = Rx<PostModel>(PostModel());
  var commentLoading = false.obs;
  RxList<CommentModel?> comments = RxList<CommentModel?>();

  void pickImage() async {
    File? file = await pickImageFormGallery();
    if (file != null) {
      image.value = file;
    }
  }

  void storePost(String userId) async {
    try {
      loading(true);
      final uuid = Uuid();
      final dir = "$userId/${uuid.v4()}";
      var imgPath = "";
      if (image.value != null && image.value!.existsSync()) {
        imgPath = await SupabaseServices.client.storage
            .from(Env.s3Bucket)
            .upload(dir, image.value!);
      }
      // add to database
      await SupabaseServices.client.from("posts").insert({
        "user_id": userId,
        "content": content.value,
        "image": imgPath.isNotEmpty ? imgPath : null,
      });

      loading(false);
      resetThreadState();
      Get.find<NavigationServices>().currIndex.value = 0;
      showSnackBar("Success", "Thread added successfully.");
    } on StorageException catch (e) {
      loading.value = false;
      showSnackBar("Error", e.message);
    } catch (e) {
      loading.value = false;
      showSnackBar("Error", "Something went wrong.");
    }
  }

  // to show post/thread.
  void show(int postId) async {
    try {
      post.value = PostModel();
      comments.clear();

      showThreadLoading.value = true;
      final response = await SupabaseServices.client.from("posts").select('''
        id ,content , image ,created_at ,comment_count, like_count,user_id,
        user:user_id (email , metadata) , likes : likes(user_id, post_id)
        ''').eq('id', postId).single();
      post.value = PostModel.fromJson(response);

      showThreadLoading.value = false;
    } catch (e) {
      showThreadLoading.value = false;
      showSnackBar("Something went wrong", "Please try again.");
    }
  }

  // * Post comments
  Future<void> postComments(int postId) async {
    try {
      commentLoading.value = true;
      final List<dynamic> data =
          await SupabaseServices.client.from("comments").select('''
    id ,reply ,created_at ,user_id,
    user:user_id (email , metadata)
''').eq("post_id", postId);

      if (data.isNotEmpty) {
        comments.value = [for (var item in data) CommentModel.fromJson(item)];
      }
      commentLoading.value = false;
    } catch (e) {
      commentLoading.value = false;
      showSnackBar("Error", "Somethign went wrong!");
    }
  }

  // * Like and dislike the post
  Future<void> likeDislike(
      String status, int postId, String postUserId, String userId) async {
    if (status == "1") {
      await SupabaseServices.client
          .from("likes")
          .insert({"user_id": userId, "post_id": postId});

      // * Add Comment notification
      await SupabaseServices.client.from("notifications").insert({
        "user_id": userId,
        "notification": "liked on your post.",
        "to_user_id": postUserId,
        "post_id": postId,
      });

      // * Increment like counter in post table
      await SupabaseServices.client
          .rpc("like_increment", params: {"count": 1, "row_id": postId});
    } else if (status == "0") {
      await SupabaseServices.client
          .from("likes")
          .delete()
          .match({"user_id": userId, "post_id": postId});

      // * Decrement like counter in post table
      await SupabaseServices.client
          .rpc("like_decrement", params: {"count": 1, "row_id": postId});
    }
  }

  // to reset the thread state.
  void resetThreadState() {
    content.value = "";
    image.value = null;
    textEditingController.clear();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }
}
