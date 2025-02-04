import 'dart:convert';

import 'package:get/get.dart';
import 'package:threads/models/post_model.dart';
import 'package:threads/services/supabase_services.dart';

class HomeController extends GetxController {
  var loading = false.obs;
  RxList<PostModel> threads = RxList<PostModel>();

  @override
  void onInit() async {
    await fetchThreads();
    super.onInit();
  }

  Future<void> fetchThreads() async {
    loading.value = true;
    

    final List<dynamic> response =
        await SupabaseServices.client.from("posts").select('''
        id ,content , image ,created_at ,comment_count, like_count,user_id,
        user:user_id (email , metadata) 
''').order('id', ascending: false);

    print(response);

    if (response.isNotEmpty) {
      threads = [for (var item in response) PostModel.fromJson(item)].obs;
    }

    loading.value = false;
  }
}
