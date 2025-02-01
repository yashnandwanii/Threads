import 'dart:io';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/utils/dotenv.dart';
import 'package:threads/utils/helper.dart';

class ProfileController extends GetxController {
  var loading = false.obs;
  Rx<File?> image = Rx<File?>(null);

  // update profile
  Future<void> updateProfile(
    String userId,
    String desciption,
  ) async {
    try {
      loading.value = true;
      var uploadedPath = "";
      if (image.value != null && image.value!.existsSync()) {
        final String dir = '$userId/profile.jpg';
        final path =
            await SupabaseServices.client.storage.from(Env.s3Bucket).upload(
                  dir,
                  image.value!,
                  fileOptions: FileOptions(
                    upsert: true,
                  ),
                );
        uploadedPath = path;
      }

      // update user profile
      await SupabaseServices.client.auth.updateUser(UserAttributes(
        data: {
          "description": desciption,
          "image": uploadedPath.isNotEmpty ? uploadedPath : null,
        },
      ));

      loading.value = false;
      Get.back();
      showSnackBar("Profile updated successfully.", 'Success');
    } on StorageException catch (e) {
      loading.value = false;
      showSnackBar(e.message, 'Error');
    } on AuthException catch (e) {
      loading.value = false;
      showSnackBar(e.message, 'Error');
    } catch (e) {
      loading.value = false;
      showSnackBar("Something went wrong.", 'Error');
    }
  }

  // pick image
  void pickImage() async {
    loading.value = true;
    File? img = await pickImageFormGallery();
    if (img != null) {
      image.value = img;
    }
    loading.value = false;
  }
}
