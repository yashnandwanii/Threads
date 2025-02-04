import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/controller/notification_controller.dart';
import 'package:threads/services/navigation_services.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/utils/helper.dart';
import 'package:threads/widgets/circle_image.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    controller.fetchNotifications(
        Get.find<SupabaseServices>().currentUser.value!.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.find<NavigationServices>().backToPrevPage();
          },
          icon: Icon(Icons.close),
        ),
        title: const Text('Notifications Page'),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => controller.loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    if (controller.notifications.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.notifications.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleImage(
                              imageUrl: controller
                                  .notifications[index].user!.metadata!.image,
                            ),
                            title: Text(controller
                                .notifications[index].user!.metadata!.name!),
                            trailing: Text(formateDateFromNow(
                                controller.notifications[index].createdAt!)),
                            subtitle: Text(
                                controller.notifications[index].notification!),
                          );
                        },
                      )
                    else
                      Text("No notifications found"),
                  ],
                ),
        ),
      ),
    );
  }
}
