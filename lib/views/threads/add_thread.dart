import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/controller/thread_controller.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/widgets/circle_image.dart';

class AddThread extends StatelessWidget {
  AddThread({super.key});
  final SupabaseServices supabaseServices = Get.find<SupabaseServices>();
  final ThreadController threadController = Get.put(ThreadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('Add Thread'),
        actions: [
          Obx(
            () => TextButton(
              onPressed: () {
                if (threadController.content.value.isNotEmpty) {
                  threadController
                      .storePost(supabaseServices.currentUser.value!.id);
                }
              },
              child: threadController.loading.value == false
                  ? Text('Post')
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => Row(
                  children: [
                    CircleImage(
                      imageUrl: supabaseServices
                          .currentUser.value!.userMetadata?["image"],
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: context.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              supabaseServices
                                  .currentUser.value!.userMetadata?["name"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextField(
                            autofocus: true,
                            controller: threadController.textEditingController,
                            decoration: const InputDecoration(
                              hintText: 'What\'s on your mind?',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) =>
                                threadController.content.value = value,
                            maxLength: 100,
                            minLines: 1,
                            maxLines: 3,
                          ),
                          GestureDetector(
                            onTap: () => threadController.pickImage(),
                            child: Icon(Icons.attach_file),
                          ),

                          // to review user item
                          Obx(
                            () => Column(
                              children: [
                                if (threadController.image.value != null)
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Obx(
                                          () => threadController.image.value !=
                                                  null
                                              ? Image.file(
                                                  threadController.image.value!,
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment.center,
                                                )
                                              : const SizedBox(),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            threadController.image.value = null;
                                          },
                                          icon: const Icon(Icons.close),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
