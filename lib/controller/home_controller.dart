import 'package:get/get.dart';
import 'package:threads/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Ensure correct package
import 'package:threads/models/user_model.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/utils/helper.dart';

class HomeController extends GetxController {
  var loading = false.obs;
  RxList<PostModel> threads = <PostModel>[].obs;

  @override
  void onInit() async {
    await fetchThreads();
    listenPostChange();
    super.onInit();
  }

  Future<void> fetchThreads() async {
    loading.value = true;

    try {
      final response = await SupabaseServices.client.from("posts").select('''
        id, content, image, created_at, comment_count, like_count, user_id,
        user:user_id (email, metadata), likes:likes (user_id, post_id)
      ''').order('id', ascending: false);

      if (response.isNotEmpty) {
        threads.assignAll(
            response.map((item) => PostModel.fromJson(item)).toList());
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      showSnackBar("Something went wrong while fetching threads", "Error");
    }

    loading.value = false;
  }

  // * Listen for post changes
  void listenPostChange() {
    SupabaseServices.client
        .channel('public:posts')
        .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'posts',
            callback: (payload) {
              final PostModel post = PostModel.fromJson(payload.newRecord);
              updateFeed(post);
            })
        .onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: 'posts',
            callback: (payload) {
              threads.removeWhere(
                  (element) => element.id == payload.oldRecord["id"]);
            })
        .subscribe();
  }

  // // * Update the home feed
  void updateFeed(PostModel post) async {
    var user = await SupabaseServices.client
        .from("users")
        .select("*")
        .eq("id", post.userId!)
        .single();
    post.likes = [];
    post.user = UserModel.fromJson(user);
    threads.insert(0, post);
  }
}
