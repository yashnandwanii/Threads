import 'package:get/get.dart';
import 'package:threads/services/storage_services.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/utils/storage_keys.dart';

class SettingsController extends GetxController {
  void logout() async {
    StorageServices.session.remove(StorageKeys.userSession);
    await SupabaseServices.client.auth.signOut();
    Get.offAllNamed('/login');
  }
}
