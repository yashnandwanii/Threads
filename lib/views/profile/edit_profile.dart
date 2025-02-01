import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/controller/profile_controller.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/widgets/circle_image.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileController controller = Get.find<ProfileController>();
  final descontroller = TextEditingController();
  final SupabaseServices supabaseServices = Get.find<SupabaseServices>();

  @override
  void initState() {
    if (supabaseServices.currentUser.value!.userMetadata!["description"] !=
        null) {
      descontroller.text =
          supabaseServices.currentUser.value!.userMetadata!["description"];
    }

    super.initState();
  }

  @override
  void dispose() {
    descontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          Obx(
            () => IconButton(
              icon: controller.loading.value
                  ? CircularProgressIndicator()
                  : Icon(Icons.done),
              onPressed: () {
                // Save the changes
                controller.updateProfile(
                  supabaseServices.currentUser.value!.id,
                  descontroller.text,
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Obx(
              () => Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleImage(
                    radius: 80,
                    filePath: controller.image.value,
                    imageUrl: supabaseServices
                        .currentUser.value!.userMetadata!["image"],
                  ),
                  IconButton(
                    onPressed: () {
                      controller.pickImage();
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.white60,
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descontroller,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Yash Nandwani',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
