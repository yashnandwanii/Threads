import 'dart:convert';

import 'package:get/get.dart';
import 'package:threads/models/notification_model.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/utils/helper.dart';

class NotificationController extends GetxController {
  var loading = false.obs;
  RxList<NotificationModel> notifications = RxList<NotificationModel>();

  void fetchNotifications(String userId) async {
    loading.value = true;
    try {
      final List<dynamic> response =
          await SupabaseServices.client.from("notifications").select('''
    id, post_id, user_id, notification, to_user_id, created_at, user: user_id(email, metadata)
    
    
''').eq("to_user_id", userId).order('created_at', ascending: false);

      if(response.isNotEmpty){
        notifications.value = response
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      loading.value = false;
      
    } catch (e) {
      loading.value = false;
      showSnackBar("Something went wrong", "Error");
    }
  }
}
