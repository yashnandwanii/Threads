import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threads/routes/routes_name.dart';
import 'package:threads/services/storage_services.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/utils/helper.dart';
import 'package:threads/utils/storage_keys.dart';

class AuthController extends GetxController {
  var registerloading = false.obs;
  var loginloading = false.obs;
  Future<void> register(String name, String email, String password) async {
    try {
      registerloading.value = true;
      final AuthResponse data = await SupabaseServices.client.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );
      registerloading.value = false;
      if (data.user != null) {
        StorageServices.session
            .write(StorageKeys.userSession, data.session!.toJson());
        Get.offAllNamed(RoutesName.home);
        showSnackBar('Success', 'Register success');
      }
    } on AuthException catch (e) {
      registerloading.value = false;
      showSnackBar('Error', e.message);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      loginloading.value = true;
      final AuthResponse data =
          await SupabaseServices.client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      loginloading.value = false;
      if (data.user != null) {
        StorageServices.session
            .write(StorageKeys.userSession, data.session!.toJson());
        Get.offAllNamed(RoutesName.home);
        showSnackBar('Success', 'Login success');
      }
    } on AuthException catch (e) {
      loginloading.value = false;
      showSnackBar('Error', e.message);
    }
  }
}
