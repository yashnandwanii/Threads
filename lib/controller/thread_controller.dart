import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
