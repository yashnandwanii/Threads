import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/controller/profile_controller.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/utils/customOutliendButton.dart';
import 'package:threads/widgets/circle_image.dart';
import 'package:threads/widgets/comment_card.dart';
import 'package:threads/widgets/loading.dart';
import 'package:threads/widgets/post_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileController controller = Get.put(ProfileController());
  final SupabaseServices supabaseServices = Get.find<SupabaseServices>();

  @override
  void initState() {
    controller.fetchPosts(supabaseServices.currentUser.value!.id);
    controller.fetchComments(supabaseServices.currentUser.value!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.language),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              // Navigate to settings page
              Get.toNamed("/settings");
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 160,
                collapsedHeight: 160,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  supabaseServices
                                      .currentUser.value!.userMetadata!["name"],
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: context.width * 0.7,
                                  child: Text(
                                    supabaseServices.currentUser.value!
                                            .userMetadata!["description"] ??
                                        "Threads Clone",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          CircleImage(
                            radius: 40,
                            imageUrl: supabaseServices
                                .currentUser.value!.userMetadata!["image"],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Get.toNamed("/editProfile");
                              },
                              style: customOutlinedButtonStyle(),
                              child: Text("Edit Profile"),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: customOutlinedButtonStyle(),
                              child: Text("Settings"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                floating: true,
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    tabs: [
                      Tab(
                        text: "Threads",
                      ),
                      Tab(
                        text: "Replies",
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Obx(
                () => SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      if (controller.postLoading.value)
                        const Loading()
                      else if (controller.posts.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.posts.length,
                          itemBuilder: (context, index) => PostCard(
                            post: controller.posts[index],
                            isAuthPost: true,
                            callback: controller.deleteThread,
                          ),
                        )
                      else
                        Center(
                          child: const Text("No Threads found."),
                        ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      if (controller.replyLoading.value)
                        const Loading()
                      else if (controller.comments.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.comments.length,
                          itemBuilder: (context, index) => CommentCard(
                            comment: controller.comments[index]!,
                          ),
                        )
                      else
                        Center(
                          child: const Text("No Replies found."),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
